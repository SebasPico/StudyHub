import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_avatar.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/providers/session_provider.dart';
import '../../../data/mock/mock_data.dart';
import '../../../data/models/session_model.dart';

/// Pantalla principal del tutor — Dashboard.
class TutorHomeScreen extends StatelessWidget {
  const TutorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tutor = MockData.tutores.first;
    final sessionProv = context.watch<SessionProvider>();
    final pendientes = sessionProv.byStatus(SessionStatus.pendiente);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    CustomAvatar(
                      imageUrl: tutor.fotoUrl,
                      size: 48,
                      initials: tutor.nombre.substring(0, 2),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Panel del Tutor', style: AppTextStyles.body2),
                          Text(tutor.nombre, style: AppTextStyles.heading3),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Badge(
                        label: Text('${pendientes.length}'),
                        child: const Icon(Icons.notifications_outlined),
                      ),
                    ),
                  ],
                ),
              ),

              // Estadísticas rápidas
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    _DashboardStat(
                      icon: Icons.school,
                      value: '${tutor.clasesImpartidas}',
                      label: 'Clases',
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 12),
                    _DashboardStat(
                      icon: Icons.star_rounded,
                      value: '${tutor.calificacionPromedio}',
                      label: 'Calificación',
                      color: AppColors.starFilled,
                    ),
                    const SizedBox(width: 12),
                    _DashboardStat(
                      icon: Icons.reviews,
                      value: '${tutor.totalResenas}',
                      label: 'Reseñas',
                      color: AppColors.secondary,
                    ),
                  ],
                ),
              ),

              // Ganancias del mes (RF-11)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ganancias este mes',
                            style: AppTextStyles.body2
                                .copyWith(color: Colors.white70),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$540.000',
                            style: AppTextStyles.heading1
                                .copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '12 clases completadas',
                            style: AppTextStyles.caption
                                .copyWith(color: Colors.white60),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:
                          const Icon(Icons.trending_up, color: Colors.white, size: 28),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Solicitudes pendientes (RF-10)
              if (pendientes.isNotEmpty) ...[
                SectionHeader(
                  title: 'Solicitudes Pendientes',
                  actionText: 'Ver todas',
                  onActionTap: () {},
                ),
                ...pendientes.map(
                  (sesion) => Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomAvatar(
                                size: 40,
                                initials: sesion.estudianteNombre
                                    .substring(0, 2),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(sesion.estudianteNombre,
                                        style: AppTextStyles.subtitle1),
                                    Text(
                                      '${sesion.materia} • ${sesion.modalidadTexto}',
                                      style: AppTextStyles.caption,
                                    ),
                                  ],
                                ),
                              ),
                              StatusBadge(status: sesion.estadoTexto),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  size: 14, color: AppColors.textHint),
                              const SizedBox(width: 4),
                              Text(
                                '${sesion.fechaHora.day}/${sesion.fechaHora.month}/${sesion.fechaHora.year} - ${sesion.fechaHora.hour}:${sesion.fechaHora.minute.toString().padLeft(2, '0')}',
                                style: AppTextStyles.caption,
                              ),
                              const Spacer(),
                              Text(
                                '\$${sesion.precio.toStringAsFixed(0)}',
                                style: AppTextStyles.price.copyWith(fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    context
                                        .read<SessionProvider>()
                                        .rejectSession(sesion.id);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.error,
                                    side: const BorderSide(
                                        color: AppColors.error),
                                  ),
                                  child: const Text('Rechazar'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    context
                                        .read<SessionProvider>()
                                        .confirmSession(sesion.id);
                                  },
                                  child: const Text('Aceptar'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _DashboardStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(value,
                style: AppTextStyles.heading3.copyWith(color: color)),
            Text(label, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}
