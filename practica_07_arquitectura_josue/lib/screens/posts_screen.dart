import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/posts_provider.dart';
import '../widgets/actualizacion_banner.dart';
import '../widgets/estado_vista.dart';
import '../widgets/post_card.dart';

/// Refactorización de la práctica 5: la pantalla solo dibuja el estado.
class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<PostsProvider>();
    final cargando = p.estado == EstadoCarga.cargando;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Publicaciones'),
        actions: [
          IconButton(
            tooltip: 'Actualizar',
            onPressed: cargando
                ? null
                : () => context.read<PostsProvider>().cargar(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: switch (p.estado) {
        EstadoCarga.inicial ||
        EstadoCarga.cargando => const EstadoVista.cargando(),
        EstadoCarga.error => EstadoVista.error(
          mensaje: p.error ?? 'Error desconocido',
          onReintentar: () => context.read<PostsProvider>().cargar(),
        ),
        EstadoCarga.listo =>
          p.posts.isEmpty
              ? const EstadoVista.vacio(mensaje: 'No hay publicaciones')
              : Column(
                  children: [
                    if (p.actualizado != null)
                      ActualizacionBanner(fecha: p.actualizado!),
                    Expanded(
                      child: ListView.builder(
                        itemCount: p.posts.length,
                        itemBuilder: (context, i) => PostCard(post: p.posts[i]),
                      ),
                    ),
                  ],
                ),
      },
    );
  }
}
