import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practica_07_rivera/main.dart';
import 'package:practica_07_rivera/models/tarea.dart';
import 'package:practica_07_rivera/providers/contador_provider.dart';
import 'package:practica_07_rivera/providers/tareas_provider.dart';
import 'package:practica_07_rivera/services/tareas_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('ContadorProvider incrementa y notifica', () {
    final c = ContadorProvider();
    var avisos = 0;
    c.addListener(() => avisos++);
    c.incrementar();
    expect(c.valor, 1);
    expect(avisos, 1);
  });

  test('Tarea se serializa y deserializa igual', () {
    final t = Tarea(id: 3, titulo: 'x', creada: DateTime(2026, 11, 11));
    final r = Tarea.fromJson(t.toJson());
    expect([r.id, r.titulo, r.creada, r.completada], [3, 'x', t.creada, false]);
  });

  test('TareasProvider: CRUD, filtro y persistencia', () async {
    final p = TareasProvider(TareasService());
    await p.cargar();
    await p.agregar('Estudiar');
    await p.agregar('Lavar');
    final estudiar = p.visibles.last;
    await p.marcar(estudiar.id, true);
    await p.editar(estudiar.id, 'Estudiar Flutter');
    expect(p.pendientes, 1);

    await p.cambiarFiltro(Filtro.completadas);
    expect(p.visibles.single.titulo, 'Estudiar Flutter');

    // Un provider nuevo lee lo guardado: tareas y filtro sobreviven.
    final otro = TareasProvider(TareasService());
    await otro.cargar();
    expect(otro.filtro, Filtro.completadas);
    expect(otro.visibles.single.titulo, 'Estudiar Flutter');

    await otro.eliminar(estudiar.id);
    await otro.cambiarFiltro(Filtro.todas);
    expect(otro.visibles.single.titulo, 'Lavar');
  });

  test('validar rechaza vacío y textos largos', () {
    expect(TareasProvider.validar('  '), 'Escribe un título');
    expect(TareasProvider.validar('a' * 101), 'Máximo 100 caracteres');
    expect(TareasProvider.validar('ok'), isNull);
  });

  testWidgets('valida, agrega una tarea y abre el contador', (tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Agregar'));
    await tester.pump();
    expect(find.text('Escribe un título'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'Comprar pan');
    await tester.tap(find.byTooltip('Agregar'));
    await tester.pumpAndSettle();
    expect(find.text('Comprar pan'), findsOneWidget);
    expect(find.text('1 pendiente(s)'), findsOneWidget);

    await tester.tap(find.byTooltip('Contador (ejemplo guiado)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Incrementar'));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
  });
}
