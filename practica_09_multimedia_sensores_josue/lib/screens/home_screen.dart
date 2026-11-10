import 'package:flutter/material.dart';

import '../services/camara_service.dart';
import '../services/monitor_sensores.dart';
import '../services/sensores_service.dart';
import 'bitacora_screen.dart';
import 'ejemplo_guiado_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _indice = 0;
  late final MonitorSensores _monitor;
  final _camara = CamaraService();

  @override
  void initState() {
    super.initState();
    final sensores = SensoresService();
    _monitor = MonitorSensores(
      acelerometro: sensores.acelerometro,
      giroscopio: sensores.giroscopio,
    )..iniciar();
  }

  @override
  void dispose() {
    _monitor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _indice,
        children: [
          BitacoraScreen(monitor: _monitor, camara: _camara),
          EjemploGuiadoScreen(monitor: _monitor, camara: _camara),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indice,
        onDestinationSelected: (i) => setState(() => _indice = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            label: 'Bitácora',
          ),
          NavigationDestination(
            icon: Icon(Icons.camera_alt_outlined),
            label: 'Ejemplo guiado',
          ),
        ],
      ),
    );
  }
}
