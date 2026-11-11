import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/contador_provider.dart';
import 'providers/posts_provider.dart';
import 'screens/home_screen.dart';
import 'services/api_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ContadorProvider()),
        ChangeNotifierProvider(
          create: (_) => PostsProvider(ApiService())..cargar(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Práctica 7 - Arquitectura',
        theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
        home: const HomeScreen(),
      ),
    );
  }
}
