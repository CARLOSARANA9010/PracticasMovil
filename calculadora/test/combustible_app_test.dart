import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:calculadora/main.dart';

void main() {
  Future<void> cargarAplicacion(WidgetTester tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();
  }

  Future<void> ejecutarCalculo(
    WidgetTester tester,
    String kilometros,
    String litros,
  ) async {
    await tester.enterText(find.byType(TextField).at(0), kilometros);
    await tester.enterText(find.byType(TextField).at(1), litros);
    await tester.tap(find.text('Calcular rendimiento'));
    await tester.pumpAndSettle();
  }

  testWidgets('TC-01: muestra la pantalla principal', (tester) async {
    await cargarAplicacion(tester);

    expect(find.text('Consumo de combustible'), findsOneWidget);
    expect(find.text('Calculadora de rendimiento'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Calcular rendimiento'), findsOneWidget);
    expect(find.text('Limpiar campos'), findsOneWidget);
  });

  testWidgets('TC-02: calcula 300 km / 20 L = 15.00 km/L', (tester) async {
    await cargarAplicacion(tester);
    await ejecutarCalculo(tester, '300', '20');

    expect(find.text('15.00 km/L'), findsOneWidget);
    expect(find.text('Buen rendimiento'), findsOneWidget);
    expect(
      find.text('Ingresa kilómetros y litros válidos mayores que cero.'),
      findsNothing,
    );
  });

  testWidgets('TC-03: clasifica 240 km / 20 L como rendimiento medio', (
    tester,
  ) async {
    await cargarAplicacion(tester);
    await ejecutarCalculo(tester, '240', '20');

    expect(find.text('12.00 km/L'), findsOneWidget);
    expect(find.text('Rendimiento medio'), findsOneWidget);
  });

  testWidgets('TC-04: clasifica 180 km / 20 L como bajo rendimiento', (
    tester,
  ) async {
    await cargarAplicacion(tester);
    await ejecutarCalculo(tester, '180', '20');

    expect(find.text('9.00 km/L'), findsOneWidget);
    expect(find.text('Bajo rendimiento'), findsOneWidget);
  });

  testWidgets('TC-05: rechaza letras en lugar de un número', (tester) async {
    await cargarAplicacion(tester);
    await ejecutarCalculo(tester, 'abc', '20');

    expect(
      find.text('Ingresa kilómetros y litros válidos mayores que cero.'),
      findsOneWidget,
    );
    expect(find.text('15.00 km/L'), findsNothing);
  });

  testWidgets('TC-06: rechaza campos vacíos', (tester) async {
    await cargarAplicacion(tester);
    await tester.tap(find.text('Calcular rendimiento'));
    await tester.pumpAndSettle();

    expect(
      find.text('Ingresa kilómetros y litros válidos mayores que cero.'),
      findsOneWidget,
    );
  });

  testWidgets('TC-07: rechaza cero y valores negativos', (tester) async {
    await cargarAplicacion(tester);

    await ejecutarCalculo(tester, '0', '20');
    expect(
      find.text('Ingresa kilómetros y litros válidos mayores que cero.'),
      findsOneWidget,
    );

    await ejecutarCalculo(tester, '-50', '20');
    expect(
      find.text('Ingresa kilómetros y litros válidos mayores que cero.'),
      findsOneWidget,
    );
  });

  testWidgets('TC-08: limpiar campos restablece la interfaz', (tester) async {
    await cargarAplicacion(tester);
    await ejecutarCalculo(tester, '300', '20');

    expect(find.text('15.00 km/L'), findsOneWidget);
    expect(find.text('Buen rendimiento'), findsOneWidget);

    await tester.tap(find.text('Limpiar campos'));
    await tester.pumpAndSettle();

    expect(find.text('15.00 km/L'), findsNothing);
    expect(find.text('Buen rendimiento'), findsNothing);
    expect(
      tester.widget<TextField>(find.byType(TextField).at(0)).controller!.text,
      '',
    );
    expect(
      tester.widget<TextField>(find.byType(TextField).at(1)).controller!.text,
      '',
    );
  });
}
