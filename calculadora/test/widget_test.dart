import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:calculadora/main.dart';

void main() {
  testWidgets('Widget smoke test: la aplicación inicia correctamente', (
    tester,
  ) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    expect(find.text('Consumo de combustible'), findsOneWidget);
    expect(find.text('Calculadora de rendimiento'), findsOneWidget);
  });

  testWidgets('Widget smoke test: realiza un cálculo desde la interfaz', (
    tester,
  ) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    final campos = find.byType(TextField);
    await tester.enterText(campos.at(0), '300');
    await tester.enterText(campos.at(1), '20');
    await tester.tap(find.text('Calcular rendimiento'));
    await tester.pumpAndSettle();

    expect(find.text('15.00 km/L'), findsOneWidget);
    expect(find.text('Buen rendimiento'), findsOneWidget);
  });
}
