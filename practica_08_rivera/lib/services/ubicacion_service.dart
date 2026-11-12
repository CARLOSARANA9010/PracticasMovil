import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/punto.dart';

/// Error de ubicación con un mensaje listo para la UI.
/// [ajustes] indica qué pantalla del sistema puede resolverlo.
class UbicacionException implements Exception {
  const UbicacionException(this.mensaje, {this.ajustes});
  final String mensaje;
  final Future<bool> Function()? ajustes;
}

/// Verifica servicio y permisos y devuelve la posición actual.
/// Lanza [UbicacionException] en cualquier estado que impida obtenerla.
Future<Position> posicionActual() async {
  try {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const UbicacionException(
        'Activa el servicio de ubicación',
        ajustes: Geolocator.openLocationSettings,
      );
    }
    var permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }
    if (permiso == LocationPermission.denied) {
      throw const UbicacionException('Permiso de ubicación denegado');
    }
    if (permiso == LocationPermission.deniedForever) {
      throw const UbicacionException(
        'Permiso denegado permanentemente: habilítalo en ajustes',
        ajustes: Geolocator.openAppSettings,
      );
    }
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 20),
      ),
    );
  } on UbicacionException {
    rethrow;
  } catch (_) {
    // Timeout, plugin no disponible en la plataforma, etc.: nunca cerrar la app.
    throw const UbicacionException('No se pudo obtener la ubicación');
  }
}

double distancia(double lat1, double lon1, double lat2, double lon2) =>
    Geolocator.distanceBetween(lat1, lon1, lat2, lon2);

String formatearDistancia(double metros) => metros < 1000
    ? '${metros.round()} m'
    : '${(metros / 1000).toStringAsFixed(2)} km';

/// Abre la ubicación en Google Maps (app o navegador). Devuelve false si falla.
Future<bool> abrirMapa(double lat, double lon) => launchUrl(
  Uri.https('www.google.com', '/maps/search/', {
    'api': '1',
    'query': '$lat,$lon',
  }),
  mode: LaunchMode.externalApplication,
);

/// Persistencia de los puntos de interés (JSON en shared_preferences).
class PuntosService {
  static const _clave = 'puntos';

  Future<List<Punto>> cargar() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_clave);
    if (raw == null) return [];
    return (jsonDecode(raw) as List)
        .map((e) => Punto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> guardar(List<Punto> puntos) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_clave, jsonEncode(puntos));
  }
}
