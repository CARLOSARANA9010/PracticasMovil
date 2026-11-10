import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/lectura_sensor.dart';

/// Muestra una lectura en vivo. Solo este widget se reconstruye cuando el
/// sensor emite datos (ValueListenableBuilder), no la pantalla completa.
class LecturaCard extends StatelessWidget {
  final String titulo;
  final ValueListenable<LecturaSensor?> lectura;
  final ValueListenable<String?> error;

  const LecturaCard({
    super.key,
    required this.titulo,
    required this.lectura,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            ValueListenableBuilder<String?>(
              valueListenable: error,
              builder: (context, mensajeError, child) {
                if (mensajeError != null) {
                  return Text(
                    mensajeError,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  );
                }
                return ValueListenableBuilder<LecturaSensor?>(
                  valueListenable: lectura,
                  builder: (context, valor, child) {
                    if (valor == null) return const Text('Esperando datos...');
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(valor.textoX),
                        Text(valor.textoY),
                        Text(valor.textoZ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
