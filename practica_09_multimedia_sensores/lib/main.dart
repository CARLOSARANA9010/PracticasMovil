import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() => runApp(
  const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: BitacoraInspeccionPage(),
  ),
);

class RegistroInspeccion {
  final String rutaFoto;
  final String fechaHora;
  final String acelerometro;
  final String giroscopio;

  RegistroInspeccion({
    required this.rutaFoto,
    required this.fechaHora,
    required this.acelerometro,
    required this.giroscopio,
  });
}

class BitacoraInspeccionPage extends StatefulWidget {
  const BitacoraInspeccionPage({super.key});

  @override
  State<BitacoraInspeccionPage> createState() => _BitacoraInspeccionPageState();
}

class _BitacoraInspeccionPageState extends State<BitacoraInspeccionPage> {
  XFile? fotoActual;
  double ax = 0, ay = 0, az = 0;
  double gx = 0, gy = 0, gz = 0;
  String estadoCamara = 'Listo para capturar evidencia';

  StreamSubscription<AccelerometerEvent>? _accelSub;
  StreamSubscription<GyroscopeEvent>? _gyroSub;

  final List<RegistroInspeccion> bitacora = [];

  @override
  void initState() {
    super.initState();
    _iniciarSensores();
  }

  void _iniciarSensores() {
    try {
      _accelSub = accelerometerEventStream().listen((e) {
        if (mounted) {
          setState(() {
            ax = e.x;
            ay = e.y;
            az = e.z;
          });
        }
      }, onError: (_) {});

      _gyroSub = gyroscopeEventStream().listen((e) {
        if (mounted) {
          setState(() {
            gx = e.x;
            gy = e.y;
            gz = e.z;
          });
        }
      }, onError: (_) {});
    } catch (_) {}
  }

  Future<void> tomarFotoYRegistrar() async {
    try {
      final f = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 75,
      );

      if (f == null) {
        setState(() => estadoCamara = 'Captura cancelada por el usuario');
        return;
      }

      final ahora = DateTime.now();
      final fechaFormateada =
          '${ahora.day.toString().padLeft(2, '0')}/${ahora.month.toString().padLeft(2, '0')}/${ahora.year} '
          '${ahora.hour.toString().padLeft(2, '0')}:${ahora.minute.toString().padLeft(2, '0')}:${ahora.second.toString().padLeft(2, '0')}';

      setState(() {
        fotoActual = f;
        estadoCamara = 'Evidencia capturada correctamente';
        bitacora.insert(
          0,
          RegistroInspeccion(
            rutaFoto: f.path,
            fechaHora: fechaFormateada,
            acelerometro:
                'X:${ax.toStringAsFixed(2)}, Y:${ay.toStringAsFixed(2)}, Z:${az.toStringAsFixed(2)}',
            giroscopio:
                'X:${gx.toStringAsFixed(2)}, Y:${gy.toStringAsFixed(2)}, Z:${gz.toStringAsFixed(2)}',
          ),
        );
      });
    } catch (e) {
      setState(() => estadoCamara = 'Error o permiso de cámara denegado');
    }
  }

  @override
  void dispose() {
    _accelSub?.cancel();
    _gyroSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bitácora de Inspección')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Lectura de Sensores en Tiempo Real',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Acelerómetro: X=${ax.toStringAsFixed(2)} | Y=${ay.toStringAsFixed(2)} | Z=${az.toStringAsFixed(2)}',
                  ),
                  Text(
                    'Giroscopio: X=${gx.toStringAsFixed(2)} | Y=${gy.toStringAsFixed(2)} | Z=${gz.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: tomarFotoYRegistrar,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Capturar Fotografía de Inspección'),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    estadoCamara,
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Tarjetas de Evidencia Registradas',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          if (bitacora.isEmpty)
            const Text(
              'Aún no hay inspecciones registradas. Toma una foto para comenzar.',
            )
          else
            ...bitacora.map(
              (item) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!kIsWeb)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(item.rutaFoto),
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        'Fecha y hora: ${item.fechaHora}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('Acelerómetro: ${item.acelerometro}'),
                      Text('Giroscopio: ${item.giroscopio}'),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
