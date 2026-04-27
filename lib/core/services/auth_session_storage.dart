import 'package:shared_preferences/shared_preferences.dart';

/// Persistencia local de la sesion de autenticacion.
class AuthSessionStorage {
  static const _kRole = 'auth.role';
  static const _kUserId = 'auth.userId';
  static const _kUserName = 'auth.userName';
  static const _kUserPhoto = 'auth.userPhoto';
  static const _kUserLocation = 'auth.userLocation';
  static const _kUserPhone = 'auth.userPhone';

  Future<Map<String, String?>> read() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString(_kRole);
    if (role == null || role.isEmpty) return const {};

    return {
      'role': role,
      'userId': prefs.getString(_kUserId),
      'userName': prefs.getString(_kUserName),
      'userPhoto': prefs.getString(_kUserPhoto),
      'userLocation': prefs.getString(_kUserLocation),
      'userPhone': prefs.getString(_kUserPhone),
    };
  }

  Future<void> write({
    required String role,
    required String userId,
    required String userName,
    String? userPhoto,
    String userLocation = '',
    String userPhone = '',
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kRole, role);
    await prefs.setString(_kUserId, userId);
    await prefs.setString(_kUserName, userName);

    if (userPhoto != null && userPhoto.isNotEmpty) {
      await prefs.setString(_kUserPhoto, userPhoto);
    } else {
      await prefs.remove(_kUserPhoto);
    }

    await prefs.setString(_kUserLocation, userLocation);
    await prefs.setString(_kUserPhone, userPhone);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kRole);
    await prefs.remove(_kUserId);
    await prefs.remove(_kUserName);
    await prefs.remove(_kUserPhoto);
    await prefs.remove(_kUserLocation);
    await prefs.remove(_kUserPhone);
  }
}
