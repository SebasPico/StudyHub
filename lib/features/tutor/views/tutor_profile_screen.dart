import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_avatar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/tutor_provider.dart';
import '../../../data/models/tutor_model.dart';

/// Pantalla de edición del perfil del tutor (RF-03, RF-04).
class TutorProfileScreen extends StatefulWidget {
  const TutorProfileScreen({super.key});

  @override
  State<TutorProfileScreen> createState() => _TutorProfileScreenState();
}

class _TutorProfileScreenState extends State<TutorProfileScreen> {
  final _nombreController = TextEditingController();
  final _ubicacionController = TextEditingController();
  final _biografiaController = TextEditingController();
  final _tarifaController = TextEditingController();
  Modalidad _modalidad = Modalidad.online;
  List<String> _materias = [];
  List<String> _certificados = [];
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final userId = context.read<AuthProvider>().userId;
      final tutor = context.read<TutorProvider>().byId(userId) ??
          context.read<TutorProvider>().all.firstOrNull;
      if (tutor != null) {
        _nombreController.text = tutor.nombre;
        _ubicacionController.text = tutor.ubicacion ?? '';
        _biografiaController.text = tutor.biografia;
        _tarifaController.text = tutor.tarifaPorHora.toStringAsFixed(0);
        _modalidad = tutor.modalidad;
        _materias = List.from(tutor.materias);
        _certificados = List.from(tutor.certificados);
      }
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _ubicacionController.dispose();
    _biografiaController.dispose();
    _tarifaController.dispose();
    super.dispose();
  }

  void _save(TutorModel tutor) {
    final tarifa =
        double.tryParse(_tarifaController.text) ?? tutor.tarifaPorHora;
    context.read<TutorProvider>().updateTutor(
          tutor.id,
          nombre: _nombreController.text.trim(),
          ubicacion: _ubicacionController.text.trim(),
          biografia: _biografiaController.text.trim(),
          tarifaPorHora: tarifa,
          modalidad: _modalidad,
          materias: List.from(_materias),
          certificados: List.from(_certificados),
        );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Perfil guardado'),
        backgroundColor: AppColors.secondary,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _addText(
      String titulo, void Function(String) onAdd) async {
    final ctrl = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Agregar $titulo'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: InputDecoration(hintText: 'Escribe aquí...'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
          ElevatedButton(
              onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
              child: const Text('Agregar')),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) onAdd(result);
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.watch<AuthProvider>().userId;
    final tutor = context.watch<TutorProvider>().byId(userId) ??
        context.watch<TutorProvider>().all.firstOrNull;

    if (tutor == null) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }

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

            CustomTextField(
              label: 'Nombre completo',
              hint: 'María García López',
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

            // Biografía (RF-03)
            CustomTextField(
              label: 'Biografía',
              hint: 'Cuéntale a tus estudiantes sobre ti...',
              controller: _biografiaController,
              maxLines: 4,
              prefixIcon: Icons.description_outlined,
            ),
            const SizedBox(height: 16),

            // Tarifa por hora
            CustomTextField(
              label: 'Tarifa por hora (\$)',
              hint: '45000',
              controller: _tarifaController,
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
                  isSelected: _modalidad == Modalidad.online ||
                      _modalidad == Modalidad.ambas,
                  color: AppColors.online,
                  onTap: () => setState(() => _modalidad = Modalidad.online),
                ),
                const SizedBox(width: 12),
                _ModalityOption(
                  icon: Icons.location_on,
                  label: 'Presencial',
                  isSelected: _modalidad == Modalidad.presencial ||
                      _modalidad == Modalidad.ambas,
                  color: AppColors.presencial,
                  onTap: () =>
                      setState(() => _modalidad = Modalidad.presencial),
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
                ..._materias.map(
                  (m) => Chip(
                    label: Text(m),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () => setState(() => _materias.remove(m)),
                  ),
                ),
                ActionChip(
                  avatar: const Icon(Icons.add, size: 18),
                  label: const Text('Agregar materia'),
                  onPressed: () => _addText(
                      'materia', (v) => setState(() => _materias.add(v))),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Certificados / Estudios
            Text('Certificados y Estudios', style: AppTextStyles.heading3),
            const SizedBox(height: 12),
            ..._certificados.map(
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
                  onPressed: () => setState(() => _certificados.remove(c)),
                ),
              ),
            ),
            OutlinedButton.icon(
              onPressed: () => _addText('certificado',
                  (v) => setState(() => _certificados.add(v))),
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
              onPressed: () => _save(tutor),
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

class _ModalityOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _ModalityOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
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
