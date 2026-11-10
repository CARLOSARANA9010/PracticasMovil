import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/contador_provider.dart';
import 'screens/contador_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ContadorProvider(),
      child: const MiAplicacion(),
    ),
  );
}

class MiAplicacion extends StatelessWidget {
  const MiAplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Práctica 07',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ContadorScreen(),
    );
  }
}
