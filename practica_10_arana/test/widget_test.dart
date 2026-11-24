import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practica_10_arana/models/incidencia.dart';
import 'package:practica_10_arana/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('Serialización JSON de Incidencia funciona correctamente', () {
    const original = Incidencia(
      id: '101',
      titulo: 'Falla eléctrica',
      descripcion: 'Luminaria apagada en el acceso principal',
      categoria: 'Servicios Públicos',
      latitud: 20.3667,
      longitud: -90.0500,
      fechaHora: '23/11/2026 12:30',
    );

    final mapa = original.toJson();
    final reconstruida = Incidencia.fromJson(mapa);

    expect(reconstruida.id, original.id);
    expect(reconstruida.titulo, original.titulo);
    expect(reconstruida.latitud, original.latitud);
  });

  testWidgets(
    'HomeScreen muestra estado inicial vacío y botón de nuevo reporte',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Reporte de Incidencias'), findsOneWidget);
      expect(find.text('No hay reportes registrados'), findsOneWidget);
      expect(find.text('Nuevo Reporte'), findsOneWidget);
    },
  );
}
