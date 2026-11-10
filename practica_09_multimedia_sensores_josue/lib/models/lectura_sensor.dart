/// Tres ejes de un sensor de movimiento (acelerómetro o giroscopio).
class LecturaSensor {
  final double x;
  final double y;
  final double z;

  const LecturaSensor(this.x, this.y, this.z);

  static const LecturaSensor cero = LecturaSensor(0, 0, 0);

  String get textoX => 'X: ${x.toStringAsFixed(2)}';
  String get textoY => 'Y: ${y.toStringAsFixed(2)}';
  String get textoZ => 'Z: ${z.toStringAsFixed(2)}';

  /// Resumen en una línea para tarjetas y bitácoras.
  String get resumen =>
      '${x.toStringAsFixed(2)} / ${y.toStringAsFixed(2)} / ${z.toStringAsFixed(2)}';
}
