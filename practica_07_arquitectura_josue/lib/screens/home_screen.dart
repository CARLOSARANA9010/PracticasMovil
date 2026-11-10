import 'package:flutter/material.dart';

import 'contador_screen.dart';
import 'posts_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _indice = 0;

  // const: estas pantallas no se reconstruyen al cambiar de pestaña.
  static const _pantallas = [PostsScreen(), ContadorScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _indice, children: _pantallas),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indice,
        onDestinationSelected: (i) => setState(() => _indice = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.article_outlined),
            label: 'Publicaciones',
          ),
          NavigationDestination(
            icon: Icon(Icons.exposure_plus_1),
            label: 'Contador',
          ),
        ],
      ),
    );
  }
}
