import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/custom_avatar.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/star_rating.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/mock/mock_data.dart';
import '../../../data/models/session_model.dart';
import '../../../data/models/tutor_model.dart';

/// Pantalla principal del estudiante con búsqueda rápida y tutores destacados.
class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final estudiante = MockData.estudianteActual;
    final tutores = MockData.tutores.where((t) => t.aprobadoPorAdmin).toList();
    final proximaSesion = MockData.sesiones
        .where((s) =>
            s.estado == SessionStatus.confirmada ||
            s.estado == SessionStatus.pendiente)
        .toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con saludo
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    CustomAvatar(
                      imageUrl: estudiante.fotoUrl,
                      size: 48,
                      initials: estudiante.nombre.substring(0, 2).toUpperCase(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('¡Hola!', style: AppTextStyles.body2),
                          Text(
                            estudiante.nombre,
                            style: AppTextStyles.heading3,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Badge(
                        smallSize: 8,
                        child: const Icon(Icons.notifications_outlined),
                      ),
                    ),
                  ],
                ),
              ),

              // Barra de búsqueda (RF-05)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: GestureDetector(
                  onTap: () {
                    // TODO: Navegar a pantalla de búsqueda
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search,
                            color: AppColors.textHint, size: 22),
                        const SizedBox(width: 12),
                        Text(
                          'Buscar tutor o materia...',
                          style: AppTextStyles.body2
                              .copyWith(color: AppColors.textHint),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Materias populares
              SectionHeader(
                title: 'Materias Populares',
                actionText: 'Ver todas',
                onActionTap: () {},
              ),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: MockData.materiasPopulares.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    return ActionChip(
                      label: Text(MockData.materiasPopulares[index]),
                      onPressed: () {},
                      backgroundColor:
                          AppColors.primaryLight.withValues(alpha: 0.3),
                      side: BorderSide.none,
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),

              // Próximas sesiones (RF-16)
              if (proximaSesion.isNotEmpty) ...[
                SectionHeader(
                  title: 'Próximas Clases',
                  actionText: 'Ver historial',
                  onActionTap: () {},
                ),
                ...proximaSesion.map(
                  (sesion) => Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: CustomAvatar(
                        imageUrl: sesion.tutorFotoUrl,
                        size: 44,
                        initials: sesion.tutorNombre.substring(0, 2),
                      ),
                      title: Text(sesion.materia,
                          style: AppTextStyles.subtitle1),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            '${sesion.tutorNombre} • ${sesion.fechaHora.day}/${sesion.fechaHora.month} - ${sesion.fechaHora.hour}:${sesion.fechaHora.minute.toString().padLeft(2, '0')}',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                      trailing: StatusBadge(status: sesion.estadoTexto),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 8),

              // Tutores destacados (RF-07)
              SectionHeader(
                title: 'Tutores Destacados',
                actionText: 'Ver todos',
                onActionTap: () {},
              ),
              ...tutores
                  .take(3)
                  .map((tutor) => _TutorHighlightCard(tutor: tutor)),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/// Card destacada de tutor para la pantalla Home.
class _TutorHighlightCard extends StatelessWidget {
  final TutorModel tutor;

  const _TutorHighlightCard({required this.tutor});

  String get _modalidadTexto {
    switch (tutor.modalidad) {
      case Modalidad.online:
        return AppConstants.modalidadOnline;
      case Modalidad.presencial:
        return AppConstants.modalidadPresencial;
      case Modalidad.ambas:
        return 'Online / Presencial';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: () {
          // TODO: Navegar al perfil del tutor
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CustomAvatar(
                imageUrl: tutor.fotoUrl,
                size: 60,
                initials: tutor.nombre.substring(0, 2),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(tutor.nombre,
                              style: AppTextStyles.subtitle1,
                              overflow: TextOverflow.ellipsis),
                        ),
                        if (tutor.verificado) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.verified,
                              color: AppColors.primary, size: 16),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tutor.materias.join(' • '),
                      style: AppTextStyles.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        StarRating(rating: tutor.calificacionPromedio, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '${tutor.calificacionPromedio} (${tutor.totalResenas})',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '\$${tutor.tarifaPorHora.toStringAsFixed(0)}/hr',
                          style: AppTextStyles.price.copyWith(fontSize: 14),
                        ),
                        const Spacer(),
                        Text(
                          _modalidadTexto,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.online,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
