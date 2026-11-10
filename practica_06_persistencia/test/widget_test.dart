import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practica_06_persistencia/database/db.dart';
import 'package:practica_06_persistencia/prefs.dart';
import 'package:practica_06_persistencia/screens/tareas_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfiNoIsolate;
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final db = await DB.database;
    await db.delete('notas');
    await db.delete('tareas');
  });

  test('CRUD de notas y bandera pendiente_sincronizar', () async {
    final id = await DB.insertar('Hola', 'mundo');
    var notas = await DB.listar();
    expect(notas.single['titulo'], 'Hola');
    expect(notas.single['pendiente_sincronizar'], 1);

    await DB.actualizar(id, 'Hola 2', 'editado');
    notas = await DB.listar();
    expect(notas.single['contenido'], 'editado');

    await DB.eliminar(id);
    expect(await DB.listar(), isEmpty);
  });

  test('CRUD de tareas, completar y filtrar', () async {
    final a = await DB.insertarTarea('Estudiar');
    await DB.insertarTarea('Lavar');
    await DB.marcarTarea(a, true);
    await DB.editarTarea(a, 'Estudiar Flutter');

    expect(await DB.listarTareas(), hasLength(2));
    final hechas = await DB.listarTareas(completada: true);
    expect(hechas.single['titulo'], 'Estudiar Flutter');
    expect(await DB.listarTareas(completada: false), hasLength(1));

    await DB.eliminarTarea(a);
    expect(await DB.listarTareas(), hasLength(1));
  });

  test('SharedPreferences: nombre y filtro con valores por defecto', () async {
    expect(await leerNombre(), 'Invitado');
    expect(await leerFiltro(), Filtro.todas);
    await guardarNombre('Carlos');
    await guardarFiltro(Filtro.completadas);
    expect(await leerNombre(), 'Carlos');
    expect(await leerFiltro(), Filtro.completadas);
  });

  testWidgets('valida título vacío y agrega una tarea', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: TareasPage()));
    await tester.tap(find.byTooltip('Agregar'));
    await tester.pump();
    expect(find.text('Escribe un título'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'Comprar pan');
    await tester.runAsync(() async {
      await tester.tap(find.byTooltip('Agregar'));
      await Future<void>.delayed(const Duration(milliseconds: 200));
    });
    await tester.pump();
    expect(find.text('Comprar pan'), findsOneWidget);
    expect(find.text('Escribe un título'), findsNothing);
  });
}
