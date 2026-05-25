import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Notificaciones locales para eventos importantes de la app.
class AppNotificationService {
  static final AppNotificationService instance = AppNotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  AppNotificationService._();

  Future<void> initialize() async {
    if (_initialized) return;

    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _plugin.initialize(initializationSettings);

    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.requestNotificationsPermission();

    _initialized = true;
  }

  Future<void> showBookingConfirmed({
    required String tutorName,
    required String subject,
    required DateTime dateTime,
  }) async {
    await _show(
      id: 1001,
      title: 'Clase agendada',
      body:
          'Tu clase de $subject con $tutorName quedó programada para ${dateTime.day}/${dateTime.month}.',
    );
  }

  Future<void> _show({
    required int id,
    required String title,
    required String body,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'studyhub_events',
        'Eventos de StudyHub',
        channelDescription: 'Notificaciones de reservas y actividad de la app',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    await _plugin.show(id, title, body, details);
  }
}