import 'package:flutter_test/flutter_test.dart';
import 'package:practica_08_geolocalizacion/main.dart';

void main() {
  testWidgets('La aplicación muestra la pantalla de ubicación', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MiAplicacion());

    expect(find.text('Mi ubicación'), findsOneWidget);
    expect(find.text('Sin ubicación'), findsOneWidget);
    expect(find.text('Obtener ubicación'), findsOneWidget);
    expect(find.text('Abrir en mapa'), findsOneWidget);
  });
}
