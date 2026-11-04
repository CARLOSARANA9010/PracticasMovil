import 'package:flutter/material.dart';

import '../models/usuario.dart';
import '../services/api_service.dart';

/// Ejemplo guiado del manual: lista de usuarios con FutureBuilder.
class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final _api = ApiService();
  late Future<List<Usuario>> futuro;

  @override
  void initState() {
    super.initState();
    futuro = _api.obtenerUsuarios();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Usuarios REST')),
    body: FutureBuilder<List<Usuario>>(
      future: futuro,
      builder: (context, s) {
        if (s.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (s.hasError) {
          return Center(child: Text('Error: ${s.error}'));
        }
        final usuarios = s.data ?? [];
        if (usuarios.isEmpty) {
          return const Center(child: Text('No hay usuarios'));
        }
        return RefreshIndicator(
          onRefresh: () async =>
              setState(() => futuro = _api.obtenerUsuarios()),
          child: ListView.builder(
            itemCount: usuarios.length,
            itemBuilder: (_, i) => ListTile(
              leading: CircleAvatar(child: Text('${usuarios[i].id}')),
              title: Text(usuarios[i].nombre),
              subtitle: Text(usuarios[i].correo),
            ),
          ),
        );
      },
    ),
  );
}
