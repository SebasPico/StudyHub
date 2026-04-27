import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/mock/mock_data.dart';
import '../../../data/models/time_slot_model.dart';

/// Pantalla de gestión de calendario/disponibilidad del tutor (RF-08).
class TutorScheduleScreen extends StatefulWidget {
  const TutorScheduleScreen({super.key});

  @override
  State<TutorScheduleScreen> createState() => _TutorScheduleScreenState();
}

class _TutorScheduleScreenState extends State<TutorScheduleScreen> {
  late List<TimeSlotModel> _slots;

  static const _diasSemana = [
    'Lunes', 'Martes', 'Miércoles', 'Jueves',
    'Viernes', 'Sábado', 'Domingo',
  ];

  @override
  void initState() {
    super.initState();
    _slots = List<TimeSlotModel>.from(MockData.horariosDisponibles);
  }

  void _toggleDay(int dia) {
    final slotsDelDia = _slots.where((s) => s.diaSemana == dia).toList();
    final allAvailable = slotsDelDia.every((s) => s.disponible);
    setState(() {
      _slots = _slots.map((s) {
        if (s.diaSemana != dia) return s;
        return TimeSlotModel(
          id: s.id,
          tutorId: s.tutorId,
          diaSemana: s.diaSemana,
          horaInicio: s.horaInicio,
          horaFin: s.horaFin,
          disponible: !allAvailable,
        );
      }).toList();
    });
  }

  void _removeSlot(String id) {
    setState(() => _slots.removeWhere((s) => s.id == id));
  }

  Future<void> _showAddDialog() async {
    int selectedDia = 1;
    final inicioCtrl = TextEditingController(text: '08:00');
    final finCtrl = TextEditingController(text: '09:00');

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Agregar bloque horario'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                initialValue: selectedDia,
                decoration: const InputDecoration(labelText: 'Día'),
                items: List.generate(
                  7,
                  (i) => DropdownMenuItem(
                    value: i + 1,
                    child: Text(_diasSemana[i]),
                  ),
                ),
                onChanged: (v) =>
                    setDialogState(() => selectedDia = v ?? 1),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: inicioCtrl,
                decoration: const InputDecoration(
                  labelText: 'Hora inicio (HH:mm)',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: finCtrl,
                decoration: const InputDecoration(
                  labelText: 'Hora fin (HH:mm)',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () {
                final inicio = inicioCtrl.text.trim();
                final fin = finCtrl.text.trim();
                if (inicio.isNotEmpty && fin.isNotEmpty) {
                  setState(() {
                    _slots.add(TimeSlotModel(
                      id: 'slot_${DateTime.now().millisecondsSinceEpoch}',
                      tutorId: 't1',
                      diaSemana: selectedDia,
                      horaInicio: inicio,
                      horaFin: fin,
                    ));
                  });
                }
                Navigator.pop(ctx);
              },
              child: const Text('Agregar'),
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Disponibilidad guardada'),
        backgroundColor: AppColors.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Disponibilidad'),
        actions: [
          TextButton.icon(
            onPressed: _save,
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
              _slots.where((h) => h.diaSemana == dia).toList();

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
                        value: slotsDelDia.any((s) => s.disponible),
                        onChanged: (_) => _toggleDay(dia),
                        activeThumbColor: AppColors.primary,
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
                            icon: const Icon(Icons.delete_outline, size: 18),
                            onPressed: () => _removeSlot(slot.id),
                            color: AppColors.error,
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
        onPressed: _showAddDialog,
        icon: const Icon(Icons.add),
        label: const Text('Agregar horario'),
      ),
    );
  }
}
