import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practica_08_rivera/main.dart';
import 'package:practica_08_rivera/models/punto.dart';
import 'package:practica_08_rivera/screens/puntos_screen.dart';
import 'package:practica_08_rivera/services/ubicacion_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Monta la app y deja terminar las llamadas reales a plugins (fallan en
/// pruebas porque no hay GPS), para que la UI quede en estado estable.
Future<void> abrirApp(WidgetTester tester) async {
  await tester.pumpWidget(const App());
  await tester.runAsync(
    () => Future.delayed(const Duration(milliseconds: 200)),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('Punto se serializa y deserializa igual', () {
    const p = Punto(nombre: 'Casa', lat: 19.4326, lon: -99.1332);
    final r = Punto.fromJson(p.toJson());
    expect([r.nombre, r.lat, r.lon], ['Casa', 19.4326, -99.1332]);
  });

  test('distanceBetween: 1° de longitud en el ecuador ≈ 111.32 km', () {
    final m = distancia(0, 0, 0, 1);
    expect(m, closeTo(111319, 1));
    expect(distancia(19.4326, -99.1332, 19.4326, -99.1332), 0);
    expect(formatearDistancia(m), '111.32 km');
    expect(formatearDistancia(850.4), '850 m');
  });

  test('validaciones de nombre y coordenadas', () {
    expect(validarNombre('  '), 'Escribe un nombre');
    expect(validarNombre('a' * 51), 'Máximo 50 caracteres');
    expect(validarNombre('Parque'), isNull);
    expect(validarCoordenada('abc', 90), 'Número inválido');
    expect(validarCoordenada('91', 90), 'Entre -90.0 y 90.0');
    expect(validarCoordenada('-99,13', 180), isNull);
  });

  test('PuntosService persiste la lista', () async {
    final s = PuntosService();
    await s.guardar(const [Punto(nombre: 'A', lat: 1, lon: 2)]);
    final r = await s.cargar();
    expect(r.single.nombre, 'A');
  });

  testWidgets('sin GPS no se cierra; guarda tres puntos y los muestra', (
    tester,
  ) async {
    await abrirApp(tester);
    // En pruebas no hay plugin nativo: se muestra el error sin excepción.
    expect(find.text('No se pudo obtener la ubicación'), findsOneWidget);

    for (final (nombre, lat, lon) in [
      ('Zócalo', '19.4326', '-99.1332'),
      ('Ángel', '19.4270', '-99.1677'),
      ('Coyoacán', '19.3500', '-99.1620'),
    ]) {
      await tester.tap(find.text('Guardar punto'));
      await tester.pumpAndSettle();
      final campos = find.byType(TextFormField);
      await tester.enterText(campos.at(0), nombre);
      await tester.enterText(campos.at(1), lat);
      await tester.enterText(campos.at(2), lon);
      await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
      await tester.pumpAndSettle();
    }

    expect(find.text('3 punto(s) guardado(s)'), findsOneWidget);
    expect(find.text('Coyoacán'), findsOneWidget);
    expect((await PuntosService().cargar()).length, 3);

    await tester.tap(find.byTooltip('Eliminar Ángel'));
    await tester.pumpAndSettle();
    expect(find.text('2 punto(s) guardado(s)'), findsOneWidget);
  });

  testWidgets('el formulario rechaza datos inválidos', (tester) async {
    await abrirApp(tester);
    await tester.tap(find.text('Guardar punto'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
    await tester.pump();
    expect(find.text('Escribe un nombre'), findsOneWidget);
    expect(find.text('Número inválido'), findsNWidgets(2));
  });
}
