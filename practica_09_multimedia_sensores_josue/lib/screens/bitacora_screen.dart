import 'package:flutter/material.dart';

import '../models/lectura_sensor.dart';
import '../models/registro_inspeccion.dart';
import '../services/camara_service.dart';
import '../services/monitor_sensores.dart';
import '../widgets/lectura_card.dart';
import '../widgets/tarjeta_evidencia.dart';

/// Ejercicio evaluable: bitácora de inspección.
/// Captura foto, fecha/hora y los valores actuales de acelerómetro y giroscopio.
class BitacoraScreen extends StatefulWidget {
  final MonitorSensores monitor;
  final CamaraService camara;

  const BitacoraScreen({
    super.key,
    required this.monitor,
    required this.camara,
  });

  @override
  State<BitacoraScreen> createState() => _BitacoraScreenState();
}

class _BitacoraScreenState extends State<BitacoraScreen> {
  final List<RegistroInspeccion> _registros = [];
  bool _ocupado = false;

  Future<void> _capturar() async {
    setState(() => _ocupado = true);
    final r = await widget.camara.tomarFoto();
    if (!mounted) return;

    if (r.estado == EstadoCamara.ok && r.bytes != null) {
      // Instantánea de los sensores en el momento de la captura.
      final registro = RegistroInspeccion(
        foto: r.bytes!,
        fecha: DateTime.now(),
        acelerometro: widget.monitor.acelerometro.value ?? LecturaSensor.cero,
        giroscopio: widget.monitor.giroscopio.value ?? LecturaSensor.cero,
      );
      setState(() {
        _registros.insert(0, registro);
        _ocupado = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Evidencia agregada a la bitácora')),
      );
      return;
    }

    setState(() => _ocupado = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(r.mensaje)));
  }

  void _eliminar(int i) => setState(() => _registros.removeAt(i));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bitácora de inspección')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _ocupado ? null : _capturar,
        icon: const Icon(Icons.add_a_photo),
        label: const Text('Capturar evidencia'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          Text(
            'Lecturas en vivo',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          LecturaCard(
            titulo: 'Acelerómetro (m/s²)',
            lectura: widget.monitor.acelerometro,
            error: widget.monitor.errorAcelerometro,
          ),
          LecturaCard(
            titulo: 'Giroscopio (rad/s)',
            lectura: widget.monitor.giroscopio,
            error: widget.monitor.errorGiroscopio,
          ),
          const SizedBox(height: 16),
          Text(
            'Registros (${_registros.length})',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (_registros.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: Text('Aún no hay evidencias capturadas')),
            ),
          for (var i = 0; i < _registros.length; i++)
            TarjetaEvidencia(
              registro: _registros[i],
              onEliminar: () => _eliminar(i),
            ),
        ],
      ),
    );
  }
}
