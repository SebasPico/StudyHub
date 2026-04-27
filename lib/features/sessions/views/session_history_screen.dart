import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_avatar.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/providers/session_provider.dart';
import '../../../data/models/session_model.dart';

/// Pantalla de historial de clases (RF-16).
class SessionHistoryScreen extends StatefulWidget {
  const SessionHistoryScreen({super.key});

  @override
  State<SessionHistoryScreen> createState() => _SessionHistoryScreenState();
}

class _SessionHistoryScreenState extends State<SessionHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<SessionModel> _filterByStatus(
      SessionStatus? status, List<SessionModel> all) {
    if (status == null) return all;
    return all.where((s) => s.estado == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    final all = context.watch<SessionProvider>().sessions.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Clases'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textHint,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Todas'),
            Tab(text: 'Pendientes'),
            Tab(text: 'Confirmadas'),
            Tab(text: 'Completadas'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _SessionList(sessions: _filterByStatus(null, all)),
          _SessionList(
              sessions: _filterByStatus(SessionStatus.pendiente, all)),
          _SessionList(
              sessions: _filterByStatus(SessionStatus.confirmada, all)),
          _SessionList(
              sessions: _filterByStatus(SessionStatus.completada, all)),
        ],
      ),
    );
  }
}

class _SessionList extends StatelessWidget {
  final List<SessionModel> sessions;

  const _SessionList({required this.sessions});

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calendar_today_outlined,
                size: 64, color: AppColors.textHint),
            const SizedBox(height: 16),
            Text('No hay clases', style: AppTextStyles.heading3),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () {
                context.go('/student', extra: {'tab': 1});
              },
              icon: const Icon(Icons.search),
              label: const Text('Buscar un tutor'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final sesion = sessions[index];
        return _SessionCard(session: sesion);
      },
    );
  }
}

class _SessionCard extends StatelessWidget {
  final SessionModel session;

  const _SessionCard({required this.session});

  void _confirmCancel(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancelar clase'),
        content:
            const Text('¿Estás seguro de que quieres cancelar esta clase?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('No, mantener'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<SessionProvider>().cancelSession(session.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Clase cancelada'),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Sí, cancelar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          context.push('/session-detail/${session.id}');
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: tutor + estado
              Row(
                children: [
                  CustomAvatar(
                    imageUrl: session.tutorFotoUrl,
                    size: 44,
                    initials: session.tutorNombre.substring(0, 2),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(session.materia,
                            style: AppTextStyles.subtitle1),
                        Text(session.tutorNombre,
                            style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                  StatusBadge(status: session.estadoTexto),
                ],
              ),
              const Divider(height: 20),

              // Detalles
              Row(
                children: [
                  _DetailItem(
                    icon: Icons.calendar_today,
                    text:
                        '${session.fechaHora.day}/${session.fechaHora.month}/${session.fechaHora.year}',
                  ),
                  const SizedBox(width: 16),
                  _DetailItem(
                    icon: Icons.access_time,
                    text:
                        '${session.fechaHora.hour}:${session.fechaHora.minute.toString().padLeft(2, '0')} - ${session.duracionMinutos} min',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ModalityBadge(modality: session.modalidadTexto),
                  const Spacer(),
                  Text(
                    '\$${session.precio.toStringAsFixed(0)}',
                    style: AppTextStyles.price.copyWith(fontSize: 16),
                  ),
                ],
              ),

              // Botón de calificar si completada (RF-15)
              if (session.estado == SessionStatus.completada &&
                  !context
                      .read<SessionProvider>()
                      .hasReview(session.id)) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      context.push('/review', extra: session);
                    },
                    icon: const Icon(Icons.star_outline, size: 18),
                    label: const Text('Calificar clase'),
                  ),
                ),
              ],

              // Botón de cancelar si pendiente o confirmada (RF-12)
              if (session.estado == SessionStatus.pendiente ||
                  session.estado == SessionStatus.confirmada) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      _confirmCancel(context);
                    },
                    style: TextButton.styleFrom(
                        foregroundColor: AppColors.error),
                    child: const Text('Cancelar clase'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DetailItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textHint),
        const SizedBox(width: 4),
        Text(text, style: AppTextStyles.caption),
      ],
    );
  }
}
