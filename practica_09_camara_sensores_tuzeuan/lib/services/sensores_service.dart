import 'package:sensors_plus/sensors_plus.dart';

class SensoresService {
  Stream<AccelerometerEvent> obtenerAcelerometro() {
    return accelerometerEventStream();
  }

  Stream<GyroscopeEvent> obtenerGiroscopio() {
    return gyroscopeEventStream();
  }
}
