/// Punto de interés guardado por el usuario.
class Punto {
  const Punto({required this.nombre, required this.lat, required this.lon});

  final String nombre;
  final double lat;
  final double lon;

  Map<String, dynamic> toJson() => {'nombre': nombre, 'lat': lat, 'lon': lon};

  factory Punto.fromJson(Map<String, dynamic> j) => Punto(
    nombre: j['nombre'] as String,
    lat: (j['lat'] as num).toDouble(),
    lon: (j['lon'] as num).toDouble(),
  );
}
