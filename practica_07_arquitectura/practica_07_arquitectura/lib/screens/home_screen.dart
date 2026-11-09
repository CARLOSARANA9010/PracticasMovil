import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/contador_provider.dart';
import '../widgets/boton_incrementar.dart';
import '../widgets/tarjeta_registro.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Escucha los cambios del provider
    final provider = context.watch<ContadorProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Práctica 7 - Arquitectura')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Has presionado el botón este número de veces:'),
          ),
          Text(
            '${provider.valor}',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: provider.historial.length,
              itemBuilder: (context, index) {
                return TarjetaRegistro(registro: provider.historial[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: const BotonIncrementar(),
    );
  }
}
