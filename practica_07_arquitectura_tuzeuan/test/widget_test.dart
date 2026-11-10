import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:practica_07_arquitectura_tuzeuan/main.dart';
import 'package:practica_07_arquitectura_tuzeuan/providers/contador_provider.dart';

void main() {
  test('El contador inicia en cero', () {
    final contador = ContadorProvider();

    expect(contador.valor, 0);
  });

  test('El contador incrementa correctamente', () {
    final contador = ContadorProvider();

    contador.incrementar();

    expect(contador.valor, 1);
  });

  test('El contador decrementa correctamente', () {
    final contador = ContadorProvider();

    contador.decrementar();

    expect(contador.valor, -1);
  });

  test('El contador se reinicia correctamente', () {
    final contador = ContadorProvider();

    contador.incrementar();
    contador.incrementar();
    contador.reiniciar();

    expect(contador.valor, 0);
  });

  testWidgets('La aplicación carga correctamente', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ContadorProvider(),
        child: const MiAplicacion(),
      ),
    );

    expect(find.text('Administración de estado con Provider'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
  });
}
