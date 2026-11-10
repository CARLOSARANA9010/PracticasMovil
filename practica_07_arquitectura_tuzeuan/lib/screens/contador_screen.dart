import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/contador_provider.dart';
import '../widgets/contador_botones.dart';
import '../widgets/contador_tarjeta.dart';

class ContadorScreen extends StatelessWidget {
  const ContadorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contador = context.watch<ContadorProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Práctica 07 - Arquitectura'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Administración de estado con Provider',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              ContadorTarjeta(valor: contador.valor),

              const SizedBox(height: 30),

              ContadorBotones(
                incrementar: contador.incrementar,
                decrementar: contador.decrementar,
                reiniciar: contador.reiniciar,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
