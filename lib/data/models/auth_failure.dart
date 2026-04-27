/// Tipos de fallo de autenticacion para manejo consistente en UI.
enum AuthFailureCode {
  invalidCredentials,
  userAlreadyExists,
  network,
  server,
  notImplemented,
  unknown,
}

/// Error tipado de autenticacion lanzado por repositorios.
class AuthFailure implements Exception {
  final AuthFailureCode code;
  final String? message;

  const AuthFailure(this.code, {this.message});
}
