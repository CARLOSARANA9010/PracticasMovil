import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user.dart';

class UserService {
  // Dirección principal de la API.
  static const String _baseUrl = 'https://dummyjson.com';

  // Obtiene la lista de usuarios.
  Future<List<User>> getUsers() async {
    try {
      // Realizar petición HTTP GET.
      final response = await http
          .get(Uri.parse('$_baseUrl/users'))
          .timeout(const Duration(seconds: 15));

      // Validar el código de respuesta HTTP.
      if (response.statusCode != 200) {
        throw Exception(
          'Error del servidor. Código HTTP: ${response.statusCode}',
        );
      }

      // Decodificar la respuesta JSON.
      final Map<String, dynamic> data = jsonDecode(response.body);

      // Obtener el arreglo de usuarios.
      final List<dynamic> usersJson = data['users'];

      // Convertir los elementos JSON en objetos User.
      final users = usersJson.map((json) {
        return User.fromJson(json as Map<String, dynamic>);
      }).toList();

      return users;
    } on TimeoutException {
      throw Exception('La solicitud tardó demasiado. Inténtalo nuevamente.');
    } on http.ClientException {
      throw Exception('No se pudo conectar con el servidor.');
    } on FormatException {
      throw Exception('La respuesta del servidor no es un JSON válido.');
    } on Exception {
      rethrow;
    }
  }
}
