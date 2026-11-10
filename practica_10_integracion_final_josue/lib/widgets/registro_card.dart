import 'package:flutter/material.dart';

import '../models/registro.dart';
import '../utils/formato.dart';
import 'calificacion_estrellas.dart';

class RegistroCard extends StatelessWidget {
  final Registro registro;
  final VoidCallback onTap;

  const RegistroCard({super.key, required this.registro, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final foto = registro.foto;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            if (foto != null)
              Image.memory(foto, width: 96, height: 96, fit: BoxFit.cover)
            else
              const SizedBox(
                width: 96,
                height: 96,
                child: Icon(Icons.image_not_supported_outlined),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      registro.lugar,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(registro.categoria),
                    CalificacionEstrellas(valor: registro.calificacion),
                    Text(
                      formatearFecha(registro.fecha),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
