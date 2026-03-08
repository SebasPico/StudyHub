import '../models/tutor_model.dart';
import '../models/student_model.dart';
import '../models/session_model.dart';
import '../models/review_model.dart';
import '../models/chat_model.dart';
import '../models/time_slot_model.dart';

/// Datos ficticios para la maquetación.
class MockData {
  MockData._();

  // ── Tutores ──

  static final List<TutorModel> tutores = [
    TutorModel(
      id: 't1',
      nombre: 'María García López',
      correo: 'maria@email.com',
      fotoUrl: 'https://i.pravatar.cc/150?img=1',
      ubicacion: 'Bogotá, Colombia',
      fechaRegistro: DateTime(2025, 1, 15),
      verificado: true,
      biografia:
          'Ingeniera de sistemas con 8 años de experiencia enseñando programación y matemáticas. Apasionada por la educación y las nuevas tecnologías.',
      materias: ['Programación', 'Matemáticas', 'Algoritmos'],
      certificados: ['Ingeniería de Sistemas - U. Nacional', 'Maestría en Educación'],
      tarifaPorHora: 45000,
      modalidad: Modalidad.ambas,
      calificacionPromedio: 4.8,
      totalResenas: 124,
      clasesImpartidas: 350,
      aprobadoPorAdmin: true,
    ),
    TutorModel(
      id: 't2',
      nombre: 'Carlos Rodríguez',
      correo: 'carlos@email.com',
      fotoUrl: 'https://i.pravatar.cc/150?img=3',
      ubicacion: 'Medellín, Colombia',
      fechaRegistro: DateTime(2025, 3, 10),
      verificado: true,
      biografia:
          'Profesor de inglés certificado por Cambridge con 5 años de experiencia. Clases dinámicas y personalizadas.',
      materias: ['Inglés', 'TOEFL', 'IELTS'],
      certificados: ['CELTA Cambridge', 'Licenciatura en Lenguas Modernas'],
      tarifaPorHora: 35000,
      modalidad: Modalidad.online,
      calificacionPromedio: 4.6,
      totalResenas: 89,
      clasesImpartidas: 200,
      aprobadoPorAdmin: true,
    ),
    TutorModel(
      id: 't3',
      nombre: 'Ana Martínez',
      correo: 'ana@email.com',
      fotoUrl: 'https://i.pravatar.cc/150?img=5',
      ubicacion: 'Cali, Colombia',
      fechaRegistro: DateTime(2025, 5, 20),
      verificado: false,
      biografia:
          'Física de la Universidad del Valle. Especialista en física para bachillerato y universidad.',
      materias: ['Física', 'Cálculo', 'Álgebra Lineal'],
      certificados: ['Física - U. del Valle'],
      tarifaPorHora: 40000,
      modalidad: Modalidad.presencial,
      calificacionPromedio: 4.9,
      totalResenas: 56,
      clasesImpartidas: 150,
      aprobadoPorAdmin: true,
    ),
    TutorModel(
      id: 't4',
      nombre: 'Diego Hernández',
      correo: 'diego@email.com',
      fotoUrl: 'https://i.pravatar.cc/150?img=8',
      ubicacion: 'Barranquilla, Colombia',
      fechaRegistro: DateTime(2025, 7, 5),
      verificado: true,
      biografia:
          'Contador público con amplia experiencia en tutorías de contabilidad y finanzas.',
      materias: ['Contabilidad', 'Finanzas', 'Estadística'],
      certificados: ['Contaduría Pública - U. del Norte'],
      tarifaPorHora: 38000,
      modalidad: Modalidad.ambas,
      calificacionPromedio: 4.5,
      totalResenas: 42,
      clasesImpartidas: 120,
      aprobadoPorAdmin: false,
    ),
    TutorModel(
      id: 't5',
      nombre: 'Laura Sánchez',
      correo: 'laura@email.com',
      fotoUrl: 'https://i.pravatar.cc/150?img=9',
      ubicacion: 'Bogotá, Colombia',
      fechaRegistro: DateTime(2025, 2, 28),
      verificado: true,
      biografia: 'Química farmacéutica. Clases de química orgánica e inorgánica con enfoque práctico.',
      materias: ['Química', 'Bioquímica', 'Biología'],
      certificados: ['Química Farmacéutica - U. Javeriana'],
      tarifaPorHora: 42000,
      modalidad: Modalidad.online,
      calificacionPromedio: 4.7,
      totalResenas: 73,
      clasesImpartidas: 180,
      aprobadoPorAdmin: true,
    ),
  ];

