import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/contador_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ContadorProvider(),
      child: const Practica7App(),
    ),
  );
}

class Practica7App extends StatelessWidget {
  const Practica7App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arquitectura Flutter',
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
