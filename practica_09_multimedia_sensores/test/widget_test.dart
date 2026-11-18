import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practica_09_multimedia_sensores/main.dart';

void main() {
  testWidgets('Renderiza bitácora de inspección, sensores y botón de cámara', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: BitacoraInspeccionPage()));

    expect(find.text('Bitácora de Inspección'), findsOneWidget);
    expect(find.text('Lectura de Sensores en Tiempo Real'), findsOneWidget);
    expect(find.text('Capturar Fotografía de Inspección'), findsOneWidget);
    expect(find.textContaining('Acelerómetro:'), findsOneWidget);
    expect(find.textContaining('Giroscopio:'), findsOneWidget);
  });
}
