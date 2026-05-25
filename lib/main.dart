import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/session_provider.dart';
import 'core/providers/tutor_provider.dart';
import 'core/providers/chat_provider.dart';
import 'core/services/studyhub_local_backend.dart';
import 'core/services/app_notification_service.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/local_json_auth_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final backend = StudyHubLocalBackend.instance;
  // Load backend in background to avoid blocking the first frame.
  backend.load().then((_) {
    // Notify listeners in case providers need to refresh UI after load.
    try {
      backend.notifyListeners();
    } catch (_) {}
  });

  // Initialize notifications asynchronously; don't await to keep startup fast.
  AppNotificationService.instance.initialize();

  runApp(TutoriasApp(backend: backend));
}

AuthRepository _buildAuthRepository(StudyHubLocalBackend backend) {
  return LocalJsonAuthRepository(backend: backend);
}

/// Punto de entrada de la aplicación TutoríasApp.
class TutoriasApp extends StatelessWidget {
  final StudyHubLocalBackend backend;

  const TutoriasApp({super.key, required this.backend});

  @override
  Widget build(BuildContext context) {
    final authRepository = _buildAuthRepository(backend);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            backend: backend,
            authRepository: authRepository,
          ),
        ),
        ChangeNotifierProvider(create: (_) => SessionProvider(backend: backend)),
        ChangeNotifierProvider(create: (_) => TutorProvider(backend: backend)),
        ChangeNotifierProvider(create: (_) => ChatProvider(backend: backend)),
      ],
      child: MaterialApp.router(
        title: 'TutoríasApp',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
