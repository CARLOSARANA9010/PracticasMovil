import 'package:flutter/material.dart';
import '../models/materia.dart';

class MateriaCard extends StatelessWidget {
  final Materia materia;
  final VoidCallback onTap;

  const MateriaCard({super.key, required this.materia, required this.onTap});

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: const Icon(Icons.book),
      title: Text(materia.nombre),
      subtitle: Text(
        'Semestre: ${materia.semestre} | Créditos: ${materia.creditos}',
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    ),
  );
}
