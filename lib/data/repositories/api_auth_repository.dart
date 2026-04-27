import '../models/auth_failure.dart';
import '../models/auth_session_model.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';

/// Implementacion base para backend real (REST/Firebase/etc.).
///
/// Actualmente deja trazado el contrato y falla de forma controlada
/// hasta que se conecte un proveedor real de autenticacion.
class ApiAuthRepository implements AuthRepository {
  final Duration simulatedLatency;

  const ApiAuthRepository({
    this.simulatedLatency = const Duration(milliseconds: 350),
  });

  @override
  Future<AuthSessionModel> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(simulatedLatency);
    throw const AuthFailure(
      AuthFailureCode.notImplemented,
      message: 'Auth API aun no implementada',
    );
  }

  @override
  Future<AuthSessionModel> register({
    required String nombre,
    required String email,
    required UserRole rol,
    required String password,
  }) async {
    await Future<void>.delayed(simulatedLatency);
    throw const AuthFailure(
      AuthFailureCode.notImplemented,
      message: 'Registro API aun no implementado',
    );
  }
}
