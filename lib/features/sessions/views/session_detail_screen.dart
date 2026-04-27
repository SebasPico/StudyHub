import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/session_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_avatar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/models/session_model.dart';

/// Pantalla de detalle de sesión con acciones contextuales.
class SessionDetailScreen extends StatelessWidget {
  final String sessionId;

  const SessionDetailScreen({super.key, required this.sessionId});

  String _formatDateTime(DateTime date) {
    final hh = date.hour.toString().padLeft(2, '0');
    final mm = date.minute.toString().padLeft(2, '0');
    return '${date.day}/${date.month}/${date.year} · $hh:$mm';
  }

  Future<void> _confirmCancel(BuildContext context, SessionModel session) async {
    final reasonCtrl = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancelar clase'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Puedes indicar un motivo (opcional).'),
            const SizedBox(height: 12),
            TextField(
              controller: reasonCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'Motivo de cancelacion',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Volver'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Cancelar clase'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final reason = reasonCtrl.text.trim();
      context.read<SessionProvider>().cancelSession(
            session.id,
            reason: reason.isNotEmpty ? reason : 'Cancelada por estudiante',
          );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Clase cancelada correctamente'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }

    reasonCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SessionProvider>();
    final session = provider.byId(sessionId);

    if (session == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detalle de Clase')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.event_busy, size: 64, color: AppColors.textHint),
              const SizedBox(height: 12),
              Text('Clase no encontrada', style: AppTextStyles.heading3),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => context.go('/student', extra: {'tab': 2}),
                child: const Text('Volver a mis clases'),
              ),
            ],
          ),
        ),
      );
    }

    final canCancel = session.estado == SessionStatus.pendiente ||
        session.estado == SessionStatus.confirmada;
    final canReview = session.estado == SessionStatus.completada &&
        !provider.hasReview(session.id);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de Clase')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CustomAvatar(
                      imageUrl: session.tutorFotoUrl,
                      size: 52,
                      initials: session.tutorNombre.substring(0, 2).toUpperCase(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(session.materia, style: AppTextStyles.subtitle1),
                          const SizedBox(height: 2),
                          Text(session.tutorNombre, style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                    StatusBadge(status: session.estadoTexto),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DetailRow(
                      icon: Icons.calendar_today_outlined,
                      label: 'Fecha y hora',
                      value: _formatDateTime(session.fechaHora),
                    ),
                    const SizedBox(height: 12),
                    _DetailRow(
                      icon: Icons.timelapse,
                      label: 'Duracion',
                      value: '${session.duracionMinutos} minutos',
                    ),
                    const SizedBox(height: 12),
                    _DetailRow(
                      icon: session.modalidad == SessionModality.online
                          ? Icons.videocam_outlined
                          : Icons.location_on_outlined,
                      label: 'Modalidad',
                      value: session.modalidadTexto,
                    ),
                    const SizedBox(height: 12),
                    _DetailRow(
                      icon: Icons.payments_outlined,
                      label: 'Valor',
                      value: '\$${session.precio.toStringAsFixed(0)}',
                    ),
                  ],
                ),
              ),
            ),
            if (session.estado == SessionStatus.cancelada) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Motivo de cancelacion', style: AppTextStyles.subtitle1),
                    const SizedBox(height: 4),
                    Text(
                      session.motivoCancelacion ?? 'No especificado',
                      style: AppTextStyles.body2,
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
            if (canCancel)
              PrimaryButton(
                text: 'Cancelar clase',
                icon: Icons.cancel_outlined,
                onPressed: () => _confirmCancel(context, session),
              ),
            if (canReview) ...[
              PrimaryButton(
                text: 'Calificar clase',
                icon: Icons.star_outline,
                onPressed: () => context.push('/review', extra: session),
              ),
              const SizedBox(height: 10),
            ],
            SecondaryButton(
              text: 'Abrir chat con tutor',
              icon: Icons.chat_bubble_outline,
              onPressed: () {
                context.push(
                  '/chat/${session.tutorId}',
                  extra: {
                    'name': session.tutorNombre,
                    'photo': session.tutorFotoUrl,
                    'userId': session.tutorId,
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textHint),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption),
              Text(value, style: AppTextStyles.body1),
            ],
          ),
        ),
      ],
    );
  }
}
