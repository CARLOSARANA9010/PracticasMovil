import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    final ruta = join(await getDatabasesPath(), 'practica06.db');
    _db = await openDatabase(
      ruta,
      version: 1,
      onCreate: (db, version) async {
        // pendiente_sincronizar = 1 marca cambios locales aún no enviados a un servidor.
        await db.execute(
          'CREATE TABLE notas(id INTEGER PRIMARY KEY AUTOINCREMENT, titulo TEXT, contenido TEXT, '
          'pendiente_sincronizar INTEGER NOT NULL DEFAULT 1)',
        );
        await db.execute(
          'CREATE TABLE tareas(id INTEGER PRIMARY KEY AUTOINCREMENT, titulo TEXT NOT NULL, '
          'completada INTEGER NOT NULL DEFAULT 0)',
        );
      },
    );
    return _db!;
  }

  // ---- Notas (ejemplo guiado) ----

  static Future<int> insertar(String titulo, String contenido) async {
    final db = await database;
    return db.insert('notas', {
      'titulo': titulo,
      'contenido': contenido,
      'pendiente_sincronizar': 1,
    });
  }

  static Future<List<Map<String, dynamic>>> listar() async {
    final db = await database;
    return db.query('notas', orderBy: 'id DESC');
  }

  static Future<int> actualizar(int id, String titulo, String contenido) async {
    final db = await database;
    return db.update(
      'notas',
      {'titulo': titulo, 'contenido': contenido, 'pendiente_sincronizar': 1},
      where: 'id=?',
      whereArgs: [id],
    );
  }

  static Future<int> eliminar(int id) async {
    final db = await database;
    return db.delete('notas', where: 'id=?', whereArgs: [id]);
  }

  // ---- Tareas (ejercicio evaluable) ----

  /// [completada]: null = todas, true/false = filtra.
  static Future<List<Map<String, dynamic>>> listarTareas({
    bool? completada,
  }) async {
    final db = await database;
    return db.query(
      'tareas',
      where: completada == null ? null : 'completada=?',
      whereArgs: completada == null ? null : [completada ? 1 : 0],
      orderBy: 'id DESC',
    );
  }

  static Future<int> insertarTarea(String titulo) async {
    final db = await database;
    return db.insert('tareas', {'titulo': titulo, 'completada': 0});
  }

  static Future<int> editarTarea(int id, String titulo) async {
    final db = await database;
    return db.update(
      'tareas',
      {'titulo': titulo},
      where: 'id=?',
      whereArgs: [id],
    );
  }

  static Future<int> marcarTarea(int id, bool completada) async {
    final db = await database;
    return db.update(
      'tareas',
      {'completada': completada ? 1 : 0},
      where: 'id=?',
      whereArgs: [id],
    );
  }

  static Future<int> eliminarTarea(int id) async {
    final db = await database;
    return db.delete('tareas', where: 'id=?', whereArgs: [id]);
  }
}
