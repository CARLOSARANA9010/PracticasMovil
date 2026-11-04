import 'package:flutter/material.dart';

import '../models/usuario.dart';
import '../services/api.dart';
import 'estados.dart';

/// Ejemplo guiado: lista de usuarios desde /users.
class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  late Future<List<Usuario>> futuro;

  @override
  void initState() {
    super.initState();
    futuro = cargarUsuarios();
  }

  Future<void> _recargar() async {
    setState(() => futuro = cargarUsuarios());
    await futuro.catchError((_) => <Usuario>[]);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Usuarios REST')),
    body: FutureBuilder<List<Usuario>>(
      future: futuro,
      builder: (context, s) => vistaFuture(
        s,
        reintentar: _recargar,
        exito: (usuarios) => RefreshIndicator(
          onRefresh: _recargar,
          child: ListView.builder(
            itemCount: usuarios.length,
            itemBuilder: (_, i) => ListTile(
              leading: CircleAvatar(child: Text('${usuarios[i].id}')),
              title: Text(usuarios[i].nombre),
              subtitle: Text(usuarios[i].correo),
            ),
          ),
        ),
      ),
    ),
  );
}
