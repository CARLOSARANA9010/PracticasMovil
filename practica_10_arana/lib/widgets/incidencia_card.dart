import 'dart:io';
import 'package:flutter/material.dart';
import '../models/incidencia.dart';

class IncidenciaCard extends StatelessWidget {
  final Incidencia incidencia;
  final VoidCallback onTap;

  const IncidenciaCard({
    super.key,
    required this.incidencia,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool tieneFoto =
        incidencia.fotoPath != null && File(incidencia.fotoPath!).existsSync();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: tieneFoto
              ? Image.file(
                  File(incidencia.fotoPath!),
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                )
              : Container(
                  width: 56,
                  height: 56,
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: const Icon(Icons.report_problem_outlined),
                ),
        ),
        title: Text(
          incidencia.titulo,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('${incidencia.categoria} • ${incidencia.fechaHora}'),
            if (incidencia.latitud != null && incidencia.longitud != null)
              Text(
                'GPS: ${incidencia.latitud!.toStringAsFixed(4)}, '
                '${incidencia.longitud!.toStringAsFixed(4)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
