import 'package:flutter/material.dart';
import '../../tutor/views/tutor_home_screen.dart';
import '../../tutor/views/tutor_schedule_screen.dart';
import '../../sessions/views/session_history_screen.dart';
import '../../chat/views/conversations_screen.dart';
import '../../tutor/views/tutor_profile_screen.dart';
import '../../../core/theme/app_colors.dart';

/// Shell con BottomNavigationBar para el tutor.
class TutorMainShell extends StatefulWidget {
  const TutorMainShell({super.key});

  @override
  State<TutorMainShell> createState() => _TutorMainShellState();
}

class _TutorMainShellState extends State<TutorMainShell> {
  int _currentIndex = 0;

  final _screens = const [
    TutorHomeScreen(),
    TutorScheduleScreen(),
    SessionHistoryScreen(),
    ConversationsScreen(),
    TutorProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textHint,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Horarios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'Clases',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
