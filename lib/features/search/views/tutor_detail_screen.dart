import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/custom_avatar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/star_rating.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/widgets/section_header.dart';
import '../../../data/mock/mock_data.dart';
import '../../../data/models/tutor_model.dart';

/// Pantalla de detalle del perfil de un tutor (RF-07).
class TutorDetailScreen extends StatelessWidget {
  final TutorModel tutor;

  const TutorDetailScreen({super.key, required this.tutor});

  @override
  Widget build(BuildContext context) {
    final resenas =
        MockData.resenas.where((r) => r.tutorId == tutor.id).toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header con imagen
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      CustomAvatar(
                        imageUrl: tutor.fotoUrl,
                        size: 80,
                        initials: tutor.nombre.substring(0, 2),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            tutor.nombre,
                            style: AppTextStyles.heading3
                                .copyWith(color: Colors.white),
                          ),
                          if (tutor.verificado) ...[
                            const SizedBox(width: 4),
                            const Icon(Icons.verified,
                                color: Colors.white, size: 18),
                          ],
                        ],
                      ),
                      Text(
                        tutor.ubicacion ?? '',
                        style: AppTextStyles.body2
                            .copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats row
                  Row(
                    children: [
                      _InfoTile(
                        icon: Icons.star_rounded,
                        value: '${tutor.calificacionPromedio}',
                        label: '${tutor.totalResenas} reseñas',
                        color: AppColors.starFilled,
                      ),
                      const SizedBox(width: 12),
                      _InfoTile(
                        icon: Icons.school,
                        value: '${tutor.clasesImpartidas}',
                        label: 'Clases',
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 12),
                      _InfoTile(
                        icon: Icons.attach_money,
                        value: '\$${tutor.tarifaPorHora.toStringAsFixed(0)}',
                        label: 'por hora',
                        color: AppColors.secondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Modalidad
                  Row(
                    children: [
                      ModalityBadge(
                        modality: tutor.modalidad == Modalidad.online ||
                                tutor.modalidad == Modalidad.ambas
                            ? AppConstants.modalidadOnline
                            : AppConstants.modalidadPresencial,
                      ),
                      if (tutor.modalidad == Modalidad.ambas) ...[
                        const SizedBox(width: 8),
                        const ModalityBadge(
                            modality: AppConstants.modalidadPresencial),
                      ],
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Biografía
                  Text('Sobre mí', style: AppTextStyles.heading3),
                  const SizedBox(height: 8),
                  Text(tutor.biografia, style: AppTextStyles.body1),
                  const SizedBox(height: 20),

                  // Materias
                  Text('Materias', style: AppTextStyles.heading3),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: tutor.materias
                        .map((m) => Chip(
                              label: Text(m),
                              backgroundColor:
                                  AppColors.primaryLight.withValues(alpha: 0.3),
                              side: BorderSide.none,
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 20),

                  // Certificados
                  Text('Estudios y Certificados',
                      style: AppTextStyles.heading3),
                  const SizedBox(height: 8),
                  ...tutor.certificados.map(
                    (c) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.workspace_premium,
                              color: AppColors.primary, size: 20),
                          const SizedBox(width: 8),
                          Flexible(
                              child: Text(c, style: AppTextStyles.body1)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Reseñas (RF-15)
                  SectionHeader(
                    title: 'Reseñas (${resenas.length})',
                    actionText: 'Ver todas',
                    onActionTap: () {},
                  ),
                  if (resenas.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text('Aún no hay reseñas',
                          style: AppTextStyles.body2),
                    )
                  else
                    ...resenas.map(
                      (r) => Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CustomAvatar(
                                    imageUrl: r.estudianteFotoUrl,
                                    size: 32,
                                    initials: r.estudianteNombre
                                        .substring(0, 2),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(r.estudianteNombre,
                                            style: AppTextStyles.subtitle2),
                                        Text(
                                          '${r.fecha.day}/${r.fecha.month}/${r.fecha.year}',
                                          style: AppTextStyles.caption,
                                        ),
                                      ],
                                    ),
                                  ),
                                  StarRating(
                                      rating: r.calificacion, size: 14),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(r.comentario, style: AppTextStyles.body2),
                            ],
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      // Botones flotantes
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Chat
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: () {
                  // TODO: Abrir chat
                },
                icon: const Icon(Icons.chat_bubble_outline,
                    color: AppColors.primary),
              ),
            ),
            const SizedBox(width: 12),
            // Agendar
            Expanded(
              child: PrimaryButton(
                text: 'Agendar Clase',
                icon: Icons.calendar_today,
                onPressed: () {
                  // TODO: Ir a agendar
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _InfoTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(value,
                style: AppTextStyles.subtitle1.copyWith(color: color)),
            Text(label, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}
