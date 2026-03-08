import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_avatar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../data/mock/mock_data.dart';
import '../../../data/models/tutor_model.dart';

/// Pantalla de edición del perfil del tutor (RF-03, RF-04).
class TutorProfileScreen extends StatelessWidget {
  const TutorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tutor = MockData.tutores.first;

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil de Tutor')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar y nombre
            Center(
              child: Column(
                children: [
                  CustomAvatar(
                    imageUrl: tutor.fotoUrl,
                    size: 100,
                    initials: tutor.nombre.substring(0, 2),
                    showEditIcon: true,
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(tutor.nombre, style: AppTextStyles.heading3),
                      if (tutor.verificado) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.verified,
                            color: AppColors.primary, size: 18),
                      ],
                    ],
                  ),
                  Text(tutor.correo, style: AppTextStyles.body2),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Información básica
            Text('Información Básica', style: AppTextStyles.heading3),
            const SizedBox(height: 16),

            const CustomTextField(
              label: 'Nombre completo',
              hint: 'María García López',
              prefixIcon: Icons.person_outline,
            ),
            const SizedBox(height: 16),

            const CustomTextField(
              label: 'Ubicación',
              hint: 'Bogotá, Colombia',
              prefixIcon: Icons.location_on_outlined,
            ),
            const SizedBox(height: 16),

            // Biografía (RF-03)
            const CustomTextField(
              label: 'Biografía',
              hint: 'Cuéntale a tus estudiantes sobre ti...',
              maxLines: 4,
              prefixIcon: Icons.description_outlined,
            ),
            const SizedBox(height: 16),

            // Tarifa por hora
            const CustomTextField(
              label: 'Tarifa por hora (\$)',
              hint: '45000',
              keyboardType: TextInputType.number,
              prefixIcon: Icons.attach_money,
            ),
            const SizedBox(height: 24),

            // Modalidad de enseñanza
            Text('Modalidad de Enseñanza', style: AppTextStyles.heading3),
            const SizedBox(height: 12),
            Row(
              children: [
                _ModalityOption(
                  icon: Icons.videocam,
                  label: 'Online',
                  isSelected: tutor.modalidad == Modalidad.online ||
                      tutor.modalidad == Modalidad.ambas,
                  color: AppColors.online,
                ),
                const SizedBox(width: 12),
                _ModalityOption(
                  icon: Icons.location_on,
                  label: 'Presencial',
                  isSelected: tutor.modalidad == Modalidad.presencial ||
                      tutor.modalidad == Modalidad.ambas,
                  color: AppColors.presencial,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Materias
            Text('Materias que Imparto', style: AppTextStyles.heading3),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...tutor.materias.map(
                  (m) => Chip(
                    label: Text(m),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () {},
                  ),
                ),
                ActionChip(
                  avatar: const Icon(Icons.add, size: 18),
                  label: const Text('Agregar materia'),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Certificados / Estudios
            Text('Certificados y Estudios', style: AppTextStyles.heading3),
            const SizedBox(height: 12),
            ...tutor.certificados.map(
              (c) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: AppColors.primaryLight,
                  child: Icon(Icons.workspace_premium,
                      color: AppColors.primary, size: 20),
                ),
                title: Text(c, style: AppTextStyles.body1),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: AppColors.error, size: 20),
                  onPressed: () {},
                ),
              ),
            ),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.upload_file),
              label: const Text('Subir certificado'),
            ),
            const SizedBox(height: 24),

            // Verificación de identidad (RF-04)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified_user, color: AppColors.info),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Verificación de Identidad',
                            style: AppTextStyles.subtitle1),
                        const SizedBox(height: 2),
                        Text(
                          'Sube tu documento de identidad para aumentar la confianza de los estudiantes.',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.badge_outlined),
              label: const Text('Subir documento de identidad'),
            ),
            const SizedBox(height: 32),

            PrimaryButton(
              text: 'Guardar Perfil',
              onPressed: () {},
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

class _ModalityOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final Color color;

  const _ModalityOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.1) : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? color : AppColors.textHint, size: 28),
              const SizedBox(height: 6),
              Text(
                label,
                style: AppTextStyles.subtitle1.copyWith(
                  color: isSelected ? color : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
