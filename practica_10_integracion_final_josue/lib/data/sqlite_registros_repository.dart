import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/registro.dart';
import 'registros_repository.dart';

/// Persistencia local en SQLite: los registros están disponibles sin conexión.
class SqliteRegistrosRepository implements RegistrosRepository {
  static Database? _db;

  Future<Database> get _database async {
    final existente = _db;
    if (existente != null) return existente;
    final ruta = join(await getDatabasesPath(), 'explora_campeche.db');
    final db = await openDatabase(
      ruta,
      version: 1,
      onCreate: (db, version) => db.execute(
        'CREATE TABLE registros('
        'id INTEGER PRIMARY KEY AUTOINCREMENT, '
        'lugar TEXT NOT NULL, '
        'categoria TEXT NOT NULL, '
        'nota TEXT NOT NULL, '
        'calificacion INTEGER NOT NULL, '
        'latitud REAL, '
        'longitud REAL, '
        'fecha TEXT NOT NULL, '
        'foto BLOB, '
        'temperatura REAL)',
      ),
    );
    _db = db;
    return db;
  }

  @override
  Future<List<Registro>> listar() async {
    final db = await _database;
    final filas = await db.query('registros', orderBy: 'fecha DESC');
    return filas.map(Registro.fromMap).toList();
  }

  @override
  Future<Registro> insertar(Registro registro) async {
    final db = await _database;
    final id = await db.insert('registros', registro.toMap());
    return registro.copyWith(id: id);
  }

  @override
  Future<void> eliminar(int id) async {
    final db = await _database;
    await db.delete('registros', where: 'id = ?', whereArgs: [id]);
  }
}
