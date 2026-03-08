import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/star_rating.dart';
import '../../../core/widgets/custom_avatar.dart';

/// Pantalla para calificar una sesión (RF-15).
class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  double _rating = 0;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calificar Clase')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Info de la sesión
            const CustomAvatar(
              size: 72,
              initials: 'AM',
            ),
            const SizedBox(height: 12),
            Text('Ana Martínez', style: AppTextStyles.heading3),
            Text('Física Mecánica', style: AppTextStyles.body2),
            Text('25/02/2026 - 16:00', style: AppTextStyles.caption),
            const SizedBox(height: 32),

            // Rating
            Text('¿Cómo estuvo la clase?', style: AppTextStyles.heading3),
            const SizedBox(height: 8),
            Text(
              'Tu opinión ayuda a otros estudiantes',
              style: AppTextStyles.body2,
            ),
            const SizedBox(height: 20),
            StarRating(
              rating: _rating,
              size: 44,
              allowEdit: true,
              onRatingChanged: (value) {
                setState(() => _rating = value);
              },
            ),
            const SizedBox(height: 8),
            Text(
              _ratingLabel,
              style: AppTextStyles.subtitle1.copyWith(
                color: AppColors.starFilled,
              ),
            ),
            const SizedBox(height: 32),

            // Comentario
            Align(
              alignment: Alignment.centerLeft,
              child:
                  Text('Deja un comentario', style: AppTextStyles.subtitle1),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText:
                    'Cuéntanos tu experiencia con este tutor...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Tags rápidos
            Align(
              alignment: Alignment.centerLeft,
              child: Text('¿Qué destacarías?', style: AppTextStyles.subtitle1),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _TagChip(label: 'Puntual', icon: Icons.timer),
                _TagChip(label: 'Explica bien', icon: Icons.lightbulb_outline),
                _TagChip(label: 'Paciente', icon: Icons.favorite_outline),
                _TagChip(label: 'Domina el tema', icon: Icons.school_outlined),
                _TagChip(label: 'Preparado', icon: Icons.check_circle_outline),
                _TagChip(label: 'Amable', icon: Icons.sentiment_satisfied),
              ],
            ),
            const SizedBox(height: 40),

            PrimaryButton(
              text: 'Enviar Calificación',
              icon: Icons.send,
              onPressed: _rating > 0
                  ? () {
                      _showSuccessSnackbar(context);
                    }
                  : null,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String get _ratingLabel {
    if (_rating >= 5) return '¡Excelente!';
    if (_rating >= 4) return 'Muy buena';
    if (_rating >= 3) return 'Buena';
    if (_rating >= 2) return 'Regular';
    if (_rating >= 1) return 'Mala';
    return '';
  }

  void _showSuccessSnackbar(BuildContext ctx) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: const Text('¡Gracias por tu calificación!'),
        backgroundColor: AppColors.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class _TagChip extends StatefulWidget {
  final String label;
  final IconData icon;

  const _TagChip({required this.label, required this.icon});

  @override
  State<_TagChip> createState() => _TagChipState();
}

class _TagChipState extends State<_TagChip> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.label),
      avatar: Icon(widget.icon, size: 16),
      selected: _selected,
      onSelected: (v) => setState(() => _selected = v),
      selectedColor: AppColors.primary.withValues(alpha: 0.15),
      checkmarkColor: AppColors.primary,
    );
  }
}
