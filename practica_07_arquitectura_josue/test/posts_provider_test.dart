import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:practica_07_arquitectura_josue/providers/posts_provider.dart';
import 'package:practica_07_arquitectura_josue/services/api_service.dart';

void main() {
  test('estado inicial antes de cargar', () {
    final p = PostsProvider(
      ApiService(client: MockClient((_) async => http.Response('[]', 200))),
    );
    expect(p.estado, EstadoCarga.inicial);
    expect(p.posts, isEmpty);
  });

  test('cargar con respuesta 200 deja la lista lista', () async {
    final client = MockClient(
      (_) async =>
          http.Response('[{"userId":1,"id":1,"title":"t","body":"b"}]', 200),
    );
    final p = PostsProvider(ApiService(client: client));
    await p.cargar();
    expect(p.estado, EstadoCarga.listo);
    expect(p.posts.length, 1);
    expect(p.actualizado, isNotNull);
  });

  test('cargar con status 500 deja estado de error con mensaje', () async {
    final client = MockClient((_) async => http.Response('fallo', 500));
    final p = PostsProvider(ApiService(client: client));
    await p.cargar();
    expect(p.estado, EstadoCarga.error);
    expect(p.error, contains('500'));
  });

  test('cargar notifica carga y resultado', () async {
    final client = MockClient((_) async => http.Response('[]', 200));
    final p = PostsProvider(ApiService(client: client));
    final estados = <EstadoCarga>[];
    p.addListener(() => estados.add(p.estado));
    await p.cargar();
    expect(estados, [EstadoCarga.cargando, EstadoCarga.listo]);
  });
}
