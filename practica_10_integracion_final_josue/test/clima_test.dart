import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:practica_10_integracion_final_josue/models/clima.dart';
import 'package:practica_10_integracion_final_josue/services/clima_service.dart';

const _json = '''
{"latitude":19.83,"longitude":-90.53,
 "current":{"time":"2026-11-09T10:15","interval":900,
 "temperature_2m":28.4,"wind_speed_10m":12.3,"weather_code":2}}
''';

void main() {
  test('Clima.fromJson lee temperatura, viento y código', () {
    final c = Clima.fromJson({
      'current': {
        'time': '2026-11-09T10:15',
        'temperature_2m': 28,
        'wind_speed_10m': 12.3,
        'weather_code': 2,
      },
    });
    expect(c.temperatura, 28.0);
    expect(c.viento, 12.3);
    expect(c.codigo, 2);
    expect(c.hora, isNotNull);
  });

  test('la descripción traduce el código meteorológico', () {
    Clima conCodigo(int c) => Clima(temperatura: 0, viento: 0, codigo: c);
    expect(conCodigo(0).descripcion, 'Despejado');
    expect(conCodigo(2).descripcion, 'Parcialmente nublado');
    expect(conCodigo(63).descripcion, 'Lluvia');
    expect(conCodigo(95).descripcion, 'Tormenta');
  });

  test('el servicio devuelve el clima con respuesta 200', () async {
    final client = MockClient((request) async {
      expect(request.url.host, 'api.open-meteo.com');
      expect(request.url.queryParameters['latitude'], '19.83');
      return http.Response(_json, 200);
    });
    final c = await ClimaService(client: client).obtener(19.83, -90.53);
    expect(c.temperatura, 28.4);
  });

  test('el servicio lanza ClimaException con status distinto de 200', () async {
    final client = MockClient((_) async => http.Response('error', 500));
    expect(
      ClimaService(client: client).obtener(19.83, -90.53),
      throwsA(isA<ClimaException>()),
    );
  });

  test('el servicio lanza ClimaException si el JSON no es válido', () async {
    final client = MockClient((_) async => http.Response('no es json', 200));
    expect(
      ClimaService(client: client).obtener(19.83, -90.53),
      throwsA(isA<ClimaException>()),
    );
  });
}
