
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import '../models/nota.dart';

class DB {
  static Database? _database;

  static const String nombreBD = 'notas.db';
  static const int versionBD = 1;
  static const String tablaNotas = 'notas';

  // Obtener la instancia de la base de datos.
  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _inicializarBD();
    return _database!;
  }

  // Inicializar SQLite según la plataforma.
  static Future<Database> _inicializarBD() async {
    if (kIsWeb) {
      // Implementación SQLite para Flutter Web.
      return await databaseFactoryFfiWeb.openDatabase(
        nombreBD,
        options: OpenDatabaseOptions(
          version: versionBD,
          onCreate: (db, version) async {
            await _crearTabla(db);
          },
        ),
      );
    } else {
      // Implementación SQLite para Android e iOS.
      final ruta = await getDatabasesPath();
      final path = '$ruta/$nombreBD';

      return await openDatabase(
        path,
        version: versionBD,
        onCreate: (db, version) async {
          await _crearTabla(db);
        },
      );
    }
  }

  // Crear tabla de notas.
  static Future<void> _crearTabla(Database db) async {
    await db.execute('''
      CREATE TABLE $tablaNotas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        contenido TEXT NOT NULL,
        completada INTEGER NOT NULL DEFAULT 0,
        pendiente_sincronizar INTEGER NOT NULL DEFAULT 1
      )
    ''');
  }

  // INSERTAR una nota.
  static Future<int> insertar(Nota nota) async {
    final db = await database;

    final datos = nota.toMap();

    // El ID se genera automáticamente.
    datos.remove('id');

    return await db.insert(
      tablaNotas,
      datos,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // LISTAR todas las notas.
  static Future<List<Nota>> listar() async {
    final db = await database;

    final resultado = await db.query(
      tablaNotas,
      orderBy: 'id DESC',
    );

    return resultado.map((mapa) => Nota.fromMap(mapa)).toList();
  }

  // ACTUALIZAR una nota.
  static Future<int> actualizar(Nota nota) async {
    final db = await database;

    return await db.update(
      tablaNotas,
      {
        'titulo': nota.titulo,
        'contenido': nota.contenido,
        'completada': nota.completada ? 1 : 0,
        'pendiente_sincronizar': 1,
      },
      where: 'id = ?',
      whereArgs: [nota.id],
    );
  }

  // ELIMINAR una nota.
  static Future<int> eliminar(int id) async {
    final db = await database;

    return await db.delete(
      tablaNotas,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // CAMBIAR el estado de una nota.
  static Future<int> cambiarEstado(
    int id,
    bool completada,
  ) async {
    final db = await database;

    return await db.update(
      tablaNotas,
      {
        'completada': completada ? 1 : 0,
        'pendiente_sincronizar': 1,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // CONTAR notas pendientes de sincronización.
  static Future<int> contarPendientes() async {
    final db = await database;

    final resultado = await db.rawQuery('''
      SELECT COUNT(*) AS total
      FROM $tablaNotas
      WHERE pendiente_sincronizar = 1
    ''');

    return Sqflite.firstIntValue(resultado) ?? 0;
  }

  // CERRAR la base de datos.
  static Future<void> cerrar() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
