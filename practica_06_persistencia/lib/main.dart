import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'screens/tareas_page.dart';

void main() {
  // sqflite no tiene implementación web: en navegador se usa SQLite wasm (web/sqlite3.wasm) guardado en IndexedDB.
  if (kIsWeb) databaseFactory = databaseFactoryFfiWebNoWebWorker;
  runApp(
    MaterialApp(
      title: 'Práctica 06 Persistencia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.teal),
      home: const TareasPage(),
    ),
  );
}
