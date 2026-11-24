class Incidencia {
  final String id;
  final String titulo;
  final String descripcion;
  final String categoria;
  final String? fotoPath;
  final double? latitud;
  final double? longitud;
  final String fechaHora;

  const Incidencia({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.categoria,
    this.fotoPath,
    this.latitud,
    this.longitud,
    required this.fechaHora,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'categoria': categoria,
      'fotoPath': fotoPath,
      'latitud': latitud,
      'longitud': longitud,
      'fechaHora': fechaHora,
    };
  }

  factory Incidencia.fromJson(Map<String, dynamic> json) {
    return Incidencia(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      descripcion: json['descripcion'] as String,
      categoria: json['categoria'] as String,
      fotoPath: json['fotoPath'] as String?,
      latitud: (json['latitud'] as num?)?.toDouble(),
      longitud: (json['longitud'] as num?)?.toDouble(),
      fechaHora: json['fechaHora'] as String,
    );
  }
}
