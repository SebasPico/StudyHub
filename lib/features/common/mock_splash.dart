import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Simple mock splash used to guarantee the app displays quickly.
class MockSplash extends StatelessWidget {
  const MockSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.school_rounded, color: Colors.white, size: 56),
              ),
              const SizedBox(height: 18),
              Text('StudyHub', style: AppTextStyles.heading1),
              const SizedBox(height: 8),
              Text('Cargando interfaz…', style: AppTextStyles.body2),
              const SizedBox(height: 24),
              const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
