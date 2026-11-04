import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: PostsPage()),
  );
}

// 1. Modelo de Datos para los Posts
class Post {
  final int id;
  final String title;
  final String body;

  Post({required this.id, required this.title, required this.body});

  factory Post.fromJson(Map<String, dynamic> json) =>
      Post(id: json['id'], title: json['title'], body: json['body']);
}

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  late Future<List<Post>> futuroPosts;

  @override
  void initState() {
    super.initState();
    futuroPosts = cargarPosts();
  }

  // 2. Consumo de la API con validación HTTP
  Future<List<Post>> cargarPosts() async {
    final respuesta = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    );
    if (respuesta.statusCode != 200) {
      throw Exception('Error HTTP: ${respuesta.statusCode}');
    }
    final List datos = jsonDecode(respuesta.body);
    return datos.map((e) => Post.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Publicaciones REST')),
      body: FutureBuilder<List<Post>>(
        future: futuroPosts,
        builder: (context, snapshot) {
          // 3. Estado de Carga
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 4. Manejo de Errores (Sin internet o error HTTP) con diseño visual amigable
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.signal_wifi_off_rounded,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Sin conexión a Internet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Verifica tu red e intenta nuevamente para cargar las publicaciones.',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          futuroPosts = cargarPosts();
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          final posts = snapshot.data ?? [];
          if (posts.isEmpty) {
            return const Center(child: Text('Lista vacía.'));
          }

          // 5. Lista con RefreshIndicator y navegación
          return RefreshIndicator(
            onRefresh: () async => setState(() => futuroPosts = cargarPosts()),
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return ListTile(
                  leading: CircleAvatar(child: Text('${post.id}')),
                  title: Text(
                    post.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    post.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostDetailPage(post: post),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// 6. Pantalla de Detalle requerida
class PostDetailPage extends StatelessWidget {
  final Post post;
  const PostDetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalle #${post.id}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(post.body, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
