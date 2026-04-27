import 'package:flutter/foundation.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/session_model.dart';
import '../../data/models/review_model.dart';

/// Gestión reactiva de sesiones y reseñas.
class SessionProvider extends ChangeNotifier {
  final List<SessionModel> _sessions;
  final List<ReviewModel> _reviews;

  SessionProvider()
      : _sessions = List<SessionModel>.from(MockData.sesiones),
        _reviews = List<ReviewModel>.from(MockData.resenas);

  List<SessionModel> get sessions => List.unmodifiable(_sessions);
  List<ReviewModel> get reviews => List.unmodifiable(_reviews);

  SessionModel? byId(String id) {
    return _sessions
        .cast<SessionModel?>()
        .firstWhere((s) => s!.id == id, orElse: () => null);
  }

  List<SessionModel> byStatus(SessionStatus? status) {
    if (status == null) return List.unmodifiable(_sessions);
    return _sessions.where((s) => s.estado == status).toList();
  }

  List<SessionModel> get upcoming => _sessions
      .where((s) =>
          s.estado == SessionStatus.confirmada ||
          s.estado == SessionStatus.pendiente)
      .toList();

  List<ReviewModel> reviewsForTutor(String tutorId) =>
      _reviews.where((r) => r.tutorId == tutorId).toList();

  bool hasReview(String sessionId) =>
      _reviews.any((r) => r.sesionId == sessionId);

  // ── Acciones ──

  void addSession(SessionModel session) {
    _sessions.add(session);
    notifyListeners();
  }

  void cancelSession(String sessionId,
      {String reason = 'Cancelada por usuario'}) {
    final idx = _sessions.indexWhere((s) => s.id == sessionId);
    if (idx == -1) return;
    _sessions[idx] = _sessions[idx].copyWith(
      estado: SessionStatus.cancelada,
      fechaCancelacion: DateTime.now(),
      motivoCancelacion: reason,
    );
    notifyListeners();
  }

  void confirmSession(String sessionId) {
    final idx = _sessions.indexWhere((s) => s.id == sessionId);
    if (idx == -1) return;
    _sessions[idx] =
        _sessions[idx].copyWith(estado: SessionStatus.confirmada);
    notifyListeners();
  }

  void rejectSession(String sessionId) {
    final idx = _sessions.indexWhere((s) => s.id == sessionId);
    if (idx == -1) return;
    _sessions[idx] = _sessions[idx].copyWith(
      estado: SessionStatus.cancelada,
      motivoCancelacion: 'Rechazada por tutor',
    );
    notifyListeners();
  }

  void addReview(ReviewModel review) {
    _reviews.add(review);
    notifyListeners();
  }
}
