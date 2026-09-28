import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practica_cuatro/screens/inicio_page.dart';

void main() {
  testWidgets('Verifica que el catálogo carga correctamente', (
    WidgetTester tester,
  ) async {
    // Inflamos la nueva página principal en lugar de la vieja MyApp
    await tester.pumpWidget(const MaterialApp(home: InicioPage()));

    // Verificamos que al menos el título de tu pantalla exista en la UI
    expect(find.text('Catálogo de Materias'), findsOneWidget);
  });
}
