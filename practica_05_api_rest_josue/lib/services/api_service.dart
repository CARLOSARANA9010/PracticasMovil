import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post.dart';
import '../models/usuario.dart';

/// Servicio que concentra las peticiones HTTP a JSONPlaceholder.
class ApiService {
  static const String _base = 'https://jsonplaceholder.typicode.com';

  final http.Client _client;
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Usuario>> obtenerUsuarios() async {
    final r = await _client.get(Uri.parse('$_base/users'));
    if (r.statusCode != 200) {
      throw Exception('HTTP ${r.statusCode}');
    }
    final List datos = jsonDecode(r.body);
    return datos
        .map((e) => Usuario.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Post>> obtenerPosts() async {
    final r = await _client.get(Uri.parse('$_base/posts'));
    if (r.statusCode != 200) {
      throw Exception('HTTP ${r.statusCode}');
    }
    final List datos = jsonDecode(r.body);
    return datos.map((e) => Post.fromJson(e as Map<String, dynamic>)).toList();
  }
}
