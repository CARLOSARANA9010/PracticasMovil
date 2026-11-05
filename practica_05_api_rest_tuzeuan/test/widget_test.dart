import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:practica_05_api_rest_tuzeuan/models/user.dart';
import 'package:practica_05_api_rest_tuzeuan/screens/users_screen.dart';
import 'package:practica_05_api_rest_tuzeuan/services/user_service.dart';

// Servicio simulado para las pruebas.
class FakeUserService extends UserService {
  @override
  Future<List<User>> getUsers() async {
    return [];
  }
}

void main() {
  group('Pruebas del modelo User', () {
    test('Debe convertir correctamente un JSON en un usuario', () {
      final json = {
        'id': 1,
        'firstName': 'Emily',
        'lastName': 'Johnson',
        'email': 'emily@example.com',
        'phone': '123-456-7890',
        'image': 'https://example.com/image.jpg',
      };

      final user = User.fromJson(json);

      expect(user.id, 1);
      expect(user.firstName, 'Emily');
      expect(user.lastName, 'Johnson');
      expect(user.email, 'emily@example.com');
      expect(user.phone, '123-456-7890');
      expect(user.image, 'https://example.com/image.jpg');
    });

    test('Debe generar correctamente el nombre completo', () {
      const user = User(
        id: 1,
        firstName: 'Emily',
        lastName: 'Johnson',
        email: 'emily@example.com',
        phone: '123-456-7890',
        image: 'https://example.com/image.jpg',
      );

      expect(user.fullName, 'Emily Johnson');
    });
  });

  group('Pruebas de la pantalla de usuarios', () {
    testWidgets('Debe mostrar un mensaje cuando no hay usuarios', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(home: UsersScreen(userService: FakeUserService())),
      );

      await tester.pumpAndSettle();

      expect(find.text('No hay usuarios disponibles'), findsOneWidget);
    });
  });
}
