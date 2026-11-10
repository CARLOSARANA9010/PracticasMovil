import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/clima_provider.dart';
import '../services/ubicacion_service.dart';
import '../utils/formato.dart';
import '../widgets/estado_vista.dart';

/// Sección adicional que consume la API REST (JSON) de Open-Meteo.
class ClimaScreen extends StatefulWidget {
  const ClimaScreen({super.key});

  @override
  State<ClimaScreen> createState() => _ClimaScreenState();
}

class _ClimaScreenState extends State<ClimaScreen> {
  // Coordenadas de San Francisco de Campeche (punto de partida por defecto).
  static const double _latCampeche = 19.8301;
  static const double _lngCampeche = -90.5349;

  final _ubicacion = UbicacionService();
  bool _buscando = false;
  String? _avisoUbicacion;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ClimaProvider>().cargar(
          _latCampeche,
          _lngCampeche,
          etiqueta: 'San Francisco de Campeche',
        );
      }
    });
  }

  Future<void> _usarMiUbicacion() async {
    final provider = context.read<ClimaProvider>();
    setState(() {
      _buscando = true;
      _avisoUbicacion = null;
    });
    final r = await _ubicacion.obtenerActual();
    if (!mounted) return;
    setState(() => _buscando = false);
    if (r.exito) {
      await provider.cargar(
        r.posicion!.latitude,
        r.posicion!.longitude,
        etiqueta: 'Tu ubicación actual',
      );
    } else {
      setState(() => _avisoUbicacion = r.mensaje);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ClimaProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Clima actual')),
      body: switch (p.estado) {
        EstadoClima.inicial ||
        EstadoClima.cargando => const EstadoVista.cargando(),
        EstadoClima.error => EstadoVista.error(
          mensaje: p.error ?? 'Error desconocido',
          onReintentar: () => context.read<ClimaProvider>().reintentar(),
        ),
        EstadoClima.listo => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(p.etiqueta, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      formatearTemperatura(p.clima!.temperatura),
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    Text(p.clima!.descripcion),
                    const SizedBox(height: 8),
                    Text('Viento: ${p.clima!.viento.toStringAsFixed(1)} km/h'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _buscando ? null : _usarMiUbicacion,
              icon: const Icon(Icons.my_location),
              label: const Text('Usar mi ubicación'),
            ),
            if (_avisoUbicacion != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _avisoUbicacion!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
          ],
        ),
      },
    );
  }
}
