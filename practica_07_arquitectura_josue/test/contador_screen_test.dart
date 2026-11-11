import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practica_07_arquitectura_josue/providers/contador_provider.dart';
import 'package:practica_07_arquitectura_josue/screens/contador_screen.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('el contador aumenta al presionar +', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ContadorProvider(),
        child: const MaterialApp(home: ContadorScreen()),
      ),
    );

    expect(find.text('0'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
  });
}
