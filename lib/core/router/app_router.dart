import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Auth
import '../../features/auth/views/login_screen.dart';
import '../../features/auth/views/register_screen.dart';

// Student
import '../../features/student/views/student_main_shell.dart';

// Tutor
import '../../features/tutor/views/tutor_main_shell.dart';

// Search / Detail
import '../../features/search/views/tutor_detail_screen.dart';

// Booking
import '../../features/booking/views/booking_screen.dart';
import '../../features/booking/views/payment_screen.dart';

// Chat
import '../../features/chat/views/chat_screen.dart';

// Sessions
import '../../features/sessions/views/review_screen.dart';

// Admin
import '../../features/admin/views/admin_dashboard_screen.dart';

// Models
import '../../data/mock/mock_data.dart';

/// Configuración central de rutas de la aplicación.
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      // ── Auth ──
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // ── Estudiante ──
      GoRoute(
        path: '/student',
        name: 'studentHome',
        builder: (context, state) => const StudentMainShell(),
      ),

      // ── Tutor ──
      GoRoute(
        path: '/tutor',
        name: 'tutorHome',
        builder: (context, state) => const TutorMainShell(),
      ),

      // ── Detalle de tutor (RF-07) ──
      GoRoute(
        path: '/tutor-detail/:id',
        name: 'tutorDetail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final tutor = MockData.tutores.firstWhere((t) => t.id == id);
          return TutorDetailScreen(tutor: tutor);
        },
      ),

      // ── Agendar clase (RF-09) ──
      GoRoute(
        path: '/booking',
        name: 'booking',
        builder: (context, state) => const BookingScreen(),
      ),

      // ── Pago (RF-11) ──
      GoRoute(
        path: '/payment',
        name: 'payment',
        builder: (context, state) => const PaymentScreen(),
      ),

      // ── Chat (RF-14) ──
      GoRoute(
        path: '/chat/:conversationId',
        name: 'chat',
        builder: (context, state) {
          final convId = state.pathParameters['conversationId']!;
          final extra = state.extra as Map<String, String>?;
          return ChatScreen(
            conversationId: convId,
            otherUserName: extra?['name'] ?? 'Usuario',
            otherUserPhoto: extra?['photo'],
          );
        },
      ),

      // ── Calificar (RF-15) ──
      GoRoute(
        path: '/review',
        name: 'review',
        builder: (context, state) => const ReviewScreen(),
      ),

      // ── Admin ──
      GoRoute(
        path: '/admin',
        name: 'admin',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
    ],
  );
}
