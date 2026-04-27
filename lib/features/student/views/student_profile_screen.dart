import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_avatar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../data/mock/mock_data.dart';

/// Pantalla de edición de perfil del estudiante (RF-02).
class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  final _nombreController = TextEditingController();
  final _ubicacionController = TextEditingController();
  final _telefonoController = TextEditingController();
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final auth = context.read<AuthProvider>();
      // Pre-fill from AuthProvider if logged in, otherwise use mock data
      final estudiante = MockData.estudianteActual;
      _nombreController.text =
          auth.userName.isNotEmpty ? auth.userName : estudiante.nombre;
      _ubicacionController.text =
          auth.userLocation.isNotEmpty
              ? auth.userLocation
              : estudiante.ubicacion ?? '';
      _telefonoController.text =
          auth.userPhone.isNotEmpty
              ? auth.userPhone
              : estudiante.telefono ?? '';
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _ubicacionController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final estudiante = MockData.estudianteActual;
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Avatar
            CustomAvatar(
              imageUrl: auth.userPhoto ?? estudiante.fotoUrl,
              size: 100,
              initials: (auth.userName.isNotEmpty
                      ? auth.userName
                      : estudiante.nombre)
                  .substring(0, 2)
                  .toUpperCase(),
              showEditIcon: true,
              onTap: () {},
            ),
            const SizedBox(height: 8),
            Text(
              auth.userName.isNotEmpty ? auth.userName : estudiante.nombre,
              style: AppTextStyles.heading3,
            ),
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
            CustomTextField(
              label: 'Nombre completo',
              hint: 'Juan Pérez',
              controller: _nombreController,
              prefixIcon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Ubicación',
              hint: 'Bogotá, Colombia',
              controller: _ubicacionController,
              prefixIcon: Icons.location_on_outlined,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Teléfono',
              hint: '+57 300 1234567',
              controller: _telefonoController,
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
                context.read<AuthProvider>().updateProfile(
                      nombre: _nombreController.text.trim(),
                      ubicacion: _ubicacionController.text.trim(),
                      telefono: _telefonoController.text.trim(),
                    );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Perfil actualizado'),
                    backgroundColor: AppColors.secondary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            SecondaryButton(
              text: 'Cerrar Sesión',
              icon: Icons.logout,
              onPressed: () {
                context.read<AuthProvider>().logout();
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
