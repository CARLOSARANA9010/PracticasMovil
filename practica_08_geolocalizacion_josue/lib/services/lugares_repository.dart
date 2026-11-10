import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/lugar.dart';

/// Persistencia local de los lugares guardados (lista JSON en SharedPreferences).
class LugaresRepository {
  static const String _clave = 'lugares_poi';

  Future<List<Lugar>> cargar() async {
    final prefs = await SharedPreferences.getInstance();
    final texto = prefs.getString(_clave);
    if (texto == null) return [];
    try {
      final datos = jsonDecode(texto) as List<dynamic>;
      return datos
          .map((e) => Lugar.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> guardar(List<Lugar> lugares) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _clave,
      jsonEncode(lugares.map((l) => l.toJson()).toList()),
    );
  }
}
