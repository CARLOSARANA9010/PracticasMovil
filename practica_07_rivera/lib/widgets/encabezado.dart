import 'package:flutter/material.dart';

/// Encabezado reutilizable para secciones (título + subtítulo opcional).
class Encabezado extends StatelessWidget {
  const Encabezado(this.titulo, {super.key, this.subtitulo});

  final String titulo;
  final String? subtitulo;

  @override
  Widget build(BuildContext context) {
    final texto = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: texto.titleLarge),
          if (subtitulo != null) Text(subtitulo!, style: texto.bodyMedium),
        ],
      ),
    );
  }
}
