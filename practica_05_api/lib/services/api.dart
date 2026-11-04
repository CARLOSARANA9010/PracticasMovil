import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post.dart';
import '../models/usuario.dart';

const _base = 'https://jsonplaceholder.typicode.com';

/// Cliente HTTP compartido; las pruebas lo reemplazan por un MockClient.
http.Client cliente = http.Client();

Future<List<dynamic>> _getLista(String ruta) async {
  final r = await cliente
      .get(Uri.parse('$_base$ruta'))
      .timeout(const Duration(seconds: 10));
  if (r.statusCode != 200) {
    throw Exception('HTTP ${r.statusCode}');
  }
  return jsonDecode(r.body) as List<dynamic>;
}

Future<List<Usuario>> cargarUsuarios() async =>
    (await _getLista('/users')).map((e) => Usuario.fromJson(e)).toList();

Future<List<Post>> cargarPosts() async =>
    (await _getLista('/posts')).map((e) => Post.fromJson(e)).toList();
