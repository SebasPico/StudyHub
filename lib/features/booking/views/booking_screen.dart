import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_avatar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/mock/mock_data.dart';

/// Pantalla para agendar una sesión con un tutor (RF-09).
class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _selectedDayIndex = 0;
  int _selectedSlotIndex = -1;
  String _selectedModality = 'Online';
  int _duracion = 60;

  final _dias = [
    {'nombre': 'Lun', 'fecha': '10', 'slots': 3},
    {'nombre': 'Mar', 'fecha': '11', 'slots': 2},
    {'nombre': 'Mié', 'fecha': '12', 'slots': 4},
    {'nombre': 'Jue', 'fecha': '13', 'slots': 1},
    {'nombre': 'Vie', 'fecha': '14', 'slots': 3},
    {'nombre': 'Sáb', 'fecha': '15', 'slots': 2},
  ];

  final _horarios = [
    '08:00 - 09:00',
    '09:00 - 10:00',
    '14:00 - 15:00',
    '15:00 - 16:00',
    '16:00 - 17:00',
  ];

  @override
  Widget build(BuildContext context) {
    final tutor = MockData.tutores.first;

    return Scaffold(
      appBar: AppBar(title: const Text('Agendar Clase')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info del tutor
            Card(
              child: ListTile(
                leading: CustomAvatar(
                  size: 40,
                  initials: tutor.nombre.substring(0, 2).toUpperCase(),
                ),
                title: Text(tutor.nombre, style: AppTextStyles.subtitle1),
                subtitle: Text(tutor.materias.join(', '),
                    style: AppTextStyles.caption),
                trailing: Text(
                  '\$${tutor.tarifaPorHora.toStringAsFixed(0)}/hr',
                  style: AppTextStyles.price.copyWith(fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Selección de fecha
            Text('Selecciona un día', style: AppTextStyles.heading3),
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _dias.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final dia = _dias[index];
                  final isSelected = _selectedDayIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() {
                      _selectedDayIndex = index;
                      _selectedSlotIndex = -1;
                    }),
                    child: Container(
                      width: 60,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dia['nombre'] as String,
                            style: AppTextStyles.caption.copyWith(
                              color:
                                  isSelected ? Colors.white70 : null,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dia['fecha'] as String,
                            style: AppTextStyles.heading3.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '${dia['slots']} disp.',
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 10,
                              color: isSelected
                                  ? Colors.white60
                                  : AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Selección de horario
            Text('Horarios disponibles', style: AppTextStyles.heading3),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(_horarios.length, (index) {
                final isSelected = _selectedSlotIndex == index;
                return GestureDetector(
                  onTap: () =>
                      setState(() => _selectedSlotIndex = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textHint,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _horarios[index],
                          style: AppTextStyles.body2.copyWith(
                            color: isSelected
                                ? Colors.white
                                : AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),

            // Modalidad
            Text('Modalidad', style: AppTextStyles.heading3),
            const SizedBox(height: 12),
            Row(
              children: [
                _ModalitySelector(
                  icon: Icons.videocam,
                  label: 'Online',
                  isSelected: _selectedModality == 'Online',
                  onTap: () =>
                      setState(() => _selectedModality = 'Online'),
                ),
                const SizedBox(width: 12),
                _ModalitySelector(
                  icon: Icons.location_on,
                  label: 'Presencial',
                  isSelected: _selectedModality == 'Presencial',
                  onTap: () =>
                      setState(() => _selectedModality = 'Presencial'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Duración
            Text('Duración', style: AppTextStyles.heading3),
            const SizedBox(height: 12),
            Row(
              children: [60, 90, 120].map((d) {
                final isSelected = _duracion == d;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _duracion = d),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '$d min',
                          style: AppTextStyles.subtitle1.copyWith(
                            color:
                                isSelected ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Resumen
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  _ResumenRow(
                      label: 'Tutor', value: tutor.nombre),
                  _ResumenRow(
                      label: 'Modalidad', value: _selectedModality),
                  _ResumenRow(
                      label: 'Duración', value: '$_duracion minutos'),
                  _ResumenRow(
                    label: 'Tarifa por hora',
                    value:
                        '\$${tutor.tarifaPorHora.toStringAsFixed(0)}',
                  ),
                  const Divider(),
                  _ResumenRow(
                    label: 'Total',
                    value:
                        '\$${(tutor.tarifaPorHora * _duracion / 60).toStringAsFixed(0)}',
                    isBold: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            PrimaryButton(
              text: 'Confirmar y Pagar',
              icon: Icons.payment,
              onPressed: _selectedSlotIndex >= 0
                  ? () {
                      // TODO: Navegar a pago
                    }
                  : null,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ModalitySelector extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModalitySelector({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 20,
                  color: isSelected ? Colors.white : AppColors.textHint),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTextStyles.subtitle1.copyWith(
                  color:
                      isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResumenRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _ResumenRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isBold ? AppTextStyles.subtitle1 : AppTextStyles.body2,
          ),
          Text(
            value,
            style: isBold
                ? AppTextStyles.price
                : AppTextStyles.subtitle1,
          ),
        ],
      ),
    );
  }
}
