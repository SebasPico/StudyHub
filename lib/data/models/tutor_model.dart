import 'user_model.dart';

/// Enum de modalidad de enseñanza.
enum Modalidad { online, presencial, ambas }

/// Modelo de perfil de tutor.
class TutorModel extends UserModel {
  final String biografia;
  final List<String> materias;
  final List<String> certificados;
  final double tarifaPorHora;
  final Modalidad modalidad;
  final double calificacionPromedio;
  final int totalResenas;
  final int clasesImpartidas;
  final bool aprobadoPorAdmin;
  final List<String> documentosVerificacion;

  const TutorModel({
    required super.id,
    required super.nombre,
    required super.correo,
    super.fotoUrl,
    super.telefono,
    super.ubicacion,
    required super.fechaRegistro,
    super.verificado,
    this.biografia = '',
    this.materias = const [],
    this.certificados = const [],
    this.tarifaPorHora = 0,
    this.modalidad = Modalidad.online,
    this.calificacionPromedio = 0,
    this.totalResenas = 0,
    this.clasesImpartidas = 0,
    this.aprobadoPorAdmin = false,
    this.documentosVerificacion = const [],
  }) : super(rol: UserRole.tutor);

  TutorModel copyWith({
    bool? aprobadoPorAdmin,
    bool? verificado,
    String? nombre,
    String? ubicacion,
    String? biografia,
    List<String>? materias,
    List<String>? certificados,
    double? tarifaPorHora,
    Modalidad? modalidad,
  }) {
    return TutorModel(
      id: id,
      nombre: nombre ?? this.nombre,
      correo: correo,
      fotoUrl: fotoUrl,
      telefono: telefono,
      ubicacion: ubicacion ?? this.ubicacion,
      fechaRegistro: fechaRegistro,
      verificado: verificado ?? this.verificado,
      biografia: biografia ?? this.biografia,
      materias: materias ?? this.materias,
      certificados: certificados ?? this.certificados,
      tarifaPorHora: tarifaPorHora ?? this.tarifaPorHora,
      modalidad: modalidad ?? this.modalidad,
      calificacionPromedio: calificacionPromedio,
      totalResenas: totalResenas,
      clasesImpartidas: clasesImpartidas,
      aprobadoPorAdmin: aprobadoPorAdmin ?? this.aprobadoPorAdmin,
      documentosVerificacion: documentosVerificacion,
    );
  }
}
