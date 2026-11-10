import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../models/lugar.dart';
import '../services/lugares_repository.dart';
import '../services/mapa_service.dart';
import '../services/ubicacion_service.dart';
import '../widgets/dialogo_lugar.dart';
import '../widgets/lugar_tile.dart';
import '../widgets/tarjeta_posicion.dart';

/// Ejercicio evaluable: app de puntos de interés.
class LugaresScreen extends StatefulWidget {
  const LugaresScreen({super.key});

  @override
  State<LugaresScreen> createState() => _LugaresScreenState();
}

class _LugaresScreenState extends State<LugaresScreen> {
  final _servicio = UbicacionService();
  final _repo = LugaresRepository();

  List<Lugar> _lugares = [];
  Position? _actual;
  ResultadoUbicacion? _resultado;
  bool _cargandoUbicacion = false;
  bool _cargandoLista = true;

  @override
  void initState() {
    super.initState();
    _iniciar();
  }

  Future<void> _iniciar() async {
    final guardados = await _repo.cargar();
    if (!mounted) return;
    setState(() {
      _lugares = guardados;
      _cargandoLista = false;
    });
    await _actualizarUbicacion();
  }

  Future<void> _actualizarUbicacion() async {
    setState(() => _cargandoUbicacion = true);
    final r = await _servicio.obtenerActual();
    if (!mounted) return;
    setState(() {
      _cargandoUbicacion = false;
      _resultado = r;
      if (r.exito) _actual = r.posicion;
    });
  }

  Future<void> _agregar() async {
    final nuevo = await showDialog<Lugar>(
      context: context,
      builder: (_) => DialogoLugar(
        latitudInicial: _actual?.latitude,
        longitudInicial: _actual?.longitude,
      ),
    );
    if (nuevo == null) return;
    final lista = [..._lugares, nuevo];
    await _repo.guardar(lista);
    if (!mounted) return;
    setState(() => _lugares = lista);
  }

  Future<void> _eliminar(int indice) async {
    final lugar = _lugares[indice];
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar lugar'),
        content: Text('¿Eliminar "${lugar.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    final lista = [..._lugares]..removeAt(indice);
    await _repo.guardar(lista);
    if (!mounted) return;
    setState(() => _lugares = lista);
  }

  Future<void> _abrirMapa(Lugar l) async {
    final ok = await MapaService.abrir(l.latitud, l.longitud);
    if (!ok && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No se pudo abrir el mapa')));
    }
  }

  double? _distancia(Lugar l) {
    final a = _actual;
    if (a == null) return null;
    return _servicio.distanciaMetros(
      a.latitude,
      a.longitude,
      l.latitud,
      l.longitud,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Puntos de interés')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _agregar,
        icon: const Icon(Icons.add_location_alt),
        label: const Text('Agregar lugar'),
      ),
      body: Column(
        children: [
          TarjetaPosicion(
            posicion: _actual,
            resultado: _resultado,
            cargando: _cargandoUbicacion,
            onActualizar: _actualizarUbicacion,
            onAjustes: _resultado == null
                ? null
                : () => _servicio.abrirAjustes(_resultado!.estado),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _lugares.length >= 3
                    ? 'Lugares guardados: ${_lugares.length}'
                    : 'Lugares guardados: ${_lugares.length} (guarda al menos 3)',
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: _cargandoLista
                ? const Center(child: CircularProgressIndicator())
                : _lugares.isEmpty
                ? const Center(child: Text('Aún no hay lugares guardados'))
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 88),
                    itemCount: _lugares.length,
                    itemBuilder: (context, i) => LugarTile(
                      lugar: _lugares[i],
                      distanciaMetros: _distancia(_lugares[i]),
                      onMapa: () => _abrirMapa(_lugares[i]),
                      onEliminar: () => _eliminar(i),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
