import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/nota.dart';

class DB {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;

    final ruta = join(await getDatabasesPath(), 'notas.db');

    _db = await openDatabase(
      ruta,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notas(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT NOT NULL,
            contenido TEXT NOT NULL,
            completada INTEGER NOT NULL DEFAULT 0,
            pendiente_sincronizar INTEGER NOT NULL DEFAULT 1
          )
        ''');
      },
    );

    return _db!;
  }

  // INSERTAR
  static Future<int> insertar(Nota nota) async {
    final db = await database;

    return db.insert('notas', nota.toMap()..remove('id'));
  }

  // LISTAR
  static Future<List<Nota>> listar() async {
    final db = await database;

    final resultado = await db.query('notas', orderBy: 'id DESC');

    return resultado.map((map) => Nota.fromMap(map)).toList();
  }

  // ACTUALIZAR
  static Future<int> actualizar(Nota nota) async {
    final db = await database;

    return db.update(
      'notas',
      {...nota.toMap(), 'pendiente_sincronizar': 1},
      where: 'id = ?',
      whereArgs: [nota.id],
    );
  }

  // ELIMINAR
  static Future<int> eliminar(int id) async {
    final db = await database;

    return db.delete('notas', where: 'id = ?', whereArgs: [id]);
  }

  // CAMBIAR ESTADO DE COMPLETADA
  static Future<int> cambiarEstado(Nota nota) async {
    final db = await database;

    return db.update(
      'notas',
      {'completada': nota.completada ? 1 : 0, 'pendiente_sincronizar': 1},
      where: 'id = ?',
      whereArgs: [nota.id],
    );
  }

  // CONTAR NOTAS PENDIENTES DE SINCRONIZAR
  static Future<int> contarPendientes() async {
    final db = await database;

    final resultado = await db.rawQuery(
      'SELECT COUNT(*) AS total FROM notas '
      'WHERE pendiente_sincronizar = 1',
    );

    return Sqflite.firstIntValue(resultado) ?? 0;
  }
}
