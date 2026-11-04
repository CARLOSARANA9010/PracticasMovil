import 'package:flutter/material.dart';

import 'pages/posts_page.dart';
import 'pages/usuarios_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Práctica 5 - API REST',
    theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
    home: const InicioPage(),
  );
}

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  int _indice = 0;

  static const _paginas = [PostsPage(), UsuariosPage()];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: _paginas[_indice],
    bottomNavigationBar: NavigationBar(
      selectedIndex: _indice,
      onDestinationSelected: (i) => setState(() => _indice = i),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.article_outlined),
          label: 'Posts',
        ),
        NavigationDestination(
          icon: Icon(Icons.people_outline),
          label: 'Usuarios',
        ),
      ],
    ),
  );
}
