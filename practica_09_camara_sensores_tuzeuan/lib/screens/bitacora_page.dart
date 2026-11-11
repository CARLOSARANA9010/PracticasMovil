import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../models/evidencia.dart';
import '../services/camara_service.dart';
import '../services/sensores_service.dart';

class BitacoraPage extends StatefulWidget {
  const BitacoraPage({super.key});

  @override
  State<BitacoraPage> createState() => _BitacoraPageState();
}

class _BitacoraPageState extends State<BitacoraPage> {
  final CamaraService _camaraService = CamaraService();
  final SensoresService _sensoresService = SensoresService();

  StreamSubscription<AccelerometerEvent>? _acelerometroSubscription;
  StreamSubscription<GyroscopeEvent>? _giroscopioSubscription;

  Uint8List? _fotografia;

  double _acelerometroX = 0;
  double _acelerometroY = 0;
  double _acelerometroZ = 0;

  double _giroscopioX = 0;
  double _giroscopioY = 0;
  double _giroscopioZ = 0;

  bool _cargandoCamara = false;

  final List<Evidencia> _evidencias = [];

  @override
  void initState() {
    super.initState();
    _iniciarSensores();
  }

  void _iniciarSensores() {
    _acelerometroSubscription = _sensoresService.obtenerAcelerometro().listen(
      (evento) {
        if (!mounted) return;

        setState(() {
          _acelerometroX = evento.x;
          _acelerometroY = evento.y;
          _acelerometroZ = evento.z;
        });
      },
      onError: (error) {
        debugPrint('Error en acelerómetro: $error');
      },
    );

    _giroscopioSubscription = _sensoresService.obtenerGiroscopio().listen(
      (evento) {
        if (!mounted) return;

        setState(() {
          _giroscopioX = evento.x;
          _giroscopioY = evento.y;
          _giroscopioZ = evento.z;
        });
      },
      onError: (error) {
        debugPrint('Error en giroscopio: $error');
      },
    );
  }

  Future<void> _tomarFotografia() async {
    if (_cargandoCamara) return;

    setState(() {
      _cargandoCamara = true;
    });

    try {
      final XFile? archivo = await _camaraService.tomarFotografia();

      if (!mounted) return;

      if (archivo == null) {
        _mostrarMensaje('Captura cancelada. No se guardó ninguna fotografía.');
        return;
      }

      final bytes = await archivo.readAsBytes();

      if (!mounted) return;

      setState(() {
        _fotografia = bytes;
      });

      _mostrarMensaje('Fotografía capturada correctamente.');
    } catch (error) {
      if (!mounted) return;

      _mostrarMensaje(
        'No fue posible acceder a la cámara. '
        'Revisa los permisos del dispositivo.',
      );

      debugPrint('Error al tomar fotografía: $error');
    } finally {
      if (mounted) {
        setState(() {
          _cargandoCamara = false;
        });
      }
    }
  }

  void _guardarEvidencia() {
    if (_fotografia == null) {
      _mostrarMensaje('Primero debes tomar una fotografía.');
      return;
    }

    final evidencia = Evidencia(
      fotografia: _fotografia!,
      fechaHora: DateTime.now(),
      acelerometroX: _acelerometroX,
      acelerometroY: _acelerometroY,
      acelerometroZ: _acelerometroZ,
      giroscopioX: _giroscopioX,
      giroscopioY: _giroscopioY,
      giroscopioZ: _giroscopioZ,
    );

    setState(() {
      _evidencias.insert(0, evidencia);
      _fotografia = null;
    });

    _mostrarMensaje('Evidencia guardada correctamente.');
  }

  void _eliminarEvidencia(int indice) {
    setState(() {
      _evidencias.removeAt(indice);
    });

    _mostrarMensaje('Evidencia eliminada.');
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
  }

  String _formatearFecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    final anio = fecha.year;

    final hora = fecha.hour.toString().padLeft(2, '0');
    final minuto = fecha.minute.toString().padLeft(2, '0');
    final segundo = fecha.second.toString().padLeft(2, '0');

    return '$dia/$mes/$anio - $hora:$minuto:$segundo';
  }

  Widget _construirValorSensor(String nombre, double valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(nombre),
          Text(
            valor.toStringAsFixed(2),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _construirTarjetaSensor({
    required String titulo,
    required IconData icono,
    required Color color,
    required double x,
    required double y,
    required double z,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icono, color: color),
                const SizedBox(width: 8),
                Text(titulo, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const Divider(),
            _construirValorSensor('Eje X', x),
            _construirValorSensor('Eje Y', y),
            _construirValorSensor('Eje Z', z),
          ],
        ),
      ),
    );
  }

  Widget _construirEvidencia(Evidencia evidencia, int indice) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.assignment, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Inspección ${_evidencias.length - indice}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: 'Eliminar evidencia',
                  onPressed: () => _eliminarEvidencia(indice),
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(
                evidencia.fotografia,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            Text('Fecha y hora: ${_formatearFecha(evidencia.fechaHora)}'),
            const SizedBox(height: 12),
            const Text(
              'Acelerómetro',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            _construirValorSensor('X', evidencia.acelerometroX),
            _construirValorSensor('Y', evidencia.acelerometroY),
            _construirValorSensor('Z', evidencia.acelerometroZ),
            const Divider(),
            const Text(
              'Giroscopio',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            _construirValorSensor('X', evidencia.giroscopioX),
            _construirValorSensor('Y', evidencia.giroscopioY),
            _construirValorSensor('Z', evidencia.giroscopioZ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _acelerometroSubscription?.cancel();
    _giroscopioSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bitácora de inspección'),
        centerTitle: true,
      ),
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
                    'Captura de fotografía',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  if (_fotografia != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        _fotografia!,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    Container(
                      height: 160,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            size: 48,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          Text('No hay fotografías capturadas'),
                        ],
                      ),
                    ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _cargandoCamara ? null : _tomarFotografia,
                      icon: const Icon(Icons.camera_alt),
                      label: Text(
                        _cargandoCamara
                            ? 'Abriendo cámara...'
                            : 'Tomar fotografía',
                      ),
                    ),
                  ),
                  if (_fotografia != null) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _guardarEvidencia,
                        icon: const Icon(Icons.save),
                        label: const Text('Guardar evidencia'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Lectura de sensores en tiempo real',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          _construirTarjetaSensor(
            titulo: 'Acelerómetro',
            icono: Icons.speed,
            color: Colors.blue,
            x: _acelerometroX,
            y: _acelerometroY,
            z: _acelerometroZ,
          ),
          _construirTarjetaSensor(
            titulo: 'Giroscopio',
            icono: Icons.screen_rotation,
            color: Colors.deepPurple,
            x: _giroscopioX,
            y: _giroscopioY,
            z: _giroscopioZ,
          ),
          const SizedBox(height: 16),
          Text(
            'Bitácora de evidencias',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          if (_evidencias.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Text('Todavía no hay evidencias registradas.'),
                ),
              ),
            )
          else
            ..._evidencias.asMap().entries.map(
              (entrada) => _construirEvidencia(entrada.value, entrada.key),
            ),
        ],
      ),
    );
  }
}
