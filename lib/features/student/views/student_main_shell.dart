import 'package:flutter/material.dart';
import '../../student/views/student_home_screen.dart';
import '../../search/views/search_screen.dart';
import '../../sessions/views/session_history_screen.dart';
import '../../chat/views/conversations_screen.dart';
import '../../student/views/student_profile_screen.dart';
import '../../../core/theme/app_colors.dart';

/// Shell con BottomNavigationBar para el estudiante.
class StudentMainShell extends StatefulWidget {
  final int initialIndex;

  const StudentMainShell({super.key, this.initialIndex = 0});

  @override
  State<StudentMainShell> createState() => _StudentMainShellState();
}

class _StudentMainShellState extends State<StudentMainShell> {
  late int _currentIndex;

  final _screens = const [
    StudentHomeScreen(),
    SearchScreen(),
    SessionHistoryScreen(),
    ConversationsScreen(),
    StudentProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    final idx = widget.initialIndex;
    _currentIndex = idx >= 0 && idx < _screens.length ? idx : 0;
  }

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
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Buscar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
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
