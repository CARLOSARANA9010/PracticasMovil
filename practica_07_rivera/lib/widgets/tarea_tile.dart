import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/tarea.dart';

/// Tarjeta de una tarea. No conoce Provider: recibe datos y callbacks,
/// así se puede reutilizar y probar de forma aislada.
class TareaTile extends StatelessWidget {
  const TareaTile({
    super.key,
    required this.tarea,
    required this.onMarcar,
    required this.onEditar,
    required this.onEliminar,
  });

  // Se crea una sola vez, no en cada build().
  static final _fecha = DateFormat('dd/MM/yyyy HH:mm');

  final Tarea tarea;
  final ValueChanged<bool> onMarcar;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        value: tarea.completada,
        onChanged: (v) => onMarcar(v ?? false),
        title: Text(
          tarea.titulo,
          style: tarea.completada
              ? const TextStyle(decoration: TextDecoration.lineThrough)
              : null,
        ),
        subtitle: Text('Creada: ${_fecha.format(tarea.creada)}'),
        secondary: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Editar',
              icon: const Icon(Icons.edit),
              onPressed: onEditar,
            ),
            IconButton(
              tooltip: 'Eliminar',
              icon: const Icon(Icons.delete),
              onPressed: onEliminar,
            ),
          ],
        ),
      ),
    );
  }
}
