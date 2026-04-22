import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/star_rating.dart';
import '../../../core/widgets/custom_avatar.dart';
import '../../../core/providers/session_provider.dart';
import '../../../data/models/session_model.dart';
import '../../../data/models/review_model.dart';

/// Pantalla para calificar una sesión (RF-15).
class ReviewScreen extends StatefulWidget {
  final SessionModel? session;

  const ReviewScreen({super.key, this.session});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  double _rating = 0;
  final _commentController = TextEditingController();
  final List<String> _selectedTags = [];

  String get _tutorName =>
      widget.session?.tutorNombre ?? 'Ana Martínez';
  String? get _tutorPhoto => widget.session?.tutorFotoUrl;
  String get _materia =>
      widget.session?.materia ?? 'Física Mecánica';
  String get _fecha {
    final s = widget.session;
    if (s == null) return '25/02/2026 - 16:00';
    return '${s.fechaHora.day}/${s.fechaHora.month}/${s.fechaHora.year} - ${s.fechaHora.hour}:${s.fechaHora.minute.toString().padLeft(2, '0')}';
  }

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
            CustomAvatar(
              imageUrl: _tutorPhoto,
              size: 72,
              initials: _tutorName.substring(0, 2).toUpperCase(),
            ),
            const SizedBox(height: 12),
            Text(_tutorName, style: AppTextStyles.heading3),
            Text(_materia, style: AppTextStyles.body2),
            Text(_fecha, style: AppTextStyles.caption),
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
                _TagChip(label: 'Puntual', icon: Icons.timer,
                    onToggle: (v) => v ? _selectedTags.add('Puntual') : _selectedTags.remove('Puntual')),
                _TagChip(label: 'Explica bien', icon: Icons.lightbulb_outline,
                    onToggle: (v) => v ? _selectedTags.add('Explica bien') : _selectedTags.remove('Explica bien')),
                _TagChip(label: 'Paciente', icon: Icons.favorite_outline,
                    onToggle: (v) => v ? _selectedTags.add('Paciente') : _selectedTags.remove('Paciente')),
                _TagChip(label: 'Domina el tema', icon: Icons.school_outlined,
                    onToggle: (v) => v ? _selectedTags.add('Domina el tema') : _selectedTags.remove('Domina el tema')),
                _TagChip(label: 'Preparado', icon: Icons.check_circle_outline,
                    onToggle: (v) => v ? _selectedTags.add('Preparado') : _selectedTags.remove('Preparado')),
                _TagChip(label: 'Amable', icon: Icons.sentiment_satisfied,
                    onToggle: (v) => v ? _selectedTags.add('Amable') : _selectedTags.remove('Amable')),
              ],
            ),
            const SizedBox(height: 40),

            PrimaryButton(
              text: 'Enviar Calificación',
              icon: Icons.send,
              onPressed: _rating > 0
                  ? () {
                      final session = widget.session;
                      if (session != null) {
                        final tagText = _selectedTags.isNotEmpty
                            ? '\n\nDestacado: ${_selectedTags.join(', ')}'
                            : '';
                        context.read<SessionProvider>().addReview(
                              ReviewModel(
                                id: 'r_${DateTime.now().millisecondsSinceEpoch}',
                                sesionId: session.id,
                                tutorId: session.tutorId,
                                estudianteId: 'e1',
                                estudianteNombre: 'Juan Pérez',
                                estudianteFotoUrl:
                                    'https://i.pravatar.cc/150?img=11',
                                calificacion: _rating,
                                comentario:
                                    '${_commentController.text.trim()}$tagText',
                                fecha: DateTime.now(),
                              ),
                            );
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('¡Gracias por tu calificación!'),
                          backgroundColor: AppColors.secondary,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                      context.pop();
                    }
                  : null,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String get _ratingLabel {    if (_rating >= 5) return '¡Excelente!';
    if (_rating >= 4) return 'Muy buena';
    if (_rating >= 3) return 'Buena';
    if (_rating >= 2) return 'Regular';
    if (_rating >= 1) return 'Mala';
    return '';
  }

}

class _TagChip extends StatefulWidget {
  final String label;
  final IconData icon;
  final void Function(bool) onToggle;

  const _TagChip({
    required this.label,
    required this.icon,
    required this.onToggle,
  });

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
      onSelected: (v) {
        setState(() => _selected = v);
        widget.onToggle(v);
      },
      selectedColor: AppColors.primary.withValues(alpha: 0.15),
      checkmarkColor: AppColors.primary,
    );
  }
}
