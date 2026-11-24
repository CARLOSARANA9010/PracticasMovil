import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/incidencia.dart';

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  Future<List<dynamic>> obtenerAvisosRemotos() async {
    final response = await http
        .get(Uri.parse('$_baseUrl?_limit=8'))
        .timeout(const Duration(seconds: 12));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data;
    } else {
      throw Exception('Error del servidor (HTTP ${response.statusCode})');
    }
  }

  Future<bool> sincronizarReporte(Incidencia incidencia) async {
    final response = await http
        .post(
          Uri.parse(_baseUrl),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode(incidencia.toJson()),
        )
        .timeout(const Duration(seconds: 12));

    return response.statusCode == 201 || response.statusCode == 200;
  }
}
