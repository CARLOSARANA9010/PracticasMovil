class Nota {
  final int? id;
  final String titulo;
  final String contenido;
  final bool completada;
  final bool pendienteSincronizar;

  Nota({
    this.id,
    required this.titulo,
    required this.contenido,
    this.completada = false,
    this.pendienteSincronizar = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'contenido': contenido,
      'completada': completada ? 1 : 0,
      'pendiente_sincronizar': pendienteSincronizar ? 1 : 0,
    };
  }

  factory Nota.fromMap(Map<String, dynamic> map) {
    return Nota(
      id: map['id'] as int?,
      titulo: map['titulo'] as String,
      contenido: map['contenido'] as String,
      completada: (map['completada'] as int? ?? 0) == 1,
      pendienteSincronizar: (map['pendiente_sincronizar'] as int? ?? 1) == 1,
    );
  }
}
