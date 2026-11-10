import 'dart:typed_data';

import 'package:intl/intl.dart';

import 'lectura_sensor.dart';

/// Una entrada de la bitácora de inspección: foto + fecha + lecturas.
class RegistroInspeccion {
  final Uint8List foto;
  final DateTime fecha;
  final LecturaSensor acelerometro;
  final LecturaSensor giroscopio;

  const RegistroInspeccion({
    required this.foto,
    required this.fecha,
    required this.acelerometro,
    required this.giroscopio,
  });

  static final DateFormat _formato = DateFormat('dd/MM/yyyy HH:mm:ss');

  String get fechaFormateada => _formato.format(fecha);
}
