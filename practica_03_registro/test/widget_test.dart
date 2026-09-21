import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practica_03_registro/main.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  tearDown(() {
    // Restaurar el tamaño después de cada prueba.
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.resetPhysicalSize();
    view.resetDevicePixelRatio();
  });

  testWidgets('Muestra errores al enviar el formulario vacío', (
    WidgetTester tester,
  ) async {
    final view = tester.view;
    view.physicalSize = const Size(1200, 900);
    view.devicePixelRatio = 1.0;

    await tester.pumpWidget(const App());

    await tester.tap(find.text('Agregar producto'));
    await tester.pump();

    expect(find.text('El nombre es obligatorio'), findsOneWidget);
    expect(find.text('El precio es obligatorio'), findsOneWidget);
    expect(find.text('La existencia es obligatoria'), findsOneWidget);
  });

  testWidgets('Agrega un producto y calcula su valor de inventario', (
    WidgetTester tester,
  ) async {
    final view = tester.view;
    view.physicalSize = const Size(1200, 900);
    view.devicePixelRatio = 1.0;

    await tester.pumpWidget(const App());

    final campos = find.byType(TextFormField);

    await tester.enterText(campos.at(0), 'Laptop');
    await tester.enterText(campos.at(1), '15000');
    await tester.enterText(campos.at(2), '3');

    await tester.tap(find.text('Agregar producto'));
    await tester.pump();

    expect(find.text('Laptop'), findsOneWidget);
    expect(find.text('\$45000.00'), findsOneWidget);
  });

  testWidgets('Permite eliminar un producto', (WidgetTester tester) async {
    final view = tester.view;
    view.physicalSize = const Size(1200, 900);
    view.devicePixelRatio = 1.0;

    await tester.pumpWidget(const App());

    final campos = find.byType(TextFormField);

    await tester.enterText(campos.at(0), 'Mouse');
    await tester.enterText(campos.at(1), '450');
    await tester.enterText(campos.at(2), '10');

    await tester.tap(find.text('Agregar producto'));
    await tester.pump();

    expect(find.text('Mouse'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump();

    expect(find.text('Mouse'), findsNothing);
  });
}
