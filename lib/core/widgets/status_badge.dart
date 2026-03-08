import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../constants/app_constants.dart';

/// Chip/badge que muestra el estado de una sesión con color correspondiente.
class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  Color get _backgroundColor {
    switch (status) {
      case AppConstants.estadoPendiente:
        return AppColors.pendiente.withValues(alpha: 0.15);
      case AppConstants.estadoConfirmada:
        return AppColors.confirmada.withValues(alpha: 0.15);
      case AppConstants.estadoCompletada:
        return AppColors.completada.withValues(alpha: 0.15);
      case AppConstants.estadoCancelada:
        return AppColors.cancelada.withValues(alpha: 0.15);
      default:
        return AppColors.border;
    }
  }

  Color get _textColor {
    switch (status) {
      case AppConstants.estadoPendiente:
        return AppColors.pendiente;
      case AppConstants.estadoConfirmada:
        return AppColors.confirmada;
      case AppConstants.estadoCompletada:
        return AppColors.completada;
      case AppConstants.estadoCancelada:
        return AppColors.cancelada;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
      ),
      child: Text(
        status,
        style: AppTextStyles.caption.copyWith(
          color: _textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Chip de modalidad (Online / Presencial).
class ModalityBadge extends StatelessWidget {
  final String modality;

  const ModalityBadge({super.key, required this.modality});

  @override
  Widget build(BuildContext context) {
    final isOnline = modality == AppConstants.modalidadOnline;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: (isOnline ? AppColors.online : AppColors.presencial)
            .withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOnline ? Icons.videocam : Icons.location_on,
            size: 14,
            color: isOnline ? AppColors.online : AppColors.presencial,
          ),
          const SizedBox(width: 4),
          Text(
            modality,
            style: AppTextStyles.caption.copyWith(
              color: isOnline ? AppColors.online : AppColors.presencial,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
