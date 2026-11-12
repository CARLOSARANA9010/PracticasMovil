import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/contador_provider.dart';
import 'providers/tareas_provider.dart';
import 'screens/tareas_screen.dart';
import 'services/tareas_service.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Providers registrados en la raíz: disponibles para todas las pantallas.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ContadorProvider()),
        ChangeNotifierProvider(
          create: (_) => TareasProvider(TareasService())..cargar(),
        ),
      ],
      child: MaterialApp(
        title: 'Práctica 07 Arquitectura',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.indigo),
        home: const TareasScreen(),
      ),
    );
  }
}
