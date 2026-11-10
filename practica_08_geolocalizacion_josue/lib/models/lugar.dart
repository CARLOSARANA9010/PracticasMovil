/// Punto de interés guardado por el usuario.
class Lugar {
  final String nombre;
  final double latitud;
  final double longitud;

  const Lugar({
    required this.nombre,
    required this.latitud,
    required this.longitud,
  });

  Map<String, dynamic> toJson() => {
    'nombre': nombre,
    'latitud': latitud,
    'longitud': longitud,
  };

  factory Lugar.fromJson(Map<String, dynamic> j) => Lugar(
    nombre: j['nombre'] as String,
    latitud: (j['latitud'] as num).toDouble(),
    longitud: (j['longitud'] as num).toDouble(),
  );
}
