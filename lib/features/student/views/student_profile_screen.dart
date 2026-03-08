import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_avatar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../data/mock/mock_data.dart';

/// Pantalla de edición de perfil del estudiante (RF-02).
class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final estudiante = MockData.estudianteActual;

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Avatar con edición
            CustomAvatar(
              imageUrl: estudiante.fotoUrl,
              size: 100,
              initials: estudiante.nombre.substring(0, 2).toUpperCase(),
              showEditIcon: true,
              onTap: () {
                // TODO: Cambiar foto
              },
            ),
            const SizedBox(height: 8),
            Text(estudiante.nombre, style: AppTextStyles.heading3),
            Text(estudiante.correo, style: AppTextStyles.body2),
            const SizedBox(height: 24),

            // Estadísticas
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatItem(
                    value: '${estudiante.clasesTomadas}',
                    label: 'Clases',
                  ),
                  Container(width: 1, height: 40, color: AppColors.border),
                  _StatItem(
                    value: '${estudiante.materiasInteres.length}',
                    label: 'Materias',
                  ),
                  Container(width: 1, height: 40, color: AppColors.border),
                  const _StatItem(value: '4.8', label: 'Promedio'),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Formulario de edición
            const CustomTextField(
              label: 'Nombre completo',
              hint: 'Juan Pérez',
              prefixIcon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            const CustomTextField(
              label: 'Ubicación',
              hint: 'Bogotá, Colombia',
              prefixIcon: Icons.location_on_outlined,
            ),
            const SizedBox(height: 16),
            const CustomTextField(
              label: 'Teléfono',
              hint: '+57 300 1234567',
              keyboardType: TextInputType.phone,
              prefixIcon: Icons.phone_outlined,
            ),
            const SizedBox(height: 16),

            // Materias de interés
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Materias de interés',
                  style: AppTextStyles.subtitle2),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...estudiante.materiasInteres.map(
                  (m) => Chip(
                    label: Text(m),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () {},
                  ),
                ),
                ActionChip(
                  avatar: const Icon(Icons.add, size: 18),
                  label: const Text('Agregar'),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 32),

            PrimaryButton(
              text: 'Guardar Cambios',
              onPressed: () {
                // TODO: Guardar perfil
              },
            ),
            const SizedBox(height: 12),
            SecondaryButton(
              text: 'Cerrar Sesión',
              icon: Icons.logout,
              onPressed: () {
                context.go('/login');
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.heading3.copyWith(color: AppColors.primary)),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}
