import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:geolocator/geolocator.dart';

enum EstadoUbicacion {
  ok,
  servicioDesactivado,
  permisoDenegado,
  permisoDenegadoPermanente,
  error,
}

class ResultadoUbicacion {
  final EstadoUbicacion estado;
  final Position? posicion;
  final String? detalle;

  const ResultadoUbicacion(this.estado, {this.posicion, this.detalle});

  bool get exito => estado == EstadoUbicacion.ok && posicion != null;

  String get mensaje => switch (estado) {
    EstadoUbicacion.ok => 'Ubicación obtenida',
    EstadoUbicacion.servicioDesactivado => 'Activa el servicio de ubicación',
    EstadoUbicacion.permisoDenegado => 'Permiso de ubicación no disponible',
    EstadoUbicacion.permisoDenegadoPermanente =>
      'Permiso denegado permanentemente: habilítalo en los ajustes',
    EstadoUbicacion.error =>
      'No se pudo obtener la ubicación'
          '${detalle == null ? '' : ' ($detalle)'}',
  };

  bool get puedeAbrirAjustes =>
      !kIsWeb &&
      (estado == EstadoUbicacion.servicioDesactivado ||
          estado == EstadoUbicacion.permisoDenegadoPermanente);
}

class UbicacionService {
  Future<ResultadoUbicacion> obtenerActual() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return const ResultadoUbicacion(EstadoUbicacion.servicioDesactivado);
      }
      var permiso = await Geolocator.checkPermission();
      if (permiso == LocationPermission.denied) {
        permiso = await Geolocator.requestPermission();
      }
      if (permiso == LocationPermission.denied) {
        return const ResultadoUbicacion(EstadoUbicacion.permisoDenegado);
      }
      if (permiso == LocationPermission.deniedForever) {
        return const ResultadoUbicacion(
          EstadoUbicacion.permisoDenegadoPermanente,
        );
      }
      final p = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );
      return ResultadoUbicacion(EstadoUbicacion.ok, posicion: p);
    } on TimeoutException {
      return const ResultadoUbicacion(
        EstadoUbicacion.error,
        detalle: 'tiempo de espera agotado',
      );
    } catch (e) {
      return ResultadoUbicacion(EstadoUbicacion.error, detalle: '$e');
    }
  }

  Future<void> abrirAjustes(EstadoUbicacion estado) async {
    if (kIsWeb) return;
    if (estado == EstadoUbicacion.servicioDesactivado) {
      await Geolocator.openLocationSettings();
    } else {
      await Geolocator.openAppSettings();
    }
  }
}
