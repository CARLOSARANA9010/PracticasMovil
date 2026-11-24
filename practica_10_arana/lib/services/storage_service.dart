import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/incidencia.dart';

class StorageService {
  static const String _keyReportes = 'reportes_incidencias_v1';

  Future<List<Incidencia>> obtenerReportes() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyReportes);
    if (raw == null || raw.isEmpty) return [];

    final List<dynamic> lista = jsonDecode(raw) as List<dynamic>;
    return lista
        .map((item) => Incidencia.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> guardarReporte(Incidencia nuevo) async {
    final reportes = await obtenerReportes();
    reportes.insert(0, nuevo);
    await _persistir(reportes);
  }

  Future<void> eliminarReporte(String id) async {
    final reportes = await obtenerReportes();
    reportes.removeWhere((item) => item.id == id);
    await _persistir(reportes);
  }

  Future<void> _persistir(List<Incidencia> reportes) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(reportes.map((e) => e.toJson()).toList());
    await prefs.setString(_keyReportes, encoded);
  }
}
