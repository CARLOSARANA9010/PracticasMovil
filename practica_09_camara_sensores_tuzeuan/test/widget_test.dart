import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practica_09_camara_sensores_tuzeuan/main.dart';

void main() {
  testWidgets('La aplicación muestra la bitácora de inspección', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MiAplicacion());

    expect(find.text('Bitácora de inspección'), findsOneWidget);
    expect(find.text('Tomar fotografía'), findsOneWidget);
    expect(find.text('Acelerómetro'), findsOneWidget);
    expect(find.text('Giroscopio'), findsOneWidget);

    final scrollable = find.byType(Scrollable).first;

    await tester.scrollUntilVisible(
      find.text('Bitácora de evidencias'),
      200,
      scrollable: scrollable,
    );

    expect(find.text('Bitácora de evidencias'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Todavía no hay evidencias registradas.'),
      200,
      scrollable: scrollable,
    );

    expect(find.text('Todavía no hay evidencias registradas.'), findsOneWidget);
  });
}
