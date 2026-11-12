import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/contador_provider.dart';
import '../widgets/boton_accion.dart';
import '../widgets/encabezado.dart';

/// Ejemplo guiado: StatelessWidget, el estado vive en ContadorProvider.
class ContadorScreen extends StatelessWidget {
  const ContadorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contador (ejemplo guiado)')),
      body: Column(
        children: [
          const Encabezado(
            'Proveedor de estado sencillo',
            subtitulo: 'Solo el número se reconstruye al incrementar.',
          ),
          Expanded(
            child: Center(
              // Consumer limita la reconstrucción a este Text.
              child: Consumer<ContadorProvider>(
                builder: (_, contador, _) => Text(
                  '${contador.valor}',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: BotonAccion(
              icono: Icons.add,
              texto: 'Incrementar',
              // read: el botón no necesita reconstruirse cuando cambia el valor.
              onPressed: context.read<ContadorProvider>().incrementar,
            ),
          ),
        ],
      ),
    );
  }
}
