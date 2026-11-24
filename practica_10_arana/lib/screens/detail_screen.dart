import 'dart:io';
import 'package:flutter/material.dart';
import '../models/incidencia.dart';
import '../services/storage_service.dart';

class DetailScreen extends StatelessWidget {
  final Incidencia incidencia;

  const DetailScreen({super.key, required this.incidencia});

  Future<void> _eliminar(BuildContext context) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar reporte'),
        content: const Text(
          '¿Deseas eliminar este reporte guardado localmente?',
        ),
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

    if (confirmar == true) {
      await StorageService().eliminarReporte(incidencia.id);
      if (context.mounted) Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool tieneFoto =
        incidencia.fotoPath != null && File(incidencia.fotoPath!).existsSync();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Incidencia'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Eliminar reporte',
            onPressed: () => _eliminar(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (tieneFoto)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(incidencia.fotoPath!),
                  width: double.infinity,
                  height: 230,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_not_supported_outlined, size: 42),
                    SizedBox(height: 6),
                    Text('Sin evidencia fotográfica adjunta'),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            Chip(label: Text(incidencia.categoria)),
            const SizedBox(height: 8),
            Text(
              incidencia.titulo,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              incidencia.descripcion,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Divider(height: 32),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: const Text('Fecha y hora del reporte'),
              subtitle: Text(incidencia.fechaHora),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.location_pin),
              title: const Text('Ubicación geográfica'),
              subtitle: Text(
                (incidencia.latitud != null && incidencia.longitud != null)
                    ? 'Latitud: ${incidencia.latitud}\nLongitud: ${incidencia.longitud}'
                    : 'No registrada',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
