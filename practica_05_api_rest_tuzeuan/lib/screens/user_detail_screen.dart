import 'package:flutter/material.dart';

import '../models/user.dart';

class UserDetailScreen extends StatelessWidget {
  final User user;

  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del usuario'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Fotografía del usuario.
            CircleAvatar(
              radius: 65,
              backgroundColor: Colors.blue.shade100,
              backgroundImage: NetworkImage(user.image),
              onBackgroundImageError: (_, _) {},
            ),

            const SizedBox(height: 20),

            // Nombre completo.
            Text(
              user.fullName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            const Divider(),

            // Identificador.
            ListTile(
              leading: const Icon(Icons.badge, color: Colors.blue),
              title: const Text('Identificador'),
              subtitle: Text('${user.id}'),
            ),

            // Correo electrónico.
            ListTile(
              leading: const Icon(Icons.email, color: Colors.blue),
              title: const Text('Correo electrónico'),
              subtitle: Text(user.email),
            ),

            // Teléfono.
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.blue),
              title: const Text('Teléfono'),
              subtitle: Text(user.phone),
            ),

            const Divider(),
          ],
        ),
      ),
    );
  }
}
