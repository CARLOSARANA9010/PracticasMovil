import 'package:flutter_test/flutter_test.dart';
import 'package:practica_08_geolocalizacion_josue/models/lugar.dart';
import 'package:practica_08_geolocalizacion_josue/services/mapa_service.dart';
import 'package:practica_08_geolocalizacion_josue/utils/formato.dart';
import 'package:practica_08_geolocalizacion_josue/utils/validadores.dart';

void main() {
  group('Lugar', () {
    test('toJson y fromJson son inversos', () {
      const l = Lugar(nombre: 'Malecón', latitud: 19.8441, longitud: -90.5387);
      final copia = Lugar.fromJson(l.toJson());
      expect(copia.nombre, 'Malecón');
      expect(copia.latitud, 19.8441);
      expect(copia.longitud, -90.5387);
    });

    test('fromJson acepta enteros como coordenadas', () {
      final l = Lugar.fromJson({'nombre': 'x', 'latitud': 19, 'longitud': -90});
      expect(l.latitud, 19.0);
    });
  });

  group('formato', () {
    test('menos de 1000 m se muestra en metros', () {
      expect(formatearDistancia(250.4), '250 m');
    });

    test('1000 m o más se muestra en kilómetros', () {
      expect(formatearDistancia(1500), '1.50 km');
    });

    test('las coordenadas llevan 5 decimales', () {
      expect(formatearCoordenada(19.123456789), '19.12346');
    });
  });

  group('validadores', () {
    test('nombre obligatorio y mínimo 3 caracteres', () {
      expect(validarNombre(''), isNotNull);
      expect(validarNombre('ab'), isNotNull);
      expect(validarNombre('Parque'), isNull);
    });

    test('latitud dentro de rango', () {
      expect(validarLatitud('19.84'), isNull);
      expect(validarLatitud('91'), isNotNull);
      expect(validarLatitud('abc'), isNotNull);
    });

    test('longitud dentro de rango y coma decimal', () {
      expect(validarLongitud('-90,53'), isNull);
      expect(validarLongitud('181'), isNotNull);
    });
  });

  test('la URL del mapa contiene las coordenadas', () {
    final uri = MapaService.uriPara(19.84, -90.53);
    expect(uri.host, 'www.google.com');
    expect(uri.queryParameters['query'], '19.84,-90.53');
  });
}
