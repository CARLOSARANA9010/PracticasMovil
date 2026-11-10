import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/registro.dart';
import '../providers/registros_provider.dart';
import '../services/mapa_service.dart';
import '../utils/formato.dart';
import '../widgets/calificacion_estrellas.dart';

class DetalleScreen extends StatelessWidget {
  final Registro registro;
  const DetalleScreen({super.key, required this.registro});

  Future<void> _eliminar(BuildContext context) async {
    final provider = context.read<RegistrosProvider>();
    final navigator = Navigator.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar visita'),
        content: Text('¿Eliminar "${registro.lugar}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (ok != true || registro.id == null) return;
    await provider.eliminar(registro.id!);
    navigator.pop();
  }

  Future<void> _abrirMapa(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final ok = await MapaService.abrir(registro.latitud!, registro.longitud!);
    if (!ok) {
      messenger.showSnackBar(
        const SnackBar(content: Text('No se pudo abrir el mapa')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final foto = registro.foto;
    final temp = registro.temperatura;
    return Scaffold(
      appBar: AppBar(
        title: Text(registro.lugar),
        actions: [
          IconButton(
            tooltip: 'Eliminar',
            onPressed: () => _eliminar(context),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (foto != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(foto, height: 240, fit: BoxFit.cover),
            ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Chip(label: Text(registro.categoria)),
              CalificacionEstrellas(valor: registro.calificacion),
            ],
          ),
          const SizedBox(height: 8),
          Text(registro.nota, style: Theme.of(context).textTheme.bodyLarge),
          const Divider(height: 32),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: Text(formatearFecha(registro.fecha)),
            subtitle: const Text('Fecha y hora del registro'),
          ),
          if (temp != null)
            ListTile(
              leading: const Icon(Icons.thermostat),
              title: Text(formatearTemperatura(temp)),
              subtitle: const Text('Temperatura al momento de la visita'),
            ),
          if (registro.tieneUbicacion) ...[
            ListTile(
              leading: const Icon(Icons.place),
              title: Text(
                '${formatearCoordenada(registro.latitud!)}, '
                '${formatearCoordenada(registro.longitud!)}',
              ),
              subtitle: const Text('Coordenadas GPS'),
            ),
            OutlinedButton.icon(
              onPressed: () => _abrirMapa(context),
              icon: const Icon(Icons.map_outlined),
              label: const Text('Abrir en mapa'),
            ),
          ],
        ],
      ),
    );
  }
}
