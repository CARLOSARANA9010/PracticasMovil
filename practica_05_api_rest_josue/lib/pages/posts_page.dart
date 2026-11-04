import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/api_service.dart';
import 'post_detalle_page.dart';

/// Ejercicio evaluable: lista de /posts con carga, error, lista vacía,
/// RefreshIndicator y navegación al detalle.
class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final _api = ApiService();
  late Future<List<Post>> futuro;

  @override
  void initState() {
    super.initState();
    futuro = _api.obtenerPosts();
  }

  Future<void> _recargar() async {
    final nuevo = _api.obtenerPosts();
    setState(() => futuro = nuevo);
    try {
      await nuevo;
    } catch (_) {
      // El error se muestra en el FutureBuilder.
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Publicaciones')),
    body: FutureBuilder<List<Post>>(
      future: futuro,
      builder: (context, s) {
        if (s.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (s.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text('Error: ${s.error}', textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: _recargar,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          );
        }
        final posts = s.data ?? [];
        if (posts.isEmpty) {
          return const Center(child: Text('No hay publicaciones'));
        }
        return RefreshIndicator(
          onRefresh: _recargar,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: posts.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final p = posts[i];
              return ListTile(
                leading: CircleAvatar(child: Text('${p.id}')),
                title: Text(
                  p.titulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  p.cuerpo,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PostDetallePage(post: p)),
                ),
              );
            },
          ),
        );
      },
    ),
  );
}
