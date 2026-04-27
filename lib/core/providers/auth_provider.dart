import 'package:flutter/foundation.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/user_model.dart';
import '../services/auth_session_storage.dart';

/// Gestión del estado de autenticación y perfil del usuario actual.
class AuthProvider extends ChangeNotifier {
  final AuthSessionStorage _storage = AuthSessionStorage();
  UserRole? _role;
  String _userId = '';
  String _userName = '';
  String? _userPhoto;
  String _userLocation = '';
  String _userPhone = '';
  bool _isInitialized = false;

  AuthProvider() {
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

  Future<void> initialize() async {
    final raw = await _storage.read();
    final roleRaw = raw['role'];
    if (roleRaw != null && roleRaw.isNotEmpty) {
      _role = _parseRole(roleRaw);
      _userId = raw['userId'] ?? '';
      _userName = raw['userName'] ?? '';
      _userPhoto = raw['userPhoto'];
      _userLocation = raw['userLocation'] ?? '';
      _userPhone = raw['userPhone'] ?? '';
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

  /// Autentica por email (mock). Devuelve null si exitoso.
  String? login(String email) {
    final emailLower = email.trim().toLowerCase();

    // Administrador
    if (emailLower == 'admin@studyhub.com') {
      _role = UserRole.administrador;
      _userId = 'admin1';
      _userName = 'Administrador';
      _userPhoto = null;
      _userLocation = '';
      _userPhone = '';
      _persistCurrentSession();
      notifyListeners();
      return null;
    }

    // Tutor
    final tutor = MockData.tutores
        .where((t) => t.correo.toLowerCase() == emailLower)
        .firstOrNull;
    if (tutor != null) {
      _role = UserRole.tutor;
      _userId = tutor.id;
      _userName = tutor.nombre;
      _userPhoto = tutor.fotoUrl;
      _userLocation = tutor.ubicacion ?? '';
      _userPhone = tutor.telefono ?? '';
      _persistCurrentSession();
      notifyListeners();
      return null;
    }

    // Cualquier otro correo válido = estudiante
    final student = MockData.estudianteActual;
    _role = UserRole.estudiante;
    _userId = student.id;
    _userName = student.nombre;
    _userPhoto = student.fotoUrl;
    _userLocation = student.ubicacion ?? '';
    _userPhone = student.telefono ?? '';
    _persistCurrentSession();
    notifyListeners();
    return null;
  }

  /// Registra un usuario nuevo (mock: no persiste entre sesiones).
  void register(String nombre, String email, UserRole rol) {
    _role = rol == UserRole.tutor ? UserRole.tutor : UserRole.estudiante;
    _userId = rol == UserRole.tutor ? 't_new' : 'e_new';
    _userName = nombre;
    _userPhoto = null;
    _userLocation = '';
    _userPhone = '';
    _persistCurrentSession();
    notifyListeners();
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
