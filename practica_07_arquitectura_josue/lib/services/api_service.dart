import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post.dart';

/// Error de negocio con un mensaje listo para mostrar al usuario.
class ApiException implements Exception {
  final String mensaje;
  const ApiException(this.mensaje);

  @override
  String toString() => mensaje;
}

/// Capa de servicios: toda la comunicación HTTP vive aquí, no en las pantallas.
class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const String _base = 'https://jsonplaceholder.typicode.com';

  Future<List<Post>> obtenerPosts() async {
    try {
      final r = await _client
          .get(Uri.parse('$_base/posts'))
          .timeout(const Duration(seconds: 15));
      if (r.statusCode != 200) {
        throw ApiException('El servidor respondió ${r.statusCode}');
      }
      final datos = jsonDecode(r.body) as List<dynamic>;
      return datos
          .map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList();
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw const ApiException('Tiempo de espera agotado');
    } on http.ClientException {
      throw const ApiException('Sin conexión con el servidor');
    } on FormatException {
      throw const ApiException('Respuesta del servidor no válida');
    }
  }
}
