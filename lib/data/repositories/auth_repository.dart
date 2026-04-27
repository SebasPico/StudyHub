import '../models/auth_session_model.dart';
import '../models/user_model.dart';

/// Contrato de autenticacion para desacoplar UI/Provider del backend.
abstract class AuthRepository {
  Future<AuthSessionModel?> login({
    required String email,
    required String password,
  });

  Future<AuthSessionModel> register({
    required String nombre,
    required String email,
    required UserRole rol,
    required String password,
  });
}
