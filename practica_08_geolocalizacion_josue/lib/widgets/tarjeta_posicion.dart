import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../services/ubicacion_service.dart';
import '../utils/formato.dart';

/// Muestra la posición actual, su precisión o el motivo por el que no existe.
class TarjetaPosicion extends StatelessWidget {
  final Position? posicion;
  final ResultadoUbicacion? resultado;
  final bool cargando;
  final VoidCallback onActualizar;
  final VoidCallback? onAjustes;

  const TarjetaPosicion({
    super.key,
    required this.posicion,
    required this.resultado,
    required this.cargando,
    required this.onActualizar,
    required this.onAjustes,
  });

  @override
  Widget build(BuildContext context) {
    final p = posicion;
    final r = resultado;
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ubicación actual',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (p != null) ...[
              Text(
                'Lat ${formatearCoordenada(p.latitude)}  '
                'Lng ${formatearCoordenada(p.longitude)}',
              ),
              Text('Precisión: ${p.accuracy.toStringAsFixed(1)} m'),
            ] else
              Text(r?.mensaje ?? 'Aún no se ha obtenido la ubicación'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: cargando ? null : onActualizar,
                  icon: cargando
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.my_location),
                  label: const Text('Actualizar'),
                ),
                if (r != null && r.puedeAbrirAjustes)
                  TextButton(
                    onPressed: onAjustes,
                    child: const Text('Abrir ajustes'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
