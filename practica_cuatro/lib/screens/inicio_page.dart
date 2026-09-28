import 'package:flutter/material.dart';
import '../models/materia.dart';
import '../widgets/materia_card.dart';
import 'detalle_page.dart';

class InicioPage extends StatelessWidget {
  const InicioPage({super.key});

  static const materias = [
    Materia(
      'Programación Móvil',
      7,
      5,
      'Desarrollo de apps con Flutter y Dart.',
    ),
    Materia(
      'Redes de Computadoras',
      6,
      4,
      'Clases de IP, subredes y enrutamiento.',
    ),
    Materia('Bases de Datos', 5, 5, 'Modelado, normalización y consultas SQL.'),
    Materia(
      'Ingeniería de Software',
      6,
      4,
      'Metodologías ágiles y diseño de sistemas.',
    ),
    Materia(
      'Sistemas Operativos',
      4,
      4,
      'Gestión de memoria, procesos y hardware.',
    ),
    Materia(
      'Desarrollo Web',
      7,
      5,
      'Creación de interfaces y consumo de APIs.',
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Catálogo de Materias')),
    body: ListView(
      padding: const EdgeInsets.all(12),
      children: materias
          .map(
            (m) => MateriaCard(
              materia: m,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DetallePage(materia: m)),
              ),
            ),
          )
          .toList(),
    ),
  );
}
