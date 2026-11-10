import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/registros_provider.dart';
import '../widgets/estado_vista.dart';
import '../widgets/registro_card.dart';
import 'detalle_screen.dart';
import 'nuevo_registro_screen.dart';

/// Lista de visitas guardadas. Funciona sin conexión (lee de SQLite).
class RegistrosScreen extends StatelessWidget {
  const RegistrosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<RegistrosProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Explora Campeche')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (_) => const NuevoRegistroScreen()),
        ),
        icon: const Icon(Icons.add_location_alt),
        label: const Text('Nueva visita'),
      ),
      body: switch (p.estado) {
        EstadoLista.inicial ||
        EstadoLista.cargando => const EstadoVista.cargando(),
        EstadoLista.error => EstadoVista.error(
          mensaje: p.error ?? 'Error desconocido',
          onReintentar: () => context.read<RegistrosProvider>().cargar(),
        ),
        EstadoLista.listo =>
          p.registros.isEmpty
              ? const EstadoVista.vacio(
                  mensaje:
                      'Aún no has registrado visitas.\nToca "Nueva visita".',
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 88),
                  itemCount: p.registros.length,
                  itemBuilder: (context, i) {
                    final r = p.registros[i];
                    return RegistroCard(
                      registro: r,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => DetalleScreen(registro: r),
                        ),
                      ),
                    );
                  },
                ),
      },
    );
  }
}
