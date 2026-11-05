import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/user_service.dart';
import 'user_detail_screen.dart';

class UsersScreen extends StatefulWidget {
  final UserService? userService;

  const UsersScreen({super.key, this.userService});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late final UserService _userService;

  late Future<List<User>> _futureUsers;

  @override
  void initState() {
    super.initState();

    // Utilizar el servicio recibido o crear uno real.
    _userService = widget.userService ?? UserService();

    // Cargar usuarios al iniciar la pantalla.
    _futureUsers = _userService.getUsers();
  }

  // Actualizar la lista de usuarios.
  Future<void> _refreshUsers() async {
    final future = _userService.getUsers();

    setState(() {
      _futureUsers = future;
    });

    try {
      await future;
    } catch (_) {
      // FutureBuilder mostrará el error.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios REST'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Actualizar usuarios',
            icon: const Icon(Icons.refresh),
            onPressed: _refreshUsers,
          ),
        ],
      ),
      body: FutureBuilder<List<User>>(
        future: _futureUsers,
        builder: (context, snapshot) {
          // ESTADO DE CARGA.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ESTADO DE ERROR.
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 65,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No se pudieron cargar los usuarios',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _refreshUsers,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          // ESTADO DE ÉXITO.
          final users = snapshot.data ?? [];

          // ESTADO DE LISTA VACÍA.
          if (users.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refreshUsers,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 200),
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 65,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No hay usuarios disponibles',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          // LISTA DE USUARIOS.
          return RefreshIndicator(
            onRefresh: _refreshUsers,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),

                    // Fotografía del usuario.
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      backgroundImage: NetworkImage(user.image),
                      onBackgroundImageError: (_, _) {},
                    ),

                    // Nombre completo.
                    title: Text(
                      user.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    // Correo electrónico.
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        user.email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),

                    // Navegar al detalle del usuario.
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return UserDetailScreen(user: user);
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
