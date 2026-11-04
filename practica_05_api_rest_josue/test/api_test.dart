import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:practica_05_api/models/post.dart';
import 'package:practica_05_api/services/api_service.dart';

void main() {
  test('Post.fromJson convierte el JSON a objeto Dart', () {
    final p = Post.fromJson({
      'userId': 1,
      'id': 7,
      'title': 'titulo',
      'body': 'cuerpo',
    });
    expect(p.id, 7);
    expect(p.userId, 1);
    expect(p.titulo, 'titulo');
    expect(p.cuerpo, 'cuerpo');
  });

  test('obtenerPosts devuelve la lista cuando el status es 200', () async {
    final client = MockClient(
      (_) async =>
          http.Response('[{"userId":1,"id":1,"title":"a","body":"b"}]', 200),
    );
    final posts = await ApiService(client: client).obtenerPosts();
    expect(posts.length, 1);
  });

  test('obtenerPosts lanza excepción cuando el status no es 200', () async {
    final client = MockClient((_) async => http.Response('error', 500));
    expect(ApiService(client: client).obtenerPosts(), throwsException);
  });
}
