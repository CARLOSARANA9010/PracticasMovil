import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Usa el paquete externo intl para dar formato a la fecha de actualización.
class ActualizacionBanner extends StatelessWidget {
  final DateTime fecha;
  const ActualizacionBanner({super.key, required this.fecha});

  static final DateFormat _formato = DateFormat('dd/MM/yyyy HH:mm:ss');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.secondaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text('Actualizado: ${_formato.format(fecha)}'),
    );
  }
}
