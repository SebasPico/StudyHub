import 'package:flutter/foundation.dart';
import '../../data/models/tutor_model.dart';
import '../services/studyhub_local_backend.dart';

/// Gestión reactiva de la lista de tutores (aprobación, eliminación).
class TutorProvider extends ChangeNotifier {
  final StudyHubLocalBackend _backend;
  late List<TutorModel> _tutors;

  TutorProvider({StudyHubLocalBackend? backend})
      : _backend = backend ?? StudyHubLocalBackend.instance {
    _tutors = List<TutorModel>.from(_backend.tutors);
    _backend.addListener(_syncFromBackend);
  }

  void _syncFromBackend() {
    _tutors = List<TutorModel>.from(_backend.tutors);
    notifyListeners();
  }

  List<TutorModel> get all => List.unmodifiable(_tutors);
  List<TutorModel> get approved =>
      _tutors.where((t) => t.aprobadoPorAdmin).toList();
  List<TutorModel> get pending =>
      _tutors.where((t) => !t.aprobadoPorAdmin).toList();

  TutorModel? byId(String id) =>
      _tutors.cast<TutorModel?>().firstWhere((t) => t!.id == id,
          orElse: () => null);

  Future<void> approveTutor(String tutorId) async {
    await _backend.approveTutor(tutorId);
    _syncFromBackend();
  }

  Future<void> removeTutor(String tutorId) async {
    await _backend.removeTutor(tutorId);
    _syncFromBackend();
  }

  Future<void> updateTutor(
    String tutorId, {
    String? nombre,
    String? ubicacion,
    String? biografia,
    List<String>? materias,
    List<String>? certificados,
    double? tarifaPorHora,
    Modalidad? modalidad,
  }) async {
    await _backend.updateTutor(
      tutorId,
      nombre: nombre,
      ubicacion: ubicacion,
      biografia: biografia,
      materias: materias,
      certificados: certificados,
      tarifaPorHora: tarifaPorHora,
      modalidad: modalidad,
    );
    _syncFromBackend();
  }

  @override
  void dispose() {
    _backend.removeListener(_syncFromBackend);
    super.dispose();
  }
}
