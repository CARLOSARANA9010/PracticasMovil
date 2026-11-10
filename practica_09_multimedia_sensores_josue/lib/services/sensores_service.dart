import 'package:sensors_plus/sensors_plus.dart';

import '../models/lectura_sensor.dart';

/// Envoltura de sensors_plus: si la API del paquete cambia, solo se edita aquí.
class SensoresService {
  Stream<LecturaSensor> acelerometro() =>
      accelerometerEventStream(samplingPeriod: SensorInterval.normalInterval)
          .map((e) => LecturaSensor(e.x, e.y, e.z));

  Stream<LecturaSensor> giroscopio() =>
      gyroscopeEventStream(samplingPeriod: SensorInterval.normalInterval)
          .map((e) => LecturaSensor(e.x, e.y, e.z));
}