  // ── Estudiante actual (mock) ──

  static final StudentModel estudianteActual = StudentModel(
    id: 'e1',
    nombre: 'Juan Pérez',
    correo: 'juan@email.com',
    fotoUrl: 'https://i.pravatar.cc/150?img=11',
    ubicacion: 'Bogotá, Colombia',
    fechaRegistro: DateTime(2025, 6, 1),
    verificado: true,
    materiasInteres: ['Programación', 'Matemáticas', 'Inglés'],
    clasesTomadas: 12,
  );

  // ── Sesiones ──

  static final List<SessionModel> sesiones = [
    SessionModel(
      id: 's1',
      tutorId: 't1',
      tutorNombre: 'María García López',
      tutorFotoUrl: 'https://i.pravatar.cc/150?img=1',
      estudianteId: 'e1',
      estudianteNombre: 'Juan Pérez',
      materia: 'Programación en Dart',
      fechaHora: DateTime(2026, 3, 10, 14, 0),
      duracionMinutos: 60,
      modalidad: SessionModality.online,
      estado: SessionStatus.confirmada,
      precio: 45000,
      enlaceVideoconferencia: 'https://meet.google.com/abc-defg-hij',
    ),
    SessionModel(
      id: 's2',
      tutorId: 't2',
      tutorNombre: 'Carlos Rodríguez',
      tutorFotoUrl: 'https://i.pravatar.cc/150?img=3',
      estudianteId: 'e1',
      estudianteNombre: 'Juan Pérez',
      materia: 'Inglés - Conversacional',
      fechaHora: DateTime(2026, 3, 8, 10, 0),
      duracionMinutos: 90,
      modalidad: SessionModality.online,
      estado: SessionStatus.pendiente,
      precio: 52500,
    ),
    SessionModel(
      id: 's3',
      tutorId: 't3',
      tutorNombre: 'Ana Martínez',
      tutorFotoUrl: 'https://i.pravatar.cc/150?img=5',
      estudianteId: 'e1',
      estudianteNombre: 'Juan Pérez',
      materia: 'Física Mecánica',
      fechaHora: DateTime(2026, 2, 25, 16, 0),
      duracionMinutos: 60,
      modalidad: SessionModality.presencial,
      estado: SessionStatus.completada,
      precio: 40000,
      ubicacionPresencial: 'Biblioteca U. del Valle, Cali',
    ),
    SessionModel(
      id: 's4',
      tutorId: 't1',
      tutorNombre: 'María García López',
      tutorFotoUrl: 'https://i.pravatar.cc/150?img=1',
      estudianteId: 'e1',
      estudianteNombre: 'Juan Pérez',
      materia: 'Algoritmos',
      fechaHora: DateTime(2026, 2, 20, 9, 0),
      duracionMinutos: 60,
      modalidad: SessionModality.online,
      estado: SessionStatus.cancelada,
      precio: 45000,
      motivoCancelacion: 'Conflicto de horario',
    ),
  ];

  // ── Reseñas ──

  static final List<ReviewModel> resenas = [
    ReviewModel(
      id: 'r1',
      sesionId: 's3',
      tutorId: 't3',
      estudianteId: 'e1',
      estudianteNombre: 'Juan Pérez',
      estudianteFotoUrl: 'https://i.pravatar.cc/150?img=11',
      calificacion: 5.0,
      comentario:
          'Excelente tutora. Explica muy bien los conceptos y tiene mucha paciencia.',
      fecha: DateTime(2026, 2, 25),
    ),
    ReviewModel(
      id: 'r2',
      sesionId: 's1',
      tutorId: 't1',
      estudianteId: 'e2',
      estudianteNombre: 'Camila Torres',
      estudianteFotoUrl: 'https://i.pravatar.cc/150?img=12',
      calificacion: 4.5,
      comentario: 'Muy buena clase de programación. Aprendí mucho sobre Dart.',
      fecha: DateTime(2026, 2, 18),
    ),
    ReviewModel(
      id: 'r3',
      sesionId: 's2',
      tutorId: 't1',
      estudianteId: 'e3',
      estudianteNombre: 'Andrés López',
      estudianteFotoUrl: 'https://i.pravatar.cc/150?img=13',
      calificacion: 4.0,
      comentario: 'Buen tutor, puntual y organizado.',
      fecha: DateTime(2026, 1, 30),
    ),
  ];

