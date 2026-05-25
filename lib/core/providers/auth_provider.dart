import 'package:flutter/foundation.dart';
import '../../data/models/auth_session_model.dart';
import '../../data/models/auth_failure.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/mock_auth_repository.dart';
import '../services/biometric_service.dart';
import '../services/studyhub_local_backend.dart';
import '../services/auth_session_storage.dart';

/// Gestión del estado de autenticación y perfil del usuario actual.
class AuthProvider extends ChangeNotifier {
  final AuthSessionStorage _storage;
  final AuthRepository _authRepository;
  final StudyHubLocalBackend _backend;
  UserRole? _role;
  String _userId = '';
  String _userName = '';
  String? _userPhoto;
  String _userLocation = '';
  String _userPhone = '';
  AuthSessionModel? _pendingBiometricSession;
  bool _isInitialized = false;

  AuthProvider({
    AuthSessionStorage? storage,
    AuthRepository? authRepository,
    StudyHubLocalBackend? backend,
  })  : _storage = storage ?? AuthSessionStorage(),
        _authRepository = authRepository ?? MockAuthRepository(),
        _backend = backend ?? StudyHubLocalBackend.instance {
    initialize();
  }

  UserRole? get role => _role;
  bool get isLoggedIn => _role != null;
  bool get isInitialized => _isInitialized;
  bool get isAdmin => _role == UserRole.administrador;
  bool get isTutor => _role == UserRole.tutor;
  bool get isStudent => _role == UserRole.estudiante;
  String get userId => _userId;
  String get userName => _userName;
  String? get userPhoto => _userPhoto;
  String get userLocation => _userLocation;
  String get userPhone => _userPhone;
  bool get needsBiometricUnlock => _pendingBiometricSession != null && _role == null;

  void _applySession(AuthSessionModel session) {
    _role = session.role;
    _userId = session.userId;
    _userName = session.userName;
    _userPhoto = session.userPhoto;
    _userLocation = session.userLocation;
    _userPhone = session.userPhone;
  }

  Future<void> initialize() async {
    final raw = await _storage.read();
    final biometricEnabled = await _storage.isBiometricEnabled();
    try {
      // Avoid blocking splash indefinitely if SharedPreferences is slow.
      final raw = await _storage.read().timeout(const Duration(seconds: 2));
      final roleRaw = raw['role'];
      if (roleRaw != null && roleRaw.isNotEmpty) {
        final session = AuthSessionModel(
          role: _parseRole(roleRaw),
          userId: raw['userId'] ?? '',
          userName: raw['userName'] ?? '',
          userPhoto: raw['userPhoto'],
          userLocation: raw['userLocation'] ?? '',
          userPhone: raw['userPhone'] ?? '',
        );

        if (biometricEnabled) {
          _pendingBiometricSession = session;
        } else {
          _applySession(session);
        }
      }
    } catch (e) {
      // If reading storage times out or fails, proceed so the UI can continue.
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  UserRole _parseRole(String raw) {
    switch (raw) {
      case 'administrador':
        return UserRole.administrador;
      case 'tutor':
        return UserRole.tutor;
      default:
        return UserRole.estudiante;
    }
  }

  String _roleToRaw(UserRole role) {
    switch (role) {
      case UserRole.administrador:
        return 'administrador';
      case UserRole.tutor:
        return 'tutor';
      case UserRole.estudiante:
        return 'estudiante';
    }
  }

  Future<void> _persistCurrentSession() {
    if (_role == null) return _storage.clear();

    return _storage.write(
      role: _roleToRaw(_role!),
      userId: _userId,
      userName: _userName,
      userPhoto: _userPhoto,
      userLocation: _userLocation,
      userPhone: _userPhone,
    );
  }

  Future<void> setBiometricEnabled(bool enabled) {
    return _storage.setBiometricEnabled(enabled);
  }

  Future<String?> unlockWithBiometrics() async {
    if (_pendingBiometricSession == null) {
      return 'No hay una sesión biométrica pendiente';
    }

    final biometric = BiometricService.instance;
    final authenticated = await biometric.authenticate(
      reason: 'Desbloquea tu sesión de StudyHub',
    );
    if (!authenticated) {
      return 'No se pudo validar tu biometría';
    }

    _applySession(_pendingBiometricSession!);
    _pendingBiometricSession = null;
    await _persistCurrentSession();
    notifyListeners();
    return null;
  }

  String _mapFailureToMessage(AuthFailure failure) {
    if (failure.message != null && failure.message!.trim().isNotEmpty) {
      return failure.message!;
    }

    switch (failure.code) {
      case AuthFailureCode.invalidCredentials:
        return 'Correo o contrasena invalidos';
      case AuthFailureCode.userAlreadyExists:
        return 'Ya existe una cuenta con ese correo';
      case AuthFailureCode.network:
        return 'Sin conexion. Revisa tu internet';
      case AuthFailureCode.server:
        return 'No pudimos autenticarte. Intenta nuevamente';
      case AuthFailureCode.notImplemented:
        return 'Autenticacion API aun no implementada';
      case AuthFailureCode.unknown:
        return 'Ocurrio un error inesperado';
    }
  }

  /// Autentica por repositorio. Devuelve null si exitoso.
  Future<String?> login(String email, {String password = ''}) async {
    try {
      final session = await _authRepository.login(
        email: email,
        password: password,
      );

      _applySession(session);
      _pendingBiometricSession = null;
      await _persistCurrentSession();
      notifyListeners();
      return null;
    } on AuthFailure catch (failure) {
      return _mapFailureToMessage(failure);
    } catch (_) {
      return _mapFailureToMessage(
        const AuthFailure(AuthFailureCode.unknown),
      );
    }
  }

  /// Registra un usuario por repositorio. Devuelve null si exitoso.
  Future<String?> register(
    String nombre,
    String email,
    UserRole rol, {
    String password = '',
  }) async {
    try {
      final session = await _authRepository.register(
        nombre: nombre,
        email: email,
        rol: rol,
        password: password,
      );
      _applySession(session);
      _pendingBiometricSession = null;
      await _persistCurrentSession();
      notifyListeners();
      return null;
    } on AuthFailure catch (failure) {
      return _mapFailureToMessage(failure);
    } catch (_) {
      return _mapFailureToMessage(
        const AuthFailure(AuthFailureCode.unknown),
      );
    }
  }

  /// Cierra la sesión actual.
  void logout() {
    _role = null;
    _userId = '';
    _userName = '';
    _userPhoto = null;
    _userLocation = '';
    _userPhone = '';
    _pendingBiometricSession = null;
    _storage.clear();
    notifyListeners();
  }

  /// Actualiza los datos del perfil en memoria.
  Future<void> updateProfile({String? nombre, String? ubicacion, String? telefono}) async {
    if (nombre != null && nombre.isNotEmpty) _userName = nombre;
    if (ubicacion != null) _userLocation = ubicacion;
    if (telefono != null) _userPhone = telefono;
    await _backend.updateCurrentUserProfile(
      userId: _userId,
      nombre: _userName,
      ubicacion: _userLocation,
      telefono: _userPhone,
      fotoUrl: _userPhoto,
    );
    _persistCurrentSession();
    notifyListeners();
  }
}
