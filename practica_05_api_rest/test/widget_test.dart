import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practica_05_api_rest/main.dart'; // Asegúrate de usar el nombre de tu proyecto

void main() {
  group('Pruebas de la Práctica 5 - API Rest', () {
    // 1. Prueba de Unidad: Conversión del Modelo Post
    test(
      'Debe convertir un Map JSON a una instancia de Post correctamente',
      () {
        // Arrange
        final Map<String, dynamic> jsonMap = {
          'id': 1,
          'title': 'Título de prueba',
          'body': 'Cuerpo de la publicación de prueba para la práctica.',
        };

        // Act
        final post = Post.fromJson(jsonMap);

        // Assert
        expect(post.id, 1);
        expect(post.title, 'Título de prueba');
        expect(
          post.body,
          'Cuerpo de la publicación de prueba para la práctica.',
        );
      },
    );

    // 2. Prueba de Widget: Interfaz y Estados
    testWidgets('PostsPage muestra la barra de navegación inicial', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(home: PostsPage()));

      // Assert
      expect(find.text('Publicaciones REST'), findsOneWidget);
    });
  });
}
