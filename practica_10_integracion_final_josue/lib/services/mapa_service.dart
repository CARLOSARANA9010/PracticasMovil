import 'package:url_launcher/url_launcher.dart';

class MapaService {
  static Uri uriPara(double latitud, double longitud) => Uri.parse(
    'https://www.google.com/maps/search/?api=1&query=$latitud,$longitud',
  );

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
