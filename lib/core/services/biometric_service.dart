import 'package:local_auth/local_auth.dart';

/// Utilidad para autenticación biométrica en dispositivos compatibles.
class BiometricService {
  static final BiometricService instance = BiometricService._();

  final LocalAuthentication _localAuth = LocalAuthentication();

  BiometricService._();

  Future<bool> canAuthenticate() async {
    try {
      return await _localAuth.isDeviceSupported() ||
          await _localAuth.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  Future<bool> authenticate({required String reason}) async {
    try {
      if (!await canAuthenticate()) return false;
      return _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }
}