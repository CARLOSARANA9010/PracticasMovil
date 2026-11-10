import 'dart:typed_data';

/// Visita registrada a un sitio de Campeche.
class Registro {
  final int? id;
  final String lugar;
  final String categoria;
  final String nota;
  final int calificacion;
  final double? latitud;
  final double? longitud;
  final DateTime fecha;
  final Uint8List? foto;
  final double? temperatura;

  const Registro({
    this.id,
    required this.lugar,
    required this.categoria,
    required this.nota,
    required this.calificacion,
    this.latitud,
    this.longitud,
    required this.fecha,
    this.foto,
    this.temperatura,
  });

  static const List<String> categorias = [
    'Playa',
    'Museo',
    'Gastronomía',
    'Historia',
    'Naturaleza',
    'Otro',
  ];

  bool get tieneUbicacion => latitud != null && longitud != null;

  Registro copyWith({int? id}) => Registro(
    id: id ?? this.id,
    lugar: lugar,
    categoria: categoria,
    nota: nota,
    calificacion: calificacion,
    latitud: latitud,
    longitud: longitud,
    fecha: fecha,
    foto: foto,
    temperatura: temperatura,
  );

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'lugar': lugar,
    'categoria': categoria,
    'nota': nota,
    'calificacion': calificacion,
    'latitud': latitud,
    'longitud': longitud,
    'fecha': fecha.toIso8601String(),
    'foto': foto,
    'temperatura': temperatura,
  };

  factory Registro.fromMap(Map<String, dynamic> m) => Registro(
    id: m['id'] as int?,
    lugar: m['lugar'] as String,
    categoria: m['categoria'] as String,
    nota: m['nota'] as String,
    calificacion: m['calificacion'] as int,
    latitud: (m['latitud'] as num?)?.toDouble(),
    longitud: (m['longitud'] as num?)?.toDouble(),
    fecha: DateTime.parse(m['fecha'] as String),
    foto: m['foto'] as Uint8List?,
    temperatura: (m['temperatura'] as num?)?.toDouble(),
  );
}
