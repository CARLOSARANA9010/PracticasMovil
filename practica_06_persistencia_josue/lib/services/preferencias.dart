import 'package:shared_preferences/shared_preferences.dart';

/// Preferencias simples (Parte A del manual + filtro de tareas).
class Preferencias {
  static const _kNombre = 'nombre_usuario';
  static const _kFiltro = 'filtro_tareas';

  static Future<void> guardarNombre(String nombre) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kNombre, nombre);
  }

  static Future<String> leerNombre() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kNombre) ?? 'Invitado';
  }

  static Future<void> guardarFiltro(String filtro) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kFiltro, filtro);
  }

  static Future<String> leerFiltro() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kFiltro) ?? 'todas';
  }
}
