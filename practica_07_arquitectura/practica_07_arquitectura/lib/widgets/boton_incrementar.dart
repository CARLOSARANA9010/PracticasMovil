import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/contador_provider.dart';

class BotonIncrementar extends StatelessWidget {
  const BotonIncrementar({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Se llama al método incrementar sin escuchar cambios en el botón
        context.read<ContadorProvider>().incrementar();
      },
      tooltip: 'Incrementar',
      child: const Icon(Icons.add),
    );
  }
}
