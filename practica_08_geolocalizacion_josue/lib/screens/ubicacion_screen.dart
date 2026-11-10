import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../services/mapa_service.dart';
import '../services/ubicacion_service.dart';
import '../utils/formato.dart';

/// Ejemplo guiado del manual, con manejo explícito de cada estado de permiso.
class UbicacionScreen extends StatefulWidget {
  const UbicacionScreen({super.key});

  @override
  State<UbicacionScreen> createState() => _UbicacionScreenState();
}

class _UbicacionScreenState extends State<UbicacionScreen> {
  final _servicio = UbicacionService();
  Position? _posicion;
  ResultadoUbicacion? _resultado;
  bool _cargando = false;

  Future<void> _obtener() async {
    setState(() => _cargando = true);
    final r = await _servicio.obtenerActual();
    if (!mounted) return;
    setState(() {
      _cargando = false;
      _resultado = r;
      if (r.exito) _posicion = r.posicion;
    });
  }

  Future<void> _abrirMapa() async {
    final p = _posicion;
    if (p == null) return;
    final ok = await MapaService.abrir(p.latitude, p.longitude);
    if (!ok && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No se pudo abrir el mapa')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = _posicion;
    final r = _resultado;
    return Scaffold(
      appBar: AppBar(title: const Text('Mi ubicación')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, size: 80),
              Text(r?.mensaje ?? 'Sin ubicación'),
              if (p != null) ...[
                const SizedBox(height: 8),
                Text('Latitud: ${formatearCoordenada(p.latitude)}'),
                Text('Longitud: ${formatearCoordenada(p.longitude)}'),
                Text('Precisión: ${p.accuracy.toStringAsFixed(1)} m'),
              ],
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _cargando ? null : _obtener,
                child: _cargando
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Obtener ubicación'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: p == null ? null : _abrirMapa,
                child: const Text('Abrir en mapa'),
              ),
              if (r != null && r.puedeAbrirAjustes) ...[
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => _servicio.abrirAjustes(r.estado),
                  child: const Text('Abrir ajustes'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
