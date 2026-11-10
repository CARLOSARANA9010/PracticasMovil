import 'package:url_launcher/url_launcher.dart';

/// Apertura de mapas externos (la app no incrusta un mapa propio).
class MapaService {
  static Uri uriPara(double latitud, double longitud) => Uri.parse(
    'https://www.google.com/maps/search/?api=1&query=$latitud,$longitud',
  );

  /// Devuelve false si no se pudo abrir (sin lanzar excepciones).
  static Future<bool> abrir(double latitud, double longitud) async {
    try {
      return await launchUrl(
        uriPara(latitud, longitud),
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {
      return false;
    }
  }
}
