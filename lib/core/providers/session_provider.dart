import 'package:flutter/foundation.dart';
import '../../data/models/session_model.dart';
import '../../data/models/review_model.dart';
import '../services/studyhub_local_backend.dart';

/// Gestión reactiva de sesiones y reseñas.
class SessionProvider extends ChangeNotifier {
  final StudyHubLocalBackend _backend;
  late List<SessionModel> _sessions;
  late List<ReviewModel> _reviews;

  SessionProvider({StudyHubLocalBackend? backend})
      : _backend = backend ?? StudyHubLocalBackend.instance {
    _sessions = List<SessionModel>.from(_backend.sessions);
    _reviews = List<ReviewModel>.from(_backend.reviews);
    _backend.addListener(_syncFromBackend);
  }

  void _syncFromBackend() {
    _sessions = List<SessionModel>.from(_backend.sessions);
    _reviews = List<ReviewModel>.from(_backend.reviews);
    notifyListeners();
  }

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

  Future<void> addSession(SessionModel session) async {
    await _backend.addSession(session);
    _syncFromBackend();
  }

  Future<void> cancelSession(String sessionId,
      {String reason = 'Cancelada por usuario'}) {
    return _backend.cancelSession(sessionId, reason: reason).then((_) {
      _syncFromBackend();
    });
  }

  Future<void> confirmSession(String sessionId) async {
    await _backend.confirmSession(sessionId);
    _syncFromBackend();
  }

  Future<void> rejectSession(String sessionId) async {
    await _backend.rejectSession(sessionId);
    _syncFromBackend();
  }

  Future<void> addReview(ReviewModel review) async {
    await _backend.addReview(review);
    _syncFromBackend();
  }

  @override
  void dispose() {
    _backend.removeListener(_syncFromBackend);
    super.dispose();
  }
}
