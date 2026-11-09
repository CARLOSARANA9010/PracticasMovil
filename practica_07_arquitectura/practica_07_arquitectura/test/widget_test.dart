import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:practica_07_arquitectura/main.dart'; // Ajusta si el nombre de tu paquete es diferente
import 'package:practica_07_arquitectura/providers/contador_provider.dart';

void main() {
  testWidgets('Prueba de renderizado e incremento con Provider', (
    WidgetTester tester,
  ) async {
    // Construir la app inyectando el provider
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ContadorProvider(),
        child: const Practica7App(),
      ),
    );

    // Al inicio, la lista está vacía, así que el '0' solo aparece 1 vez (en el texto principal)
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tocar el botón y disparar el frame
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // Verificamos que el 0 desapareció
    expect(find.text('0'), findsNothing);

    // CORRECCIÓN: Ahora esperamos encontrar exactamente 2 widgets con el texto '1'
    // (El texto principal gigante + El texto dentro de la tarjeta del historial)
    expect(find.text('1'), findsNWidgets(2));
  });
}
