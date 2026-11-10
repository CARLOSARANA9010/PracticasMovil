import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/clima.dart';

class ClimaException implements Exception {
  final String mensaje;
  const ClimaException(this.mensaje);

  @override
  String toString() => mensaje;
}

/// Consumo de la API REST pública de Open-Meteo (sin clave, formato JSON).
class ClimaService {
  ClimaService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<Clima> obtener(double latitud, double longitud) async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': '$latitud',
      'longitude': '$longitud',
      'current': 'temperature_2m,wind_speed_10m,weather_code',
    });
    try {
      final r = await _client.get(uri).timeout(const Duration(seconds: 15));
      if (r.statusCode != 200) {
        throw ClimaException('El servicio respondió ${r.statusCode}');
      }
      return Clima.fromJson(jsonDecode(r.body) as Map<String, dynamic>);
    } on ClimaException {
      rethrow;
    } on TimeoutException {
      throw const ClimaException('Tiempo de espera agotado');
    } on http.ClientException {
      throw const ClimaException('Sin conexión a Internet');
    } on FormatException {
      throw const ClimaException('Respuesta del servicio no válida');
    } on TypeError {
      throw const ClimaException('Formato de datos inesperado');
    }
  }
}
