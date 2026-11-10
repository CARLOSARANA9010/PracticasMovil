import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/ubicacion_service.dart';

class UbicacionPage extends StatefulWidget {
  const UbicacionPage({super.key});

  @override
  State<UbicacionPage> createState() => _UbicacionPageState();
}

class _UbicacionPageState extends State<UbicacionPage> {
  final UbicacionService _ubicacionService = UbicacionService();

  Position? posicion;
  String mensaje = 'Sin ubicación';
  bool cargando = false;

  Future<void> obtener() async {
    setState(() {
      cargando = true;
      mensaje = 'Obteniendo ubicación...';
    });

    try {
      final nuevaPosicion = await _ubicacionService.obtenerUbicacion();

      if (!mounted) return;

      setState(() {
        posicion = nuevaPosicion;
        mensaje = 'Ubicación obtenida correctamente';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        mensaje = e.toString().replaceFirst('Exception: ', '');
        posicion = null;
      });
    } finally {
      if (mounted) {
        setState(() {
          cargando = false;
        });
      }
    }
  }

  Future<void> abrirMapa() async {
    if (posicion == null) return;

    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1'
      '&query=${posicion!.latitude},${posicion!.longitude}',
    );

    try {
      final abierto = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!abierto && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir Google Maps.')),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ocurrió un error al abrir el mapa.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi ubicación'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, size: 80, color: Colors.red),

              const SizedBox(height: 16),

              Text(
                mensaje,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 17),
              ),

              const SizedBox(height: 24),

              if (cargando) const CircularProgressIndicator(),

              if (posicion != null) ...[
                Text('Latitud: ${posicion!.latitude}'),
                Text('Longitud: ${posicion!.longitude}'),
                Text('Precisión: ${posicion!.accuracy} m'),
              ],

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: cargando ? null : obtener,
                  child: const Text('Obtener ubicación'),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: posicion == null ? null : abrirMapa,
                  child: const Text('Abrir en mapa'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
