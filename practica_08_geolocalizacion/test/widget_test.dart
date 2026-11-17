import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practica_08_geolocalizacion/main.dart';

void main() {
  testWidgets('Renderiza interfaz inicial de GPS y permite guardar puntos', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: PuntosInteresPage()));

    expect(find.text('Puntos de Interés y GPS'), findsOneWidget);
    expect(find.text('Sin ubicación obtenida'), findsOneWidget);
    expect(find.text('Obtener ubicación'), findsOneWidget);

    final listScrollable = find.byType(Scrollable).first;

    await tester.scrollUntilVisible(
      find.text('Parque Principal Calkiní'),
      200,
      scrollable: listScrollable,
    );
    expect(find.text('Parque Principal Calkiní'), findsOneWidget);
  });
}
