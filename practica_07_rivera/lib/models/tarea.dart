/// Modelo inmutable: solo datos y conversión JSON, sin lógica de UI ni de almacenamiento.
class Tarea {
  const Tarea({
    required this.id,
    required this.titulo,
    required this.creada,
    this.completada = false,
  });

  final int id;
  final String titulo;
  final DateTime creada;
  final bool completada;

  Tarea copyWith({String? titulo, bool? completada}) => Tarea(
    id: id,
    titulo: titulo ?? this.titulo,
    creada: creada,
    completada: completada ?? this.completada,
  );

  factory Tarea.fromJson(Map<String, dynamic> json) => Tarea(
    id: json['id'] as int,
    titulo: json['titulo'] as String,
    creada: DateTime.parse(json['creada'] as String),
    completada: json['completada'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'titulo': titulo,
    'creada': creada.toIso8601String(),
    'completada': completada,
  };
}

enum Filtro { todas, pendientes, completadas }
