import 'package:flutter/material.dart';
import '../models/materia.dart';

class DetallePage extends StatelessWidget {
  final Materia materia;

  const DetallePage({super.key, required this.materia});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(materia.nombre)),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.school, size: 100),
          Text(
            materia.nombre,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text('Semestre: ${materia.semestre} | Créditos: ${materia.creditos}'),
          const SizedBox(height: 16),
          Text(materia.descripcion),
        ],
      ),
    ),
  );
}
