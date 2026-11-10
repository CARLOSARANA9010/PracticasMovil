import 'package:flutter/material.dart';

import '../services/camara_service.dart';
import '../services/monitor_sensores.dart';
import '../widgets/lectura_card.dart';

/// Ejemplo guiado del manual: foto + acelerómetro (+ giroscopio como ampliación).
class EjemploGuiadoScreen extends StatefulWidget {
  final MonitorSensores monitor;
  final CamaraService camara;

  const EjemploGuiadoScreen({
    super.key,
    required this.monitor,
    required this.camara,
  });

  @override
  State<EjemploGuiadoScreen> createState() => _EjemploGuiadoScreenState();
}

class _EjemploGuiadoScreenState extends State<EjemploGuiadoScreen> {
  ResultadoFoto? _ultima;
  bool _ocupado = false;

  Future<void> _tomarFoto() async {
    setState(() => _ocupado = true);
    final r = await widget.camara.tomarFoto();
    if (!mounted) return;
    setState(() {
      _ocupado = false;
      if (r.estado == EstadoCamara.ok) _ultima = r;
    });
    if (r.estado != EstadoCamara.ok) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(r.mensaje)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bytes = _ultima?.bytes;
    return Scaffold(
      appBar: AppBar(title: const Text('Cámara y acelerómetro')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          FilledButton.icon(
            onPressed: _ocupado ? null : _tomarFoto,
            icon: const Icon(Icons.camera_alt),
            label: const Text('Tomar fotografía'),
          ),
          const SizedBox(height: 12),
          if (bytes != null) Image.memory(bytes, height: 250),
          const Divider(),
          LecturaCard(
            titulo: 'Acelerómetro',
            lectura: widget.monitor.acelerometro,
            error: widget.monitor.errorAcelerometro,
          ),
          LecturaCard(
            titulo: 'Giroscopio',
            lectura: widget.monitor.giroscopio,
            error: widget.monitor.errorGiroscopio,
          ),
        ],
      ),
    );
  }
}
