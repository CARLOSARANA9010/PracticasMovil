import 'package:flutter/material.dart';

import '../models/registro_inspeccion.dart';

/// Tarjeta de evidencia: foto, fecha/hora y valores de los sensores.
class TarjetaEvidencia extends StatelessWidget {
  final RegistroInspeccion registro;
  final VoidCallback onEliminar;

  const TarjetaEvidencia({
    super.key,
    required this.registro,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.memory(
            registro.foto,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 18),
                    const SizedBox(width: 6),
                    Expanded(child: Text(registro.fechaFormateada)),
                    IconButton(
                      tooltip: 'Eliminar',
                      onPressed: onEliminar,
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ),
                Text('Acelerómetro (X/Y/Z): ${registro.acelerometro.resumen}'),
                Text('Giroscopio (X/Y/Z): ${registro.giroscopio.resumen}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
