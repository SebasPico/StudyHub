import '../../core/services/studyhub_local_backend.dart';
import '../models/auth_session_model.dart';
import '../models/auth_failure.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';

/// Implementacion de autenticacion sobre el backend local en JSON.
class LocalJsonAuthRepository implements AuthRepository {
  final StudyHubLocalBackend backend;

  const LocalJsonAuthRepository({required this.backend});

  @override
  Future<AuthSessionModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final session = await backend.authenticate(email, password);
      return AuthSessionModel(
        role: session.role,
        userId: session.userId,
        userName: session.userName,
        userPhoto: session.userPhoto,
        userLocation: session.userLocation,
        userPhone: session.userPhone,
      );
    } on StateError catch (e) {
      final msg = e.message ?? '';
      if (msg.contains('invalid_credentials')) {
        throw AuthFailure(AuthFailureCode.invalidCredentials);
      }
      throw AuthFailure(AuthFailureCode.unknown);
    }
  }

  @override
  Future<AuthSessionModel> register({
    required String nombre,
    required String email,
    required UserRole rol,
    required String password,
  }) async {
    try {
      final session = await backend.register(
        nombre: nombre,
        email: email,
        rol: rol,
        password: password,
      );
      return AuthSessionModel(
        role: session.role,
        userId: session.userId,
        userName: session.userName,
        userPhoto: session.userPhoto,
        userLocation: session.userLocation,
        userPhone: session.userPhone,
      );
    } on StateError catch (e) {
      final msg = e.message ?? '';
      if (msg.contains('user_exists')) {
        throw AuthFailure(AuthFailureCode.userAlreadyExists);
      }
      throw AuthFailure(AuthFailureCode.unknown);
    }
  }
}
