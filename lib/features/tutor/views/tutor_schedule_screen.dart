import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/mock/mock_data.dart';

/// Pantalla de gestión de calendario/disponibilidad del tutor (RF-08).
class TutorScheduleScreen extends StatelessWidget {
  const TutorScheduleScreen({super.key});

  static const _diasSemana = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];

  @override
  Widget build(BuildContext context) {
    final horarios = MockData.horariosDisponibles;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Disponibilidad'),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.save_outlined, size: 20),
            label: const Text('Guardar'),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 7,
        itemBuilder: (context, index) {
          final dia = index + 1;
          final slotsDelDia =
              horarios.where((h) => h.diaSemana == dia).toList();

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Encabezado del día
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12)),
                  ),
                  child: Row(
                    children: [
                      Text(_diasSemana[index],
                          style: AppTextStyles.subtitle1),
                      const Spacer(),
                      Text(
                        '${slotsDelDia.length} bloques',
                        style: AppTextStyles.caption,
                      ),
                      const SizedBox(width: 8),
                      Switch(
                        value: slotsDelDia.isNotEmpty,
                        onChanged: (_) {},
                        activeColor: AppColors.primary,
                      ),
                    ],
                  ),
                ),

                // Slots
                if (slotsDelDia.isNotEmpty)
                  ...slotsDelDia.map(
                    (slot) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 4,
                            height: 36,
                            decoration: BoxDecoration(
                              color: slot.disponible
                                  ? AppColors.secondary
                                  : AppColors.error,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: AppColors.textHint,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${slot.horaInicio} - ${slot.horaFin}',
                            style: AppTextStyles.body1,
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: (slot.disponible
                                      ? AppColors.secondary
                                      : AppColors.error)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              slot.disponible ? 'Disponible' : 'Bloqueado',
                              style: AppTextStyles.caption.copyWith(
                                color: slot.disponible
                                    ? AppColors.secondary
                                    : AppColors.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            onPressed: () {},
                            color: AppColors.textHint,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Sin horarios configurados',
                      style: TextStyle(color: AppColors.textHint),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Agregar bloque horario
        },
        icon: const Icon(Icons.add),
        label: const Text('Agregar horario'),
      ),
    );
  }
}
