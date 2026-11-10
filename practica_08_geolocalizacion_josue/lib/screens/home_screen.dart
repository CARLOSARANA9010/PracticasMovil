import 'package:flutter/material.dart';

import 'lugares_screen.dart';
import 'ubicacion_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _indice = 0;

  static const _pantallas = [UbicacionScreen(), LugaresScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _indice, children: _pantallas),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indice,
        onDestinationSelected: (i) => setState(() => _indice = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.my_location),
            label: 'Mi ubicación',
          ),
          NavigationDestination(
            icon: Icon(Icons.place_outlined),
            label: 'Lugares',
          ),
        ],
      ),
    );
  }
}
