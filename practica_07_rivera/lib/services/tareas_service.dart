import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/tarea.dart';

/// Único punto que sabe dónde y cómo se guardan los datos.
/// Cambiar a SQLite o a una API REST solo toca esta clase.
class TareasService {
  static const _kTareas = 'tareas';
  static const _kFiltro = 'filtro_tareas';

  Future<List<Tarea>> cargar() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kTareas);
    if (raw == null) return [];
    return (jsonDecode(raw) as List)
        .map((e) => Tarea.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> guardar(List<Tarea> tareas) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _kTareas,
      jsonEncode(tareas.map((t) => t.toJson()).toList()),
    );
  }

  Future<Filtro> leerFiltro() async {
    final prefs = await SharedPreferences.getInstance();
    return Filtro.values.asNameMap()[prefs.getString(_kFiltro)] ?? Filtro.todas;
  }

  Future<void> guardarFiltro(Filtro filtro) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kFiltro, filtro.name);
  }
}
