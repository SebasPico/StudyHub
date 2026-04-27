import 'package:flutter/foundation.dart';
import '../../data/models/auth_session_model.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/mock_auth_repository.dart';
import '../services/auth_session_storage.dart';

/// Gestión del estado de autenticación y perfil del usuario actual.
class AuthProvider extends ChangeNotifier {
  final AuthSessionStorage _storage;
  final AuthRepository _authRepository;
  UserRole? _role;
  String _userId = '';
  String _userName = '';
  String? _userPhoto;
  String _userLocation = '';
  String _userPhone = '';
  bool _isInitialized = false;

  AuthProvider({
    AuthSessionStorage? storage,
    AuthRepository? authRepository,
  })  : _storage = storage ?? AuthSessionStorage(),
        _authRepository = authRepository ?? MockAuthRepository() {
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
    final roleRaw = raw['role'];
    if (roleRaw != null && roleRaw.isNotEmpty) {
      _applySession(AuthSessionModel(
        role: _parseRole(roleRaw),
        userId: raw['userId'] ?? '',
        userName: raw['userName'] ?? '',
        userPhoto: raw['userPhoto'],
        userLocation: raw['userLocation'] ?? '',
        userPhone: raw['userPhone'] ?? '',
      ));
    }

    _isInitialized = true;
    notifyListeners();
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

  /// Autentica por repositorio. Devuelve null si exitoso.
  Future<String?> login(String email, {String password = ''}) async {
    final session = await _authRepository.login(
      email: email,
      password: password,
    );

    if (session == null) {
      return 'Credenciales invalidas';
    }

    _applySession(session);
    await _persistCurrentSession();
    notifyListeners();
    return null;
  }

  /// Registra un usuario por repositorio. Devuelve null si exitoso.
  Future<String?> register(
    String nombre,
    String email,
    UserRole rol, {
    String password = '',
  }) async {
    final session = await _authRepository.register(
      nombre: nombre,
      email: email,
      rol: rol,
      password: password,
    );
    _applySession(session);
    await _persistCurrentSession();
    notifyListeners();
    return null;
  }

  /// Cierra la sesión actual.
  void logout() {
    _role = null;
    _userId = '';
    _userName = '';
    _userPhoto = null;
    _userLocation = '';
    _userPhone = '';
    _storage.clear();
    notifyListeners();
  }

  /// Actualiza los datos del perfil en memoria.
  void updateProfile({String? nombre, String? ubicacion, String? telefono}) {
    if (nombre != null && nombre.isNotEmpty) _userName = nombre;
    if (ubicacion != null) _userLocation = ubicacion;
    if (telefono != null) _userPhone = telefono;
    _persistCurrentSession();
    notifyListeners();
  }
}
