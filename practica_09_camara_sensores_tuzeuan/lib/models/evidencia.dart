import 'dart:typed_data';

class Evidencia {
  final Uint8List fotografia;
  final DateTime fechaHora;

  final double acelerometroX;
  final double acelerometroY;
  final double acelerometroZ;

  final double giroscopioX;
  final double giroscopioY;
  final double giroscopioZ;

  const Evidencia({
    required this.fotografia,
    required this.fechaHora,
    required this.acelerometroX,
    required this.acelerometroY,
    required this.acelerometroZ,
    required this.giroscopioX,
    required this.giroscopioY,
    required this.giroscopioZ,
  });
}
