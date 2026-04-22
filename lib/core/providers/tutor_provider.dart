import 'package:flutter/foundation.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/tutor_model.dart';

/// Gestión reactiva de la lista de tutores (aprobación, eliminación).
class TutorProvider extends ChangeNotifier {
  final List<TutorModel> _tutors;

  TutorProvider() : _tutors = List<TutorModel>.from(MockData.tutores);

  List<TutorModel> get all => List.unmodifiable(_tutors);
  List<TutorModel> get approved =>
      _tutors.where((t) => t.aprobadoPorAdmin).toList();
  List<TutorModel> get pending =>
      _tutors.where((t) => !t.aprobadoPorAdmin).toList();

  TutorModel? byId(String id) =>
      _tutors.cast<TutorModel?>().firstWhere((t) => t!.id == id,
          orElse: () => null);

  void approveTutor(String tutorId) {
    final idx = _tutors.indexWhere((t) => t.id == tutorId);
    if (idx == -1) return;
    _tutors[idx] = _tutors[idx].copyWith(aprobadoPorAdmin: true);
    notifyListeners();
  }

  void removeTutor(String tutorId) {
    _tutors.removeWhere((t) => t.id == tutorId);
    notifyListeners();
  }
}
