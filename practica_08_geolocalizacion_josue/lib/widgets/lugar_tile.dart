import 'package:flutter/material.dart';

import '../models/lugar.dart';
import '../utils/formato.dart';

class LugarTile extends StatelessWidget {
  final Lugar lugar;
  final double? distanciaMetros;
  final VoidCallback onMapa;
  final VoidCallback onEliminar;

  const LugarTile({
    super.key,
    required this.lugar,
    required this.distanciaMetros,
    required this.onMapa,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    final d = distanciaMetros;
    return ListTile(
      leading: const Icon(Icons.place),
      title: Text(lugar.nombre),
      subtitle: Text(
        'Lat ${formatearCoordenada(lugar.latitud)}, '
        'Lng ${formatearCoordenada(lugar.longitud)}\n'
        '${d == null ? 'Distancia: ubicación actual no disponible' : 'Distancia: ${formatearDistancia(d)}'}',
      ),
      isThreeLine: true,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'Abrir en mapa',
            onPressed: onMapa,
            icon: const Icon(Icons.map_outlined),
          ),
          IconButton(
            tooltip: 'Eliminar',
            onPressed: onEliminar,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }
}
