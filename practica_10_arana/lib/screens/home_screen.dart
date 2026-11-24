import 'package:flutter/material.dart';
import '../models/incidencia.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';
import '../widgets/estado_vista.dart';
import '../widgets/incidencia_card.dart';
import 'api_screen.dart';
import 'detail_screen.dart';
import 'form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storageService = StorageService();
  List<Incidencia> _reportes = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarReportes();
  }

  Future<void> _cargarReportes() async {
    setState(() => _cargando = true);
    final lista = await _storageService.obtenerReportes();
    if (!mounted) return;
    setState(() {
      _reportes = lista;
      _cargando = false;
    });
  }

  Future<void> _irAFormulario() async {
    final guardado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const FormScreen()),
    );
    if (guardado == true) {
      await _cargarReportes();
    }
  }

  Future<void> _irADetalle(Incidencia incidencia) async {
    final actualizado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => DetailScreen(incidencia: incidencia)),
    );
    if (actualizado == true) {
      await _cargarReportes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporte de Incidencias'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active_outlined),
            tooltip: 'Probar notificación (Parte A)',
            onPressed: () => Notificaciones.mostrar(),
          ),
          IconButton(
            icon: const Icon(Icons.sync),
            tooltip: 'API REST / Sincronización',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ApiScreen()),
              );
            },
          ),
        ],
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _reportes.isEmpty
          ? const EstadoVista(
              icono: Icons.assignment_outlined,
              titulo: 'No hay reportes registrados',
              mensaje:
                  'Presiona el botón "Nuevo Reporte" para capturar una incidencia con foto y ubicación.',
            )
          : RefreshIndicator(
              onRefresh: _cargarReportes,
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 8, bottom: 88),
                itemCount: _reportes.length,
                itemBuilder: (context, index) {
                  final reporte = _reportes[index];
                  return IncidenciaCard(
                    incidencia: reporte,
                    onTap: () => _irADetalle(reporte),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _irAFormulario,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Reporte'),
      ),
    );
  }
}
