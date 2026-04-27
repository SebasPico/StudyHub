import 'user_model.dart';

/// Datos de sesion autenticada que la app usa en memoria.
class AuthSessionModel {
  final UserRole role;
  final String userId;
  final String userName;
  final String? userPhoto;
  final String userLocation;
  final String userPhone;

  const AuthSessionModel({
    required this.role,
    required this.userId,
    required this.userName,
    this.userPhoto,
    this.userLocation = '',
    this.userPhone = '',
  });
}