  // ── Conversaciones ──

  static final List<ConversationModel> conversaciones = [
    ConversationModel(
      id: 'c1',
      otroUsuarioId: 't1',
      otroUsuarioNombre: 'María García López',
      otroUsuarioFotoUrl: 'https://i.pravatar.cc/150?img=1',
      ultimoMensaje: '¡Perfecto! Te envío el enlace antes de la clase.',
      fechaUltimoMensaje: DateTime(2026, 3, 6, 15, 30),
      mensajesNoLeidos: 2,
    ),
    ConversationModel(
      id: 'c2',
      otroUsuarioId: 't2',
      otroUsuarioNombre: 'Carlos Rodríguez',
      otroUsuarioFotoUrl: 'https://i.pravatar.cc/150?img=3',
      ultimoMensaje: '¿A qué hora te queda mejor la clase?',
      fechaUltimoMensaje: DateTime(2026, 3, 5, 20, 15),
      mensajesNoLeidos: 0,
    ),
    ConversationModel(
      id: 'c3',
      otroUsuarioId: 't3',
      otroUsuarioNombre: 'Ana Martínez',
      otroUsuarioFotoUrl: 'https://i.pravatar.cc/150?img=5',
      ultimoMensaje: 'Gracias por la clase, fue genial.',
      fechaUltimoMensaje: DateTime(2026, 2, 25, 18, 0),
      mensajesNoLeidos: 0,
    ),
  ];

  // ── Mensajes de chat (ejemplo de una conversación) ──

  static final List<ChatMessage> mensajesChat = [
    ChatMessage(
      id: 'm1',
      emisorId: 'e1',
      receptorId: 't1',
      contenido: 'Hola María, quisiera agendar una clase de Dart.',
      fecha: DateTime(2026, 3, 6, 14, 0),
      leido: true,
    ),
    ChatMessage(
      id: 'm2',
      emisorId: 't1',
      receptorId: 'e1',
      contenido: '¡Hola Juan! Claro, ¿qué temas necesitas reforzar?',
      fecha: DateTime(2026, 3, 6, 14, 5),
      leido: true,
    ),
    ChatMessage(
      id: 'm3',
      emisorId: 'e1',
      receptorId: 't1',
      contenido: 'Necesito repasar POO y patrones de diseño en Dart.',
      fecha: DateTime(2026, 3, 6, 14, 10),
      leido: true,
    ),
    ChatMessage(
      id: 'm4',
      emisorId: 't1',
      receptorId: 'e1',
      contenido: '¡Perfecto! Te envío el enlace antes de la clase.',
      fecha: DateTime(2026, 3, 6, 15, 30),
      leido: false,
    ),
  ];

  // ── Horarios disponibles ──

  static final List<TimeSlotModel> horariosDisponibles = [
    const TimeSlotModel(id: 'ts1', tutorId: 't1', diaSemana: 1, horaInicio: '08:00', horaFin: '10:00'),
    const TimeSlotModel(id: 'ts2', tutorId: 't1', diaSemana: 1, horaInicio: '14:00', horaFin: '17:00'),
    const TimeSlotModel(id: 'ts3', tutorId: 't1', diaSemana: 2, horaInicio: '09:00', horaFin: '12:00'),
    const TimeSlotModel(id: 'ts4', tutorId: 't1', diaSemana: 3, horaInicio: '08:00', horaFin: '11:00'),
    const TimeSlotModel(id: 'ts5', tutorId: 't1', diaSemana: 3, horaInicio: '15:00', horaFin: '18:00'),
    const TimeSlotModel(id: 'ts6', tutorId: 't1', diaSemana: 4, horaInicio: '10:00', horaFin: '13:00'),
    const TimeSlotModel(id: 'ts7', tutorId: 't1', diaSemana: 5, horaInicio: '08:00', horaFin: '12:00'),
    const TimeSlotModel(id: 'ts8', tutorId: 't1', diaSemana: 6, horaInicio: '09:00', horaFin: '11:00', disponible: false),
  ];

  // ── Materias populares ──

  static const List<String> materiasPopulares = [
    'Programación',
    'Matemáticas',
    'Inglés',
    'Física',
    'Química',
    'Contabilidad',
    'Cálculo',
    'Estadística',
    'Biología',
    'Álgebra',
    'Economía',
    'Francés',
  ];
}
