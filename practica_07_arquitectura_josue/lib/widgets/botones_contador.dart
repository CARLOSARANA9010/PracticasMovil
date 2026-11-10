import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/contador_provider.dart';

/// Usa context.read (no watch): los botones no dependen del valor,
/// así que nunca se reconstruyen al cambiar el estado.
class BotonesContador extends StatelessWidget {
  const BotonesContador({super.key});

  @override
  Widget build(BuildContext context) {
    final contador = context.read<ContadorProvider>();
    return Wrap(
      spacing: 12,
      children: [
        IconButton.filledTonal(
          tooltip: 'Disminuir',
          onPressed: contador.decrementar,
          icon: const Icon(Icons.remove),
        ),
        IconButton.filled(
          tooltip: 'Aumentar',
          onPressed: contador.incrementar,
          icon: const Icon(Icons.add),
        ),
        IconButton.outlined(
          tooltip: 'Reiniciar',
          onPressed: contador.reiniciar,
          icon: const Icon(Icons.restart_alt),
        ),
      ],
    );
  }
}
