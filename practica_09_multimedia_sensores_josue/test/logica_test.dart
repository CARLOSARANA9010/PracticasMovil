import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:practica_09_multimedia_sensores_josue/models/lectura_sensor.dart';
import 'package:practica_09_multimedia_sensores_josue/models/registro_inspeccion.dart';
import 'package:practica_09_multimedia_sensores_josue/services/monitor_sensores.dart';

void main() {
  group('LecturaSensor', () {
    test('formatea los ejes con 2 decimales', () {
      const l = LecturaSensor(1.234, -0.5, 9.81);
      expect(l.textoX, 'X: 1.23');
      expect(l.textoY, 'Y: -0.50');
      expect(l.textoZ, 'Z: 9.81');
      expect(l.resumen, '1.23 / -0.50 / 9.81');
    });
  });

  group('RegistroInspeccion', () {
    test('da formato dd/MM/yyyy HH:mm:ss a la fecha', () {
      final r = RegistroInspeccion(
        foto: Uint8List(0),
        fecha: DateTime(2026, 11, 9, 8, 5, 3),
        acelerometro: LecturaSensor.cero,
        giroscopio: LecturaSensor.cero,
      );
      expect(r.fechaFormateada, '09/11/2026 08:05:03');
    });
  });

  group('MonitorSensores', () {
    test('publica las lecturas que llegan del flujo', () async {
      final acel = StreamController<LecturaSensor>();
      final giro = StreamController<LecturaSensor>();
      final m = MonitorSensores(
        acelerometro: () => acel.stream,
        giroscopio: () => giro.stream,
      )..iniciar();

      acel.add(const LecturaSensor(1, 2, 3));
      giro.add(const LecturaSensor(4, 5, 6));
      await Future<void>.delayed(Duration.zero);

      expect(m.acelerometro.value?.y, 2);
      expect(m.giroscopio.value?.z, 6);
      expect(m.errorAcelerometro.value, isNull);

      m.dispose();
      acel.close();
      giro.close();
    });

    test('un error del flujo se convierte en mensaje, sin lanzar', () async {
      final acel = StreamController<LecturaSensor>();
      final giro = StreamController<LecturaSensor>();
      final m = MonitorSensores(
        acelerometro: () => acel.stream,
        giroscopio: () => giro.stream,
      )..iniciar();

      acel.addError(Exception('sin sensor'));
      await Future<void>.delayed(Duration.zero);

      expect(m.errorAcelerometro.value, isNotNull);
      expect(m.errorGiroscopio.value, isNull);

      m.dispose();
      acel.close();
      giro.close();
    });

    test('si no llegan datos avisa tras el tiempo de espera', () async {
      final m = MonitorSensores(
        acelerometro: () => const Stream<LecturaSensor>.empty(),
        giroscopio: () => const Stream<LecturaSensor>.empty(),
        tiempoSinDatos: const Duration(milliseconds: 20),
      )..iniciar();

      await Future<void>.delayed(const Duration(milliseconds: 60));
      expect(m.errorAcelerometro.value, 'Sin datos del acelerómetro');
      expect(m.errorGiroscopio.value, 'Sin datos del giroscopio');
      m.dispose();
    });
  });
}
