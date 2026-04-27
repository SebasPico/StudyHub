import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

// Auth
import '../../features/auth/views/login_screen.dart';
import '../../features/auth/views/register_screen.dart';
import '../../features/auth/views/splash_screen.dart';

// Student
import '../../features/student/views/student_main_shell.dart';

// Tutor
import '../../features/tutor/views/tutor_main_shell.dart';

// Search / Detail
import '../../features/search/views/search_screen.dart';
import '../../features/search/views/tutor_detail_screen.dart';

// Booking
import '../../features/booking/views/booking_screen.dart';
import '../../features/booking/views/payment_screen.dart';

// Chat
import '../../features/chat/views/chat_screen.dart';

// Sessions
import '../../features/sessions/views/review_screen.dart';
import '../../features/sessions/views/session_detail_screen.dart';

// Admin
import '../../features/admin/views/admin_dashboard_screen.dart';

// Models
import '../../data/mock/mock_data.dart';
import '../../data/models/tutor_model.dart';
import '../../data/models/session_model.dart';

/// Configuración central de rutas de la aplicación.
class AppRouter {
  AppRouter._();

  static const _authPaths = {'/login', '/register'};

  static String _homeForRole(AuthProvider auth) {
    if (auth.isAdmin) return '/admin';
    if (auth.isTutor) return '/tutor';
    return '/student';
  }

  static bool _hasAllowedPrefix(String path, List<String> prefixes) {
    return prefixes.any(path.startsWith);
  }

  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final auth = context.read<AuthProvider>();
      final path = state.uri.path;

      if (!auth.isInitialized) {
        return path == '/splash' ? null : '/splash';
      }

      if (path == '/splash') {
        return auth.isLoggedIn ? _homeForRole(auth) : '/login';
      }

      if (!auth.isLoggedIn) {
        return _authPaths.contains(path) ? null : '/login';
      }

      if (_authPaths.contains(path)) {
        return _homeForRole(auth);
      }

      if (auth.isStudent) {
        const allowed = [
          '/student',
          '/search',
          '/tutor-detail',
          '/booking',
          '/payment',
          '/chat',
          '/session-detail',
          '/review',
        ];
        return _hasAllowedPrefix(path, allowed) ? null : '/student';
      }

      if (auth.isTutor) {
        const allowed = ['/tutor', '/chat'];
        return _hasAllowedPrefix(path, allowed) ? null : '/tutor';
      }

      if (auth.isAdmin) {
        return path == '/admin' ? null : '/admin';
      }

      return '/login';
    },
    routes: [
      // ── Auth ──
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
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
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final initialTab = (extra?['tab'] as int?) ?? 0;
          return StudentMainShell(initialIndex: initialTab);
        },
      ),
      GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) => const SearchScreen(),
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
        builder: (context, state) {
          final tutor = state.extra;
          return BookingScreen(
            selectedTutor: tutor is TutorModel ? tutor : null,
          );
        },
      ),

      // ── Pago (RF-11) ──
      GoRoute(
        path: '/payment',
        name: 'payment',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return PaymentScreen(
            amount: (extra?['amount'] as num?)?.toDouble() ?? 45000,
            subject: (extra?['subject'] as String?) ?? 'Clase de Tutoría',
            durationMinutes: (extra?['durationMinutes'] as int?) ?? 60,
            tutorName: (extra?['tutorName'] as String?) ?? 'Tutor',
            tutorId: (extra?['tutorId'] as String?) ?? 't1',
            tutorPhoto: extra?['tutorPhoto'] as String?,
            modality: (extra?['modalidad'] as String?) ?? 'Online',
            fechaHoraMs: (extra?['fechaHoraMs'] as int?) ??
                DateTime.now()
                    .add(const Duration(days: 2))
                    .millisecondsSinceEpoch,
          );
        },
      ),

      // ── Chat (RF-14) ──
      GoRoute(
        path: '/chat/:conversationId',
        name: 'chat',
        builder: (context, state) {
          final convId = state.pathParameters['conversationId']!;
          final extra = state.extra as Map<String, dynamic>?;
          return ChatScreen(
            conversationId: convId,
            otherUserName: (extra?['name'] as String?) ?? 'Usuario',
            otherUserPhoto: extra?['photo'] as String?,
            otherUserId: (extra?['userId'] as String?) ?? convId,
          );
        },
      ),

      // ── Calificar (RF-15) ──
      GoRoute(
        path: '/review',
        name: 'review',
        builder: (context, state) {
          final session = state.extra as SessionModel?;
          return ReviewScreen(session: session);
        },
      ),

      GoRoute(
        path: '/session-detail/:id',
        name: 'sessionDetail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return SessionDetailScreen(sessionId: id);
        },
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
