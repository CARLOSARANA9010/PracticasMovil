import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practica_07_arquitectura/main.dart'; // Ajusta "tu_proyecto" al nombre real de tu paquete

void main() {
  testWidgets('Prueba de renderizado inicial Práctica 6', (
    WidgetTester tester,
  ) async {
    // Al usar base de datos asíncrona, solo probamos que la UI base construya sin crashear
    await tester.pumpWidget(const Practica6App());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
