import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_avatar.dart';
import '../../../core/providers/tutor_provider.dart';

/// Panel del administrador para aprobar tutores y gestionar plataforma.
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tp = context.watch<TutorProvider>();
    final tutoresPendientes = tp.pending;
    final tutoresAprobados = tp.approved;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings_outlined)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats generales
            Row(
              children: [
                _AdminStat(
                  icon: Icons.people,
                  value: '${tp.all.length + 1}',
                  label: 'Usuarios',
                  color: AppColors.primary,
                ),
                const SizedBox(width: 10),
                _AdminStat(
                  icon: Icons.school,
                  value: '${tutoresAprobados.length}',
                  label: 'Tutores activos',
                  color: AppColors.secondary,
                ),
                const SizedBox(width: 10),
                _AdminStat(
                  icon: Icons.pending_actions,
                  value: '${tutoresPendientes.length}',
                  label: 'Por aprobar',
                  color: AppColors.warning,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _AdminStat(
                  icon: Icons.calendar_today,
                  value: '4',
                  label: 'Sesiones',
                  color: AppColors.info,
                ),
                const SizedBox(width: 10),
                _AdminStat(
                  icon: Icons.attach_money,
                  value: '\$1.2M',
                  label: 'Ingresos mes',
                  color: AppColors.secondary,
                ),
                const SizedBox(width: 10),
                _AdminStat(
                  icon: Icons.star,
                  value: '4.7',
                  label: 'Rating prom.',
                  color: AppColors.starFilled,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Tutores pendientes de aprobación
            Text('Tutores Pendientes de Aprobación',
                style: AppTextStyles.heading3),
            const SizedBox(height: 12),
            if (tutoresPendientes.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.secondary),
                    const SizedBox(width: 8),
                    Text('Todos los tutores están aprobados',
                        style: AppTextStyles.body2),
                  ],
                ),
              )
            else
              ...tutoresPendientes.map(
                (tutor) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomAvatar(
                              imageUrl: tutor.fotoUrl,
                              size: 50,
                              initials: tutor.nombre.substring(0, 2),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(tutor.nombre,
                                      style: AppTextStyles.subtitle1),
                                  Text(tutor.correo,
                                      style: AppTextStyles.caption),
                                  Text(
                                    tutor.materias.join(', '),
                                    style: AppTextStyles.body2,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Documentos
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.scaffoldBackground,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.description_outlined,
                                  size: 18, color: AppColors.textHint),
                              const SizedBox(width: 8),
                              Text(
                                '${tutor.certificados.length} certificado(s) subido(s)',
                                style: AppTextStyles.caption,
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {},
                                child: const Text('Ver'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  context
                                      .read<TutorProvider>()
                                      .removeTutor(tutor.id);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Tutor rechazado'),
                                    backgroundColor: AppColors.error,
                                  ));
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.error,
                                  side:
                                      const BorderSide(color: AppColors.error),
                                ),
                                child: const Text('Rechazar'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  context
                                      .read<TutorProvider>()
                                      .approveTutor(tutor.id);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Tutor aprobado'),
                                    backgroundColor: AppColors.secondary,
                                  ));
                                },
                                child: const Text('Aprobar'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 24),

            // Tutores aprobados
            Text('Tutores Activos', style: AppTextStyles.heading3),
            const SizedBox(height: 12),
            ...tutoresAprobados.map(
              (tutor) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CustomAvatar(
                    imageUrl: tutor.fotoUrl,
                    size: 44,
                    initials: tutor.nombre.substring(0, 2),
                  ),
                  title: Row(
                    children: [
                      Text(tutor.nombre, style: AppTextStyles.subtitle1),
                      if (tutor.verificado) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.verified,
                            color: AppColors.primary, size: 16),
                      ],
                    ],
                  ),
                  subtitle: Text(
                    '${tutor.clasesImpartidas} clases • ⭐ ${tutor.calificacionPromedio}',
                    style: AppTextStyles.caption,
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'ver',
                        child: Text('Ver perfil'),
                      ),
                      const PopupMenuItem(
                        value: 'suspender',
                        child: Text('Suspender'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _AdminStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _AdminStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
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
            Text(label,
                style: AppTextStyles.caption.copyWith(fontSize: 10),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
