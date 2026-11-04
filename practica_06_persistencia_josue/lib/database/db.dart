import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/tarea.dart';

/// Clase de acceso a SQLite (Parte B del manual + gestor de tareas).
class DB {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    final ruta = join(await getDatabasesPath(), 'practica6.db');
    _db = await openDatabase(
      ruta,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE notas(id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'titulo TEXT, contenido TEXT)',
        );
        await db.execute(
          'CREATE TABLE tareas('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'titulo TEXT NOT NULL, '
          'descripcion TEXT, '
          'completada INTEGER NOT NULL DEFAULT 0, '
          'pendiente_sincronizar INTEGER NOT NULL DEFAULT 1)',
        );
      },
    );
    return _db!;
  }

  // ---------------- Notas (actividad guiada) ----------------

  static Future<int> insertar(String titulo, String contenido) async {
    final db = await database;
    return db.insert('notas', {'titulo': titulo, 'contenido': contenido});
  }

  static Future<List<Map<String, dynamic>>> listar() async {
    final db = await database;
    return db.query('notas', orderBy: 'id DESC');
  }

  static Future<int> actualizar(int id, String titulo, String contenido) async {
    final db = await database;
    return db.update(
      'notas',
      {'titulo': titulo, 'contenido': contenido},
      where: 'id=?',
      whereArgs: [id],
    );
  }

  static Future<int> eliminar(int id) async {
    final db = await database;
    return db.delete('notas', where: 'id=?', whereArgs: [id]);
  }

  // ---------------- Tareas (ejercicio evaluable) ----------------
  // Cada cambio local marca pendiente_sincronizar = 1 (bandera de sincronización).

  static Future<int> insertarTarea(Tarea t) async {
    final db = await database;
    return db.insert('tareas', t.copyWith(pendienteSincronizar: true).toMap());
  }

  /// [filtro]: 'todas', 'pendientes' o 'completadas'.
  static Future<List<Tarea>> listarTareas({String filtro = 'todas'}) async {
    final db = await database;
    String? where;
    if (filtro == 'pendientes') where = 'completada = 0';
    if (filtro == 'completadas') where = 'completada = 1';
    final filas = await db.query('tareas', where: where, orderBy: 'id DESC');
    return filas.map(Tarea.fromMap).toList();
  }

  static Future<int> actualizarTarea(Tarea t) async {
    final db = await database;
    return db.update(
      'tareas',
      t.copyWith(pendienteSincronizar: true).toMap(),
      where: 'id=?',
      whereArgs: [t.id],
    );
  }

  static Future<int> marcarCompletada(int id, bool valor) async {
    final db = await database;
    return db.update(
      'tareas',
      {'completada': valor ? 1 : 0, 'pendiente_sincronizar': 1},
      where: 'id=?',
      whereArgs: [id],
    );
  }

  static Future<int> eliminarTarea(int id) async {
    final db = await database;
    return db.delete('tareas', where: 'id=?', whereArgs: [id]);
  }

  static Future<int> contarPendientesSincronizar() async {
    final db = await database;
    final r = await db.rawQuery(
      'SELECT COUNT(*) AS n FROM tareas WHERE pendiente_sincronizar = 1',
    );
    return (r.first['n'] as int?) ?? 0;
  }
}
