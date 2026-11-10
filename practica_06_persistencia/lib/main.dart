import 'package:flutter/material.dart';

import 'screens/tareas_page.dart';

void main() => runApp(
  MaterialApp(
    title: 'Práctica 06 Persistencia',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(colorSchemeSeed: Colors.teal),
    home: const TareasPage(),
  ),
);
