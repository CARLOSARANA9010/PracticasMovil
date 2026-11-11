import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/contador_provider.dart';
import '../widgets/botones_contador.dart';
import '../widgets/contador_card.dart';
import '../widgets/encabezado.dart';

/// Ejemplo guiado: ChangeNotifierProvider + Consumer + widgets const.
class ContadorScreen extends StatelessWidget {
  const ContadorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contador con Provider')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Encabezado(texto: 'Valor actual'),
            const SizedBox(height: 16),
            // Solo esta tarjeta se reconstruye cuando cambia el contador.
            Consumer<ContadorProvider>(
              builder: (context, contador, child) =>
                  ContadorCard(valor: contador.valor),
            ),
            const SizedBox(height: 24),
            const BotonesContador(),
          ],
        ),
      ),
    );
  }
}
