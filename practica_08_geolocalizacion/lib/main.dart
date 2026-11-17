import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(
  const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PuntosInteresPage(),
  ),
);

class PuntoInteres {
  final String nombre;
  final double latitud;
  final double longitud;

  PuntoInteres({
    required this.nombre,
    required this.latitud,
    required this.longitud,
  });
}

class PuntosInteresPage extends StatefulWidget {
  const PuntosInteresPage({super.key});

  @override
  State<PuntosInteresPage> createState() => _PuntosInteresPageState();
}

class _PuntosInteresPageState extends State<PuntosInteresPage> {
  Position? posicionActual;
  String mensaje = 'Sin ubicación obtenida';

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();

  // Coordenadas reales de Calkiní, Campeche
  final List<PuntoInteres> puntosGuardados = [
    PuntoInteres(
      nombre: 'Parque Principal Calkiní',
      latitud: 20.3712,
      longitud: -90.0518,
    ),
  ];

  Future<void> obtenerUbicacion() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      setState(() => mensaje = 'Activa el servicio de ubicación (GPS)');
      return;
    }

    var permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied ||
          permiso == LocationPermission.deniedForever) {
        setState(() => mensaje = 'Permiso de ubicación denegado');
        return;
      }
    }

    final p = await Geolocator.getCurrentPosition();
    setState(() {
      posicionActual = p;
      mensaje = 'Ubicación actualizada';
    });
  }

  void usarUbicacionActualEnCampos() {
    if (posicionActual == null) return;
    _latController.text = posicionActual!.latitude.toStringAsFixed(6);
    _lngController.text = posicionActual!.longitude.toStringAsFixed(6);
  }

  void guardarPunto() {
    final nombre = _nombreController.text.trim();
    final lat = double.tryParse(_latController.text.trim());
    final lng = double.tryParse(_lngController.text.trim());

    if (nombre.isEmpty || lat == null || lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingresa un nombre, latitud y longitud válidos'),
        ),
      );
      return;
    }

    setState(() {
      puntosGuardados.add(
        PuntoInteres(nombre: nombre, latitud: lat, longitud: lng),
      );
      _nombreController.clear();
      _latController.clear();
      _lngController.clear();
    });
    FocusScope.of(context).unfocus();
  }

  double calcularDistanciaMetros(PuntoInteres punto) {
    if (posicionActual == null) return 0.0;
    return Geolocator.distanceBetween(
      posicionActual!.latitude,
      posicionActual!.longitude,
      punto.latitud,
      punto.longitud,
    );
  }

  Future<void> abrirEnMapa(double lat, double lng) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Puntos de Interés y GPS')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.location_on, size: 44, color: Colors.blue),
                  Text(
                    mensaje,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (posicionActual != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Latitud: ${posicionActual!.latitude.toStringAsFixed(6)}',
                    ),
                    Text(
                      'Longitud: ${posicionActual!.longitude.toStringAsFixed(6)}',
                    ),
                    Text(
                      'Precisión: ${posicionActual!.accuracy.toStringAsFixed(1)} m',
                    ),
                  ],
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      FilledButton.icon(
                        onPressed: obtenerUbicacion,
                        icon: const Icon(Icons.my_location),
                        label: const Text('Obtener ubicación'),
                      ),
                      if (posicionActual != null)
                        OutlinedButton.icon(
                          onPressed: () => abrirEnMapa(
                            posicionActual!.latitude,
                            posicionActual!.longitude,
                          ),
                          icon: const Icon(Icons.map),
                          label: const Text('Abrir en mapa'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Agregar nuevo punto de interés',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del lugar',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _latController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Latitud',
                            hintText: '20.3712',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _lngController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Longitud',
                            hintText: '-90.0518',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (posicionActual != null)
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: usarUbicacionActualEnCampos,
                            icon: const Icon(Icons.pin_drop, size: 18),
                            label: const Text('Usar GPS actual'),
                          ),
                        ),
                      if (posicionActual != null) const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: guardarPunto,
                          icon: const Icon(Icons.add_location_alt, size: 18),
                          label: const Text('Guardar lugar'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Puntos Guardados y Distancia:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          ...puntosGuardados.map((punto) {
            final distancia = calcularDistanciaMetros(punto);
            return Card(
              child: ListTile(
                leading: const Icon(Icons.place, color: Colors.redAccent),
                title: Text(punto.nombre),
                subtitle: Text(
                  'Lat: ${punto.latitud.toStringAsFixed(4)}, Lng: ${punto.longitud.toStringAsFixed(4)}'
                  '${posicionActual != null ? '\nDistancia: ${(distancia / 1000).toStringAsFixed(2)} km (${distancia.toStringAsFixed(0)} m)' : ''}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.open_in_new),
                  tooltip: 'Ver en Google Maps',
                  onPressed: () => abrirEnMapa(punto.latitud, punto.longitud),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
