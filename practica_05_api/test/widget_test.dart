import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:practica_05_api/models/post.dart';
import 'package:practica_05_api/models/usuario.dart';
import 'package:practica_05_api/screens/posts_page.dart';
import 'package:practica_05_api/services/api.dart' as api;

final _posts = List.generate(
  20,
  (i) => {
    'userId': 1,
    'id': i + 1,
    'title': 'Titulo ${i + 1}',
    'body': 'Cuerpo ${i + 1}',
  },
);

Future<void> _abrir(WidgetTester tester, http.Response respuesta) async {
  api.cliente = MockClient((_) async => respuesta);
  await tester.pumpWidget(const MaterialApp(home: PostsPage()));
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
  await tester.pumpAndSettle();
}

void main() {
  test('Post.fromJson convierte el JSON', () {
    final p = Post.fromJson(_posts.first);
    expect(
      [p.id, p.userId, p.titulo, p.cuerpo],
      [1, 1, 'Titulo 1', 'Cuerpo 1'],
    );
  });

  test('Usuario.fromJson convierte el JSON', () {
    final u = Usuario.fromJson({'id': 3, 'name': 'Ana', 'email': 'a@b.c'});
    expect([u.id, u.nombre, u.correo], [3, 'Ana', 'a@b.c']);
  });

  testWidgets('muestra la lista y abre el detalle', (tester) async {
    await _abrir(tester, http.Response(jsonEncode(_posts), 200));
    expect(find.text('Titulo 1'), findsOneWidget);
    await tester.tap(find.text('Titulo 1'));
    await tester.pumpAndSettle();
    expect(find.text('Publicación #1'), findsOneWidget);
    expect(find.text('Cuerpo 1'), findsOneWidget);
  });

  testWidgets('muestra error si el status no es 200', (tester) async {
    await _abrir(tester, http.Response('', 500));
    expect(find.text('Error: Exception: HTTP 500'), findsOneWidget);
    expect(find.text('Reintentar'), findsOneWidget);
  });

  testWidgets('muestra mensaje con lista vacía', (tester) async {
    await _abrir(tester, http.Response('[]', 200));
    expect(find.text('No hay datos para mostrar'), findsOneWidget);
  });
}
