class Tarea {
  final int? id;
  final String titulo;
  final String descripcion;
  final bool completada;
  final bool pendienteSincronizar;

  const Tarea({
    this.id,
    required this.titulo,
    this.descripcion = '',
    this.completada = false,
    this.pendienteSincronizar = true,
  });

  Tarea copyWith({
    String? titulo,
    String? descripcion,
    bool? completada,
    bool? pendienteSincronizar,
  }) => Tarea(
    id: id,
    titulo: titulo ?? this.titulo,
    descripcion: descripcion ?? this.descripcion,
    completada: completada ?? this.completada,
    pendienteSincronizar: pendienteSincronizar ?? this.pendienteSincronizar,
  );

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'titulo': titulo,
    'descripcion': descripcion,
    'completada': completada ? 1 : 0,
    'pendiente_sincronizar': pendienteSincronizar ? 1 : 0,
  };

  factory Tarea.fromMap(Map<String, dynamic> m) => Tarea(
    id: m['id'] as int?,
    titulo: m['titulo'] as String,
    descripcion: (m['descripcion'] as String?) ?? '',
    completada: (m['completada'] as int) == 1,
    pendienteSincronizar: (m['pendiente_sincronizar'] as int) == 1,
  );
}
