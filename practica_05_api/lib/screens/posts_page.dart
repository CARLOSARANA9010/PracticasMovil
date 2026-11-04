import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/api.dart';
import 'estados.dart';
import 'post_detalle_page.dart';
import 'usuarios_page.dart';

/// Ejercicio evaluable: publicaciones desde /posts.
class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  late Future<List<Post>> futuro;

  @override
  void initState() {
    super.initState();
    futuro = cargarPosts();
  }

  Future<void> _recargar() async {
    setState(() => futuro = cargarPosts());
    await futuro.catchError((_) => <Post>[]);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Publicaciones'),
      actions: [
        IconButton(
          tooltip: 'Usuarios (ejemplo guiado)',
          icon: const Icon(Icons.people),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UsuariosPage()),
          ),
        ),
      ],
    ),
    body: FutureBuilder<List<Post>>(
      future: futuro,
      builder: (context, s) => vistaFuture(
        s,
        reintentar: _recargar,
        exito: (posts) => RefreshIndicator(
          onRefresh: _recargar,
          child: ListView.separated(
            itemCount: posts.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (_, i) => ListTile(
              leading: CircleAvatar(child: Text('${posts[i].id}')),
              title: Text(posts[i].titulo),
              subtitle: Text(
                posts[i].cuerpo,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PostDetallePage(post: posts[i]),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
