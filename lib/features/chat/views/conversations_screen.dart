import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_avatar.dart';
import '../../../data/mock/mock_data.dart';

/// Pantalla de lista de conversaciones (RF-14).
class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final conversaciones = MockData.conversaciones;

    return Scaffold(
      appBar: AppBar(title: const Text('Mensajes')),
      body: conversaciones.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.chat_bubble_outline,
                      size: 64, color: AppColors.textHint),
                  const SizedBox(height: 16),
                  Text('Sin conversaciones', style: AppTextStyles.heading3),
                  const SizedBox(height: 4),
                  Text(
                    'Inicia una conversación con un tutor',
                    style: AppTextStyles.body2,
                  ),
                ],
              ),
            )
          : ListView.separated(
              itemCount: conversaciones.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                indent: 76,
              ),
              itemBuilder: (context, index) {
                final conv = conversaciones[index];
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CustomAvatar(
                    imageUrl: conv.otroUsuarioFotoUrl,
                    size: 50,
                    initials: conv.otroUsuarioNombre.substring(0, 2),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          conv.otroUsuarioNombre,
                          style: AppTextStyles.subtitle1.copyWith(
                            fontWeight: conv.mensajesNoLeidos > 0
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _formatTime(conv.fechaUltimoMensaje),
                        style: AppTextStyles.caption.copyWith(
                          color: conv.mensajesNoLeidos > 0
                              ? AppColors.primary
                              : null,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      Expanded(
                        child: Text(
                          conv.ultimoMensaje,
                          style: AppTextStyles.body2.copyWith(
                            fontWeight: conv.mensajesNoLeidos > 0
                                ? FontWeight.w500
                                : FontWeight.w400,
                            color: conv.mensajesNoLeidos > 0
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (conv.mensajesNoLeidos > 0)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${conv.mensajesNoLeidos}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  onTap: () {
                    context.push(
                      '/chat/${conv.id}',
                      extra: {
                        'name': conv.otroUsuarioNombre,
                        'photo': conv.otroUsuarioFotoUrl,
                      },
                    );
                  },
                );
              },
            ),
    );
  }

  String _formatTime(DateTime date) {
    final now = DateTime(2026, 3, 6);
    final diff = now.difference(DateTime(date.year, date.month, date.day));
    if (diff.inDays == 0) {
      return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays == 1) {
      return 'Ayer';
    } else if (diff.inDays < 7) {
      const dias = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
      return dias[date.weekday - 1];
    } else {
      return '${date.day}/${date.month}';
    }
  }
}
