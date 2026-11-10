import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/lectura_sensor.dart';

/// Escucha dos flujos de sensores sin bloquear la interfaz.
/// Cada lectura vive en un ValueNotifier, así solo se reconstruye el widget
/// que muestra ese valor (no la pantalla completa).
class MonitorSensores {
  MonitorSensores({
    required Stream<LecturaSensor> Function() acelerometro,
    required Stream<LecturaSensor> Function() giroscopio,
    this.tiempoSinDatos = const Duration(seconds: 3),
  }) : _crearAcelerometro = acelerometro,
       _crearGiroscopio = giroscopio;

  final Stream<LecturaSensor> Function() _crearAcelerometro;
  final Stream<LecturaSensor> Function() _crearGiroscopio;
  final Duration tiempoSinDatos;

  final ValueNotifier<LecturaSensor?> acelerometro = ValueNotifier(null);
  final ValueNotifier<LecturaSensor?> giroscopio = ValueNotifier(null);
  final ValueNotifier<String?> errorAcelerometro = ValueNotifier(null);
  final ValueNotifier<String?> errorGiroscopio = ValueNotifier(null);

  StreamSubscription<LecturaSensor>? _subAcel;
  StreamSubscription<LecturaSensor>? _subGiro;
  Timer? _temporizador;

  void iniciar() {
    detener();
    _subAcel = _escuchar(_crearAcelerometro, acelerometro, errorAcelerometro);
    _subGiro = _escuchar(_crearGiroscopio, giroscopio, errorGiroscopio);
    // Si en unos segundos no llega ningún dato, se informa en vez de esperar.
    _temporizador = Timer(tiempoSinDatos, () {
      if (acelerometro.value == null && errorAcelerometro.value == null) {
        errorAcelerometro.value = 'Sin datos del acelerómetro';
      }
      if (giroscopio.value == null && errorGiroscopio.value == null) {
        errorGiroscopio.value = 'Sin datos del giroscopio';
      }
    });
  }

  StreamSubscription<LecturaSensor>? _escuchar(
    Stream<LecturaSensor> Function() crear,
    ValueNotifier<LecturaSensor?> destino,
    ValueNotifier<String?> error,
  ) {
    try {
      return crear().listen(
        (lectura) {
          destino.value = lectura;
          error.value = null;
        },
        onError: (Object e) {
          error.value = 'Sensor no disponible en este dispositivo';
        },
      );
    } catch (_) {
      error.value = 'Sensor no disponible en este dispositivo';
      return null;
    }
  }

  void detener() {
    _temporizador?.cancel();
    _subAcel?.cancel();
    _subGiro?.cancel();
    _temporizador = null;
    _subAcel = null;
    _subGiro = null;
  }

  void dispose() {
    detener();
    acelerometro.dispose();
    giroscopio.dispose();
    errorAcelerometro.dispose();
    errorGiroscopio.dispose();
  }
}
