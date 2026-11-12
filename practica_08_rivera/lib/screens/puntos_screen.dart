import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../models/punto.dart';
import '../services/ubicacion_service.dart';
import 'ubicacion_page.dart';

String? validarNombre(String? v) {
  final t = v?.trim() ?? '';
  if (t.isEmpty) return 'Escribe un nombre';
  if (t.length > 50) return 'Máximo 50 caracteres';
  return null;
}

/// Valida una coordenada en el rango [-max, max] (90 latitud, 180 longitud).
String? validarCoordenada(String? v, double max) {
  final n = double.tryParse(v?.trim().replaceAll(',', '.') ?? '');
  if (n == null) return 'Número inválido';
  if (n < -max || n > max) return 'Entre -$max y $max';
  return null;
}

double _numero(String v) => double.parse(v.trim().replaceAll(',', '.'));

class PuntosScreen extends StatefulWidget {
  const PuntosScreen({super.key});

  @override
  State<PuntosScreen> createState() => _PuntosScreenState();
}

class _PuntosScreenState extends State<PuntosScreen> {
  final _service = PuntosService();
  List<Punto> _puntos = [];
  Position? _actual;
  String _mensaje = 'Obteniendo ubicación…';
  bool _cargando = false;

  @override
  void initState() {
    super.initState();
    _service.cargar().then((p) {
      if (mounted) setState(() => _puntos = p);
    });
    _actualizar();
  }

  Future<void> _actualizar() async {
    setState(() {
      _cargando = true;
      _mensaje = 'Obteniendo ubicación…';
    });
    try {
      final p = await posicionActual();
      if (!mounted) return;
      setState(() {
        _actual = p;
        _mensaje = 'Ubicación actual';
      });
    } on UbicacionException catch (e) {
      if (!mounted) return;
      setState(() => _mensaje = e.mensaje);
      if (e.ajustes != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.mensaje),
            action: SnackBarAction(label: 'Ajustes', onPressed: e.ajustes!),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  Future<void> _mapa(double lat, double lon) async {
    if (!await abrirMapa(lat, lon) && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No se pudo abrir el mapa')));
    }
  }

  Future<void> _agregar() async {
    final punto = await showDialog<Punto>(
      context: context,
      builder: (_) => _DialogoPunto(actual: _actual),
    );
    if (punto == null) return;
    setState(() => _puntos = [..._puntos, punto]);
    await _service.guardar(_puntos);
  }

  Future<void> _eliminar(Punto p) async {
    setState(() => _puntos = _puntos.where((x) => x != p).toList());
    await _service.guardar(_puntos);
  }

  @override
  Widget build(BuildContext context) {
    final a = _actual;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puntos de interés'),
        actions: [
          IconButton(
            tooltip: 'Ejemplo guiado',
            icon: const Icon(Icons.school),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const UbicacionPage()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _agregar,
        icon: const Icon(Icons.add_location_alt),
        label: const Text('Guardar punto'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.my_location, size: 36),
              title: Text(_mensaje),
              subtitle: a == null
                  ? null
                  : Text(
                      'Lat: ${a.latitude.toStringAsFixed(6)}\n'
                      'Lon: ${a.longitude.toStringAsFixed(6)}\n'
                      'Precisión: ${a.accuracy.toStringAsFixed(1)} m',
                    ),
              isThreeLine: a != null,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (a != null)
                    IconButton(
                      tooltip: 'Abrir mi ubicación en el mapa',
                      icon: const Icon(Icons.map),
                      onPressed: () => _mapa(a.latitude, a.longitude),
                    ),
                  _cargando
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox.square(
                            dimension: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : IconButton(
                          tooltip: 'Actualizar ubicación',
                          icon: const Icon(Icons.refresh),
                          onPressed: _actualizar,
                        ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_puntos.length} punto(s) guardado(s)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (_puntos.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Aún no hay puntos. Usa "Guardar punto" para agregar al menos tres.',
                textAlign: TextAlign.center,
              ),
            ),
          for (final p in _puntos)
            Card(
              child: ListTile(
                leading: const Icon(Icons.place),
                title: Text(p.nombre),
                subtitle: Text(
                  '${p.lat.toStringAsFixed(6)}, ${p.lon.toStringAsFixed(6)}\n'
                  '${a == null ? 'Distancia: sin ubicación actual' : 'Distancia: ${formatearDistancia(distancia(a.latitude, a.longitude, p.lat, p.lon))}'}',
                ),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Abrir ${p.nombre} en el mapa',
                      icon: const Icon(Icons.map),
                      onPressed: () => _mapa(p.lat, p.lon),
                    ),
                    IconButton(
                      tooltip: 'Eliminar ${p.nombre}',
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _eliminar(p),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Formulario para un punto nuevo; las coordenadas se prellenan con la
/// ubicación actual y pueden editarse para registrar lugares lejanos.
class _DialogoPunto extends StatefulWidget {
  const _DialogoPunto({this.actual});
  final Position? actual;

  @override
  State<_DialogoPunto> createState() => _DialogoPuntoState();
}

class _DialogoPuntoState extends State<_DialogoPunto> {
  final _form = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  late final _lat = TextEditingController(
    text: widget.actual?.latitude.toStringAsFixed(6),
  );
  late final _lon = TextEditingController(
    text: widget.actual?.longitude.toStringAsFixed(6),
  );

  @override
  void dispose() {
    _nombre.dispose();
    _lat.dispose();
    _lon.dispose();
    super.dispose();
  }

  void _guardar() {
    if (!_form.currentState!.validate()) return;
    Navigator.pop(
      context,
      Punto(
        nombre: _nombre.text.trim(),
        lat: _numero(_lat.text),
        lon: _numero(_lon.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Nuevo punto de interés'),
    content: Form(
      key: _form,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _nombre,
            decoration: const InputDecoration(labelText: 'Nombre'),
            validator: validarNombre,
            autofocus: true,
          ),
          TextFormField(
            controller: _lat,
            decoration: const InputDecoration(labelText: 'Latitud'),
            keyboardType: const TextInputType.numberWithOptions(
              signed: true,
              decimal: true,
            ),
            validator: (v) => validarCoordenada(v, 90),
          ),
          TextFormField(
            controller: _lon,
            decoration: const InputDecoration(labelText: 'Longitud'),
            keyboardType: const TextInputType.numberWithOptions(
              signed: true,
              decimal: true,
            ),
            validator: (v) => validarCoordenada(v, 180),
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancelar'),
      ),
      FilledButton(onPressed: _guardar, child: const Text('Guardar')),
    ],
  );
}
