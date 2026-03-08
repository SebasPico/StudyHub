import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/constants/app_constants.dart';

/// Pantalla de registro de usuario (RF-01).
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String _selectedRole = AppConstants.rolEstudiante;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Cuenta'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('¡Bienvenido!', style: AppTextStyles.heading2),
                const SizedBox(height: 4),
                Text(
                  'Crea tu cuenta para comenzar',
                  style: AppTextStyles.body2,
                ),
                const SizedBox(height: 32),

                // Selector de rol
                Text('¿Cómo deseas registrarte?', style: AppTextStyles.subtitle1),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _RoleCard(
                        icon: Icons.person_outline,
                        label: AppConstants.rolEstudiante,
                        description: 'Busca tutores y agenda clases',
                        isSelected: _selectedRole == AppConstants.rolEstudiante,
                        onTap: () => setState(
                          () => _selectedRole = AppConstants.rolEstudiante,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _RoleCard(
                        icon: Icons.school_outlined,
                        label: AppConstants.rolTutor,
                        description: 'Ofrece tus clases y gana dinero',
                        isSelected: _selectedRole == AppConstants.rolTutor,
                        onTap: () => setState(
                          () => _selectedRole = AppConstants.rolTutor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Nombre
                CustomTextField(
                  label: 'Nombre completo',
                  hint: 'Juan Pérez',
                  prefixIcon: Icons.person_outline,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Ingresa tu nombre' : null,
                ),
                const SizedBox(height: 16),

                // Correo
                CustomTextField(
                  label: 'Correo electrónico',
                  hint: 'tucorreo@email.com',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Ingresa tu correo' : null,
                ),
                const SizedBox(height: 16),

                // Contraseña
                CustomTextField(
                  label: 'Contraseña',
                  hint: '••••••••',
                  obscureText: _obscurePassword,
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textHint,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (v) =>
                      v == null || v.length < 6 ? 'Mínimo 6 caracteres' : null,
                ),
                const SizedBox(height: 16),

                // Confirmar contraseña
                CustomTextField(
                  label: 'Confirmar contraseña',
                  hint: '••••••••',
                  obscureText: _obscureConfirm,
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textHint,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Confirma tu contraseña' : null,
                ),
                const SizedBox(height: 32),

                // Botón de registro
                PrimaryButton(
                  text: 'Crear Cuenta',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Registro mock: navegar según rol seleccionado
                      if (_selectedRole == AppConstants.rolTutor) {
                        context.go('/tutor');
                      } else {
                        context.go('/student');
                      }
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Ya tengo cuenta
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('¿Ya tienes cuenta? ', style: AppTextStyles.body2),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Inicia Sesión',
                        style: AppTextStyles.subtitle1.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Card para seleccionar rol de usuario.
class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.label,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.08)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? AppColors.primary : AppColors.textHint,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.subtitle1.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
