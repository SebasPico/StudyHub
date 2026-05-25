import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/mock/mock_data.dart';
import '../../data/models/chat_model.dart';
import '../../data/models/review_model.dart';
import '../../data/models/session_model.dart';
import '../../data/models/student_model.dart';
import '../../data/models/time_slot_model.dart';
import '../../data/models/tutor_model.dart';
import '../../data/models/user_model.dart';

/// Backend local improvisado basado en un JSON persistido en disco.
class StudyHubLocalBackend extends ChangeNotifier {
  static final StudyHubLocalBackend instance = StudyHubLocalBackend._();

  final List<Map<String, dynamic>> _users = [];
  final List<Map<String, dynamic>> _tutors = [];
  final List<Map<String, dynamic>> _students = [];
  final List<Map<String, dynamic>> _sessions = [];
  final List<Map<String, dynamic>> _reviews = [];
  final List<Map<String, dynamic>> _conversations = [];
  final Map<String, List<Map<String, dynamic>>> _messages = {};
  final List<Map<String, dynamic>> _timeSlots = [];

  Future<void>? _loadFuture;
  Future<void> _queue = Future<void>.value();

  StudyHubLocalBackend._() {
    _seedFromMockData();
  }

  Future<File> _databaseFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}${Platform.pathSeparator}studyhub_db.json');
  }

  Future<void> load() {
    _loadFuture ??= _loadFromDisk();
    return _loadFuture!;
  }

  Future<void> _loadFromDisk() async {
    try {
      final file = await _databaseFile();
      if (!await file.exists()) {
        await _saveToDisk();
        return;
      }

      final raw = await file.readAsString();
      if (raw.trim().isEmpty) {
        await _saveToDisk();
        return;
      }

      _replaceStateFromJson(jsonDecode(raw) as Map<String, dynamic>);
      notifyListeners();
    } catch (_) {
      await _saveToDisk();
    }
  }

  void _seedFromMockData() {
    _users
      ..clear()
      ..addAll([
        _userSeed(
          id: 'admin1',
          nombre: 'Administrador',
          correo: 'admin@studyhub.com',
          rol: UserRole.administrador,
        ),
        _userSeed(
          id: MockData.estudianteActual.id,
          nombre: MockData.estudianteActual.nombre,
          correo: MockData.estudianteActual.correo,
          rol: UserRole.estudiante,
          fotoUrl: MockData.estudianteActual.fotoUrl,
          telefono: MockData.estudianteActual.telefono,
          ubicacion: MockData.estudianteActual.ubicacion,
        ),
      ]);

    _students
      ..clear()
      ..add(_studentToMap(MockData.estudianteActual));

    _tutors
      ..clear()
      ..addAll(MockData.tutores.map(_tutorToMap));

    _sessions
      ..clear()
      ..addAll(MockData.sesiones.map(_sessionToMap));

    _reviews
      ..clear()
      ..addAll(MockData.resenas.map(_reviewToMap));

    _conversations
      ..clear()
      ..addAll(MockData.conversaciones.map(_conversationToMap));

    _messages
      ..clear()
      ..addAll({
        'c1': MockData.mensajesChat.map(_messageToMap).toList(),
        'c2': <Map<String, dynamic>>[],
        'c3': <Map<String, dynamic>>[],
      });

    _timeSlots
      ..clear()
      ..addAll(MockData.horariosDisponibles.map(_timeSlotToMap));

    // Ensure demo student and tutor exist for quick demonstration/login.
    const demoStudentId = 'demo_student';
    const demoTutorId = 'demo_tutor';

    if (!_users.any((u) => u['id'] == demoStudentId)) {
      _users.add(_userSeed(
        id: demoStudentId,
        nombre: 'Estudiante Demo',
        correo: 'student@studyhub.com',
        rol: UserRole.estudiante,
        password: 'demo123',
      ));

      _students.add(_studentToMap(
        StudentModel(
          id: demoStudentId,
          nombre: 'Estudiante Demo',
          correo: 'student@studyhub.com',
          fechaRegistro: DateTime.now(),
        ),
      ));
    }

    if (!_users.any((u) => u['id'] == demoTutorId)) {
      _users.add(_userSeed(
        id: demoTutorId,
        nombre: 'Tutor Demo',
        correo: 'tutor@studyhub.com',
        rol: UserRole.tutor,
        password: 'demo123',
      ));

      _tutors.add(_tutorToMap(
        TutorModel(
          id: demoTutorId,
          nombre: 'Tutor Demo',
          correo: 'tutor@studyhub.com',
          fechaRegistro: DateTime.now(),
          biografia: 'Tutor de demostración',
          materias: const ['Matemáticas', 'Programación'],
          certificados: const [],
          tarifaPorHora: 25000,
          modalidad: Modalidad.ambas,
          aprobadoPorAdmin: true,
        ),
      ));
    }
  }

  void _replaceStateFromJson(Map<String, dynamic> json) {
    _users
      ..clear()
      ..addAll((json['users'] as List<dynamic>? ?? const [])
          .cast<Map<String, dynamic>>());
    _tutors
      ..clear()
      ..addAll((json['tutors'] as List<dynamic>? ?? const [])
          .cast<Map<String, dynamic>>());
    _students
      ..clear()
      ..addAll((json['students'] as List<dynamic>? ?? const [])
          .cast<Map<String, dynamic>>());
    _sessions
      ..clear()
      ..addAll((json['sessions'] as List<dynamic>? ?? const [])
          .cast<Map<String, dynamic>>());
    _reviews
      ..clear()
      ..addAll((json['reviews'] as List<dynamic>? ?? const [])
          .cast<Map<String, dynamic>>());
    _conversations
      ..clear()
      ..addAll((json['conversations'] as List<dynamic>? ?? const [])
          .cast<Map<String, dynamic>>());
    _timeSlots
      ..clear()
      ..addAll((json['timeSlots'] as List<dynamic>? ?? const [])
          .cast<Map<String, dynamic>>());
    _messages
      ..clear()
      ..addAll({
        for (final entry in (json['messages'] as Map<String, dynamic>? ?? const {}).entries)
          entry.key: (entry.value as List<dynamic>? ?? const [])
              .cast<Map<String, dynamic>>(),
      });
  }

  Future<void> _saveToDisk() async {
    final file = await _databaseFile();
    await file.writeAsString(
      jsonEncode({
        'users': _users,
        'tutors': _tutors,
        'students': _students,
        'sessions': _sessions,
        'reviews': _reviews,
        'conversations': _conversations,
        'messages': _messages,
        'timeSlots': _timeSlots,
      }),
      flush: true,
    );
  }

  Future<T> _atomic<T>(Future<T> Function() action) {
    final completer = Completer<T>();
    _queue = _queue.then((_) async {
      try {
        completer.complete(await action());
      } catch (error, stackTrace) {
        completer.completeError(error, stackTrace);
      }
    });
    return completer.future;
  }

  List<TutorModel> get tutors => List.unmodifiable(_tutors.map(_mapToTutor));
  List<StudentModel> get students => List.unmodifiable(_students.map(_mapToStudent));
  List<SessionModel> get sessions => List.unmodifiable(_sessions.map(_mapToSession));
  List<ReviewModel> get reviews => List.unmodifiable(_reviews.map(_mapToReview));
  List<ConversationModel> get conversations =>
      List.unmodifiable(_conversations.map(_mapToConversation));
  List<TimeSlotModel> get timeSlots => List.unmodifiable(_timeSlots.map(_mapToTimeSlot));

  Map<String, List<ChatMessage>> get messagesByConversation {
    return {
      for (final entry in _messages.entries)
        entry.key: List.unmodifiable(entry.value.map(_mapToMessage)),
    };
  }

  TutorModel? tutorById(String id) => tutors.where((tutor) => tutor.id == id).firstOrNull;

  StudentModel? studentById(String id) => students.where((student) => student.id == id).firstOrNull;

  List<ReviewModel> reviewsForTutor(String tutorId) =>
      reviews.where((review) => review.tutorId == tutorId).toList();

  Future<AuthSessionData> authenticate(String email, String password) async {
    final normalized = email.trim().toLowerCase();
    if (normalized == 'admin@studyhub.com') {
      return const AuthSessionData(
        role: UserRole.administrador,
        userId: 'admin1',
        userName: 'Administrador',
      );
    }

    final user = _users
        .where((item) => (item['correo'] as String).toLowerCase() == normalized)
        .firstOrNull;
    if (user == null) {
      throw StateError('invalid_credentials');
    }

    _validatePassword(user, password);

    switch (user['rol'] as String) {
      case 'tutor':
        final tutor = tutorById(user['id'] as String);
        return AuthSessionData(
          role: UserRole.tutor,
          userId: user['id'] as String,
          userName: tutor?.nombre ?? user['nombre'] as String,
          userPhoto: tutor?.fotoUrl ?? user['fotoUrl'] as String?,
          userLocation: tutor?.ubicacion ?? user['ubicacion'] as String? ?? '',
          userPhone: tutor?.telefono ?? user['telefono'] as String? ?? '',
        );
      case 'estudiante':
        final student = studentById(user['id'] as String);
        return AuthSessionData(
          role: UserRole.estudiante,
          userId: user['id'] as String,
          userName: student?.nombre ?? user['nombre'] as String,
          userPhoto: student?.fotoUrl ?? user['fotoUrl'] as String?,
          userLocation: student?.ubicacion ?? user['ubicacion'] as String? ?? '',
          userPhone: student?.telefono ?? user['telefono'] as String? ?? '',
        );
      default:
        return const AuthSessionData(
          role: UserRole.administrador,
          userId: 'admin1',
          userName: 'Administrador',
        );
    }
  }

  void _validatePassword(Map<String, dynamic> user, String password) {
    final stored = (user['password'] as String?) ?? '';
    if (stored.isNotEmpty && stored != password) {
      throw StateError('invalid_credentials');
    }
  }

  Future<AuthSessionData> register({
    required String nombre,
    required String email,
    required UserRole rol,
    required String password,
  }) {
    return _atomic(() async {
      final normalized = email.trim().toLowerCase();
      if (_users.any((user) => (user['correo'] as String).toLowerCase() == normalized)) {
        throw StateError('user_exists');
      }

      final userId = '${rol.name}_${DateTime.now().millisecondsSinceEpoch}';
      _users.add(_userSeed(
        id: userId,
        nombre: nombre.trim(),
        correo: normalized,
        rol: rol,
        password: password,
      ));

      if (rol == UserRole.tutor) {
        _tutors.add(_tutorToMap(
          TutorModel(
            id: userId,
            nombre: nombre.trim(),
            correo: normalized,
            fechaRegistro: DateTime.now(),
            biografia: 'Nuevo tutor en proceso de verificación.',
            materias: const ['Materia por definir'],
            certificados: const [],
            tarifaPorHora: 0,
            modalidad: Modalidad.ambas,
            aprobadoPorAdmin: false,
          ),
        ));
      } else {
        _students.add(_studentToMap(
          StudentModel(
            id: userId,
            nombre: nombre.trim(),
            correo: normalized,
            fechaRegistro: DateTime.now(),
          ),
        ));
      }

      await _saveToDisk();
      notifyListeners();
      return AuthSessionData(role: rol, userId: userId, userName: nombre.trim());
    });
  }

  Future<void> updateCurrentUserProfile({
    required String userId,
    required String nombre,
    required String ubicacion,
    required String telefono,
    String? fotoUrl,
  }) {
    return _atomic(() async {
      final userIdx = _users.indexWhere((user) => user['id'] == userId);
      if (userIdx != -1) {
        _users[userIdx] = {
          ..._users[userIdx],
          'nombre': nombre,
          'ubicacion': ubicacion,
          'telefono': telefono,
          if (fotoUrl != null) 'fotoUrl': fotoUrl,
        };
      }

      final studentIdx = _students.indexWhere((student) => student['id'] == userId);
      if (studentIdx != -1) {
        _students[studentIdx] = {
          ..._students[studentIdx],
          'nombre': nombre,
          'ubicacion': ubicacion,
          'telefono': telefono,
          if (fotoUrl != null) 'fotoUrl': fotoUrl,
        };
      }

      final tutorIdx = _tutors.indexWhere((tutor) => tutor['id'] == userId);
      if (tutorIdx != -1) {
        _tutors[tutorIdx] = {
          ..._tutors[tutorIdx],
          'nombre': nombre,
          'ubicacion': ubicacion,
          'telefono': telefono,
          if (fotoUrl != null) 'fotoUrl': fotoUrl,
        };
      }

      await _saveToDisk();
      notifyListeners();
    });
  }

  Future<void> approveTutor(String tutorId) => _updateTutor(tutorId, (map) {
        map['aprobadoPorAdmin'] = true;
      });

  Future<void> removeTutor(String tutorId) {
    return _atomic(() async {
      _tutors.removeWhere((tutor) => tutor['id'] == tutorId);
      _users.removeWhere((user) => user['id'] == tutorId);
      await _saveToDisk();
      notifyListeners();
    });
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
  }) {
    return _updateTutor(tutorId, (map) {
      if (nombre != null && nombre.isNotEmpty) map['nombre'] = nombre;
      if (ubicacion != null) map['ubicacion'] = ubicacion;
      if (biografia != null) map['biografia'] = biografia;
      if (materias != null) map['materias'] = materias;
      if (certificados != null) map['certificados'] = certificados;
      if (tarifaPorHora != null) map['tarifaPorHora'] = tarifaPorHora;
      if (modalidad != null) map['modalidad'] = modalidad.name;
    });
  }

  Future<void> addSession(SessionModel session) {
    return _atomic(() async {
      final conflict = _sessions.any((existing) {
        if (existing['tutorId'] != session.tutorId) return false;
        final existingStart = DateTime.parse(existing['fechaHora'] as String);
        final existingDuration = (existing['duracionMinutos'] as num?)?.toInt() ?? 60;
        final existingEnd = existingStart.add(Duration(minutes: existingDuration));
        final newStart = session.fechaHora;
        final newEnd = newStart.add(Duration(minutes: session.duracionMinutos));
        final blocked = existing['estado'] != SessionStatus.cancelada.name;
        return blocked && newStart.isBefore(existingEnd) && newEnd.isAfter(existingStart);
      });

      if (conflict) {
        throw StateError('slot_taken');
      }

      _sessions.add(_sessionToMap(session));
      await _saveToDisk();
      notifyListeners();
    });
  }

  Future<void> cancelSession(String sessionId, {String reason = 'Cancelada por usuario'}) {
    return _updateSession(sessionId, (map) {
      map['estado'] = SessionStatus.cancelada.name;
      map['fechaCancelacion'] = DateTime.now().toIso8601String();
      map['motivoCancelacion'] = reason;
    });
  }

  Future<void> confirmSession(String sessionId) {
    return _updateSession(sessionId, (map) {
      map['estado'] = SessionStatus.confirmada.name;
    });
  }

  Future<void> rejectSession(String sessionId) {
    return _updateSession(sessionId, (map) {
      map['estado'] = SessionStatus.cancelada.name;
      map['motivoCancelacion'] = 'Rechazada por tutor';
      map['fechaCancelacion'] = DateTime.now().toIso8601String();
    });
  }

  Future<void> addReview(ReviewModel review) {
    return _atomic(() async {
      final existing = _reviews.indexWhere((item) => item['sesionId'] == review.sesionId);
      if (existing != -1) {
        _reviews[existing] = _reviewToMap(review);
      } else {
        _reviews.add(_reviewToMap(review));
      }

      final tutorIdx = _tutors.indexWhere((tutor) => tutor['id'] == review.tutorId);
      if (tutorIdx != -1) {
        final tutorReviews = reviewsForTutor(review.tutorId);
        final total = tutorReviews.map((reviewItem) => reviewItem.calificacion).fold<double>(0, (a, b) => a + b);
        final average = tutorReviews.isEmpty ? 0 : total / tutorReviews.length;
        _tutors[tutorIdx] = {
          ..._tutors[tutorIdx],
          'calificacionPromedio': double.parse(average.toStringAsFixed(2)),
          'totalResenas': tutorReviews.length,
        };
      }

      await _saveToDisk();
      notifyListeners();
    });
  }

  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String receiverId,
    required String text,
    String? receiverName,
    String? receiverPhoto,
  }) {
    return _atomic(() async {
      final key = _resolveConversationKey(conversationId, receiverId);
      final messages = _messages.putIfAbsent(key, () => <Map<String, dynamic>>[]);
      messages.add(_messageToMap(ChatMessage(
        id: 'm${DateTime.now().millisecondsSinceEpoch}',
        emisorId: senderId,
        receptorId: receiverId,
        contenido: text,
        fecha: DateTime.now(),
        leido: false,
      )));

      final convIdx = _conversations.indexWhere((conversation) => conversation['id'] == key);
      if (convIdx != -1) {
        _conversations[convIdx] = {
          ..._conversations[convIdx],
          'ultimoMensaje': text,
          'fechaUltimoMensaje': DateTime.now().toIso8601String(),
          'mensajesNoLeidos': 0,
        };
      } else {
        _conversations.insert(
          0,
          _conversationToMap(ConversationModel(
            id: key,
            otroUsuarioId: receiverId,
            otroUsuarioNombre: receiverName ?? 'Tutor',
            otroUsuarioFotoUrl: receiverPhoto,
            ultimoMensaje: text,
            fechaUltimoMensaje: DateTime.now(),
            mensajesNoLeidos: 0,
          )),
        );
      }

      await _saveToDisk();
      notifyListeners();
    });
  }

  Future<void> markAsRead(String conversationId) {
    return _atomic(() async {
      final idx = _conversations.indexWhere((conversation) => conversation['id'] == conversationId);
      if (idx == -1) return;
      _conversations[idx] = {
        ..._conversations[idx],
        'mensajesNoLeidos': 0,
      };
      await _saveToDisk();
      notifyListeners();
    });
  }

  Future<void> upsertTimeSlot(TimeSlotModel slot) {
    return _atomic(() async {
      final idx = _timeSlots.indexWhere((item) => item['id'] == slot.id);
      final encoded = _timeSlotToMap(slot);
      if (idx == -1) {
        _timeSlots.add(encoded);
      } else {
        _timeSlots[idx] = encoded;
      }
      await _saveToDisk();
      notifyListeners();
    });
  }

  Future<void> removeTimeSlot(String slotId) {
    return _atomic(() async {
      _timeSlots.removeWhere((slot) => slot['id'] == slotId);
      await _saveToDisk();
      notifyListeners();
    });
  }

  Future<void> _updateSession(String sessionId, void Function(Map<String, dynamic>) updater) {
    return _atomic(() async {
      final idx = _sessions.indexWhere((session) => session['id'] == sessionId);
      if (idx == -1) return;
      final updated = Map<String, dynamic>.from(_sessions[idx]);
      updater(updated);
      _sessions[idx] = updated;
      await _saveToDisk();
      notifyListeners();
    });
  }

  Future<void> _updateTutor(String tutorId, void Function(Map<String, dynamic>) updater) {
    return _atomic(() async {
      final idx = _tutors.indexWhere((tutor) => tutor['id'] == tutorId);
      if (idx == -1) return;
      final updated = Map<String, dynamic>.from(_tutors[idx]);
      updater(updated);
      _tutors[idx] = updated;
      await _saveToDisk();
      notifyListeners();
    });
  }

  String _resolveConversationKey(String conversationId, String receiverId) {
    if (_messages.containsKey(conversationId)) return conversationId;
    final existing = _conversations.firstWhere(
      (conversation) => conversation['otroUsuarioId'] == receiverId,
      orElse: () => <String, dynamic>{},
    );
    if (existing.isNotEmpty) return existing['id'] as String;
    return conversationId;
  }

  Map<String, dynamic> _userSeed({
    required String id,
    required String nombre,
    required String correo,
    required UserRole rol,
    String? fotoUrl,
    String? telefono,
    String? ubicacion,
    String password = '',
  }) {
    return {
      'id': id,
      'nombre': nombre,
      'correo': correo,
      'fotoUrl': fotoUrl,
      'telefono': telefono,
      'ubicacion': ubicacion,
      'rol': rol.name,
      'fechaRegistro': DateTime.now().toIso8601String(),
      'verificado': false,
      'password': password,
    };
  }

  Map<String, dynamic> _toUserMap(UserModel user, {String password = ''}) {
    return {
      'id': user.id,
      'nombre': user.nombre,
      'correo': user.correo,
      'fotoUrl': user.fotoUrl,
      'telefono': user.telefono,
      'ubicacion': user.ubicacion,
      'rol': user.rol.name,
      'fechaRegistro': user.fechaRegistro.toIso8601String(),
      'verificado': user.verificado,
      'password': password,
    };
  }

  Map<String, dynamic> _tutorToMap(TutorModel tutor) {
    return {
      ..._toUserMap(tutor),
      'biografia': tutor.biografia,
      'materias': tutor.materias,
      'certificados': tutor.certificados,
      'tarifaPorHora': tutor.tarifaPorHora,
      'modalidad': tutor.modalidad.name,
      'calificacionPromedio': tutor.calificacionPromedio,
      'totalResenas': tutor.totalResenas,
      'clasesImpartidas': tutor.clasesImpartidas,
      'aprobadoPorAdmin': tutor.aprobadoPorAdmin,
      'documentosVerificacion': tutor.documentosVerificacion,
    };
  }

  Map<String, dynamic> _studentToMap(StudentModel student) {
    return {
      ..._toUserMap(student),
      'materiasInteres': student.materiasInteres,
      'clasesTomadas': student.clasesTomadas,
    };
  }

  Map<String, dynamic> _sessionToMap(SessionModel session) {
    return {
      'id': session.id,
      'tutorId': session.tutorId,
      'tutorNombre': session.tutorNombre,
      'tutorFotoUrl': session.tutorFotoUrl,
      'estudianteId': session.estudianteId,
      'estudianteNombre': session.estudianteNombre,
      'materia': session.materia,
      'fechaHora': session.fechaHora.toIso8601String(),
      'duracionMinutos': session.duracionMinutos,
      'modalidad': session.modalidad.name,
      'estado': session.estado.name,
      'precio': session.precio,
      'enlaceVideoconferencia': session.enlaceVideoconferencia,
      'ubicacionPresencial': session.ubicacionPresencial,
      'notas': session.notas,
      'fechaCancelacion': session.fechaCancelacion?.toIso8601String(),
      'motivoCancelacion': session.motivoCancelacion,
    };
  }

  Map<String, dynamic> _reviewToMap(ReviewModel review) {
    return {
      'id': review.id,
      'sesionId': review.sesionId,
      'tutorId': review.tutorId,
      'estudianteId': review.estudianteId,
      'estudianteNombre': review.estudianteNombre,
      'estudianteFotoUrl': review.estudianteFotoUrl,
      'calificacion': review.calificacion,
      'comentario': review.comentario,
      'fecha': review.fecha.toIso8601String(),
    };
  }

  Map<String, dynamic> _conversationToMap(ConversationModel conversation) {
    return {
      'id': conversation.id,
      'otroUsuarioId': conversation.otroUsuarioId,
      'otroUsuarioNombre': conversation.otroUsuarioNombre,
      'otroUsuarioFotoUrl': conversation.otroUsuarioFotoUrl,
      'ultimoMensaje': conversation.ultimoMensaje,
      'fechaUltimoMensaje': conversation.fechaUltimoMensaje.toIso8601String(),
      'mensajesNoLeidos': conversation.mensajesNoLeidos,
    };
  }

  Map<String, dynamic> _messageToMap(ChatMessage message) {
    return {
      'id': message.id,
      'emisorId': message.emisorId,
      'receptorId': message.receptorId,
      'contenido': message.contenido,
      'fecha': message.fecha.toIso8601String(),
      'leido': message.leido,
    };
  }

  Map<String, dynamic> _timeSlotToMap(TimeSlotModel slot) {
    return {
      'id': slot.id,
      'tutorId': slot.tutorId,
      'diaSemana': slot.diaSemana,
      'horaInicio': slot.horaInicio,
      'horaFin': slot.horaFin,
      'disponible': slot.disponible,
    };
  }

  TutorModel _mapToTutor(Map<String, dynamic> json) {
    return TutorModel(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      correo: json['correo'] as String,
      fotoUrl: json['fotoUrl'] as String?,
      telefono: json['telefono'] as String?,
      ubicacion: json['ubicacion'] as String?,
      fechaRegistro: DateTime.parse(json['fechaRegistro'] as String),
      verificado: json['verificado'] as bool? ?? false,
      biografia: json['biografia'] as String? ?? '',
      materias: List<String>.from(json['materias'] as List<dynamic>? ?? const []),
      certificados: List<String>.from(json['certificados'] as List<dynamic>? ?? const []),
      tarifaPorHora: (json['tarifaPorHora'] as num?)?.toDouble() ?? 0,
      modalidad: _parseModalidad(json['modalidad'] as String?),
      calificacionPromedio: (json['calificacionPromedio'] as num?)?.toDouble() ?? 0,
      totalResenas: (json['totalResenas'] as num?)?.toInt() ?? 0,
      clasesImpartidas: (json['clasesImpartidas'] as num?)?.toInt() ?? 0,
      aprobadoPorAdmin: json['aprobadoPorAdmin'] as bool? ?? false,
      documentosVerificacion: List<String>.from(
        json['documentosVerificacion'] as List<dynamic>? ?? const [],
      ),
    );
  }

  StudentModel _mapToStudent(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      correo: json['correo'] as String,
      fotoUrl: json['fotoUrl'] as String?,
      telefono: json['telefono'] as String?,
      ubicacion: json['ubicacion'] as String?,
      fechaRegistro: DateTime.parse(json['fechaRegistro'] as String),
      verificado: json['verificado'] as bool? ?? false,
      materiasInteres: List<String>.from(
        json['materiasInteres'] as List<dynamic>? ?? const [],
      ),
      clasesTomadas: (json['clasesTomadas'] as num?)?.toInt() ?? 0,
    );
  }

  SessionModel _mapToSession(Map<String, dynamic> json) {
    return SessionModel(
      id: json['id'] as String,
      tutorId: json['tutorId'] as String,
      tutorNombre: json['tutorNombre'] as String,
      tutorFotoUrl: json['tutorFotoUrl'] as String?,
      estudianteId: json['estudianteId'] as String,
      estudianteNombre: json['estudianteNombre'] as String,
      materia: json['materia'] as String,
      fechaHora: DateTime.parse(json['fechaHora'] as String),
      duracionMinutos: (json['duracionMinutos'] as num?)?.toInt() ?? 60,
      modalidad: _parseSessionModality(json['modalidad'] as String?),
      estado: _parseSessionStatus(json['estado'] as String?),
      precio: (json['precio'] as num?)?.toDouble() ?? 0,
      enlaceVideoconferencia: json['enlaceVideoconferencia'] as String?,
      ubicacionPresencial: json['ubicacionPresencial'] as String?,
      notas: json['notas'] as String?,
      fechaCancelacion: json['fechaCancelacion'] == null
          ? null
          : DateTime.parse(json['fechaCancelacion'] as String),
      motivoCancelacion: json['motivoCancelacion'] as String?,
    );
  }

  ReviewModel _mapToReview(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      sesionId: json['sesionId'] as String,
      tutorId: json['tutorId'] as String,
      estudianteId: json['estudianteId'] as String,
      estudianteNombre: json['estudianteNombre'] as String,
      estudianteFotoUrl: json['estudianteFotoUrl'] as String?,
      calificacion: (json['calificacion'] as num).toDouble(),
      comentario: json['comentario'] as String? ?? '',
      fecha: DateTime.parse(json['fecha'] as String),
    );
  }

  ConversationModel _mapToConversation(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] as String,
      otroUsuarioId: json['otroUsuarioId'] as String,
      otroUsuarioNombre: json['otroUsuarioNombre'] as String,
      otroUsuarioFotoUrl: json['otroUsuarioFotoUrl'] as String?,
      ultimoMensaje: json['ultimoMensaje'] as String,
      fechaUltimoMensaje: DateTime.parse(json['fechaUltimoMensaje'] as String),
      mensajesNoLeidos: (json['mensajesNoLeidos'] as num?)?.toInt() ?? 0,
    );
  }

  ChatMessage _mapToMessage(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      emisorId: json['emisorId'] as String,
      receptorId: json['receptorId'] as String,
      contenido: json['contenido'] as String,
      fecha: DateTime.parse(json['fecha'] as String),
      leido: json['leido'] as bool? ?? false,
    );
  }

  TimeSlotModel _mapToTimeSlot(Map<String, dynamic> json) {
    return TimeSlotModel(
      id: json['id'] as String,
      tutorId: json['tutorId'] as String,
      diaSemana: (json['diaSemana'] as num).toInt(),
      horaInicio: json['horaInicio'] as String,
      horaFin: json['horaFin'] as String,
      disponible: json['disponible'] as bool? ?? true,
    );
  }

  Modalidad _parseModalidad(String? raw) {
    switch (raw) {
      case 'presencial':
        return Modalidad.presencial;
      case 'ambas':
        return Modalidad.ambas;
      default:
        return Modalidad.online;
    }
  }

  SessionModality _parseSessionModality(String? raw) {
    return raw == 'presencial' ? SessionModality.presencial : SessionModality.online;
  }

  SessionStatus _parseSessionStatus(String? raw) {
    switch (raw) {
      case 'confirmada':
        return SessionStatus.confirmada;
      case 'completada':
        return SessionStatus.completada;
      case 'cancelada':
        return SessionStatus.cancelada;
      default:
        return SessionStatus.pendiente;
    }
  }
}

class AuthSessionData {
  final UserRole role;
  final String userId;
  final String userName;
  final String? userPhoto;
  final String userLocation;
  final String userPhone;

  const AuthSessionData({
    required this.role,
    required this.userId,
    required this.userName,
    this.userPhoto,
    this.userLocation = '',
    this.userPhone = '',
  });
}
