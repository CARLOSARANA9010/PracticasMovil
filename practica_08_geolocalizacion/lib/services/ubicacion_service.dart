import 'package:geolocator/geolocator.dart';

class UbicacionService {
  Future<Position> obtenerUbicacion() async {
    // Comprobar si el servicio de ubicación está activo.
    final servicioActivo = await Geolocator.isLocationServiceEnabled();

    if (!servicioActivo) {
      throw Exception('Activa el servicio de ubicación.');
    }

    // Comprobar los permisos actuales.
    LocationPermission permiso = await Geolocator.checkPermission();

    // Solicitar permiso si todavía no ha sido concedido.
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }

    // Verificar si el usuario rechazó el permiso.
    if (permiso == LocationPermission.denied) {
      throw Exception('No se concedió el permiso de ubicación.');
    }

    // Verificar si el permiso fue bloqueado permanentemente.
    if (permiso == LocationPermission.deniedForever) {
      throw Exception(
        'El permiso está bloqueado. Habilítalo en la configuración.',
      );
    }

    // Obtener la posición actual.
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }
}
