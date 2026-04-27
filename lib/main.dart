import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/session_provider.dart';
import 'core/providers/tutor_provider.dart';
import 'core/providers/chat_provider.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/api_auth_repository.dart';
import 'data/repositories/mock_auth_repository.dart';

void main() {
  runApp(const TutoriasApp());
}

AuthRepository _buildAuthRepository() {
  const useMockAuth = bool.fromEnvironment('USE_MOCK_AUTH', defaultValue: true);
  if (useMockAuth) return MockAuthRepository();
  return const ApiAuthRepository();
}

/// Punto de entrada de la aplicación TutoríasApp.
class TutoriasApp extends StatelessWidget {
  const TutoriasApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = _buildAuthRepository();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authRepository: authRepository),
        ),
        ChangeNotifierProvider(create: (_) => SessionProvider()),
        ChangeNotifierProvider(create: (_) => TutorProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
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
