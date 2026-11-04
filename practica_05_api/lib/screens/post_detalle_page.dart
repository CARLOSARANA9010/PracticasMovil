import 'package:flutter/material.dart';

import '../models/post.dart';

class PostDetallePage extends StatelessWidget {
  final Post post;
  const PostDetallePage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text('Publicación #${post.id}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(post.titulo, style: t.headlineSmall),
          const SizedBox(height: 8),
          Text('Usuario: ${post.userId}', style: t.labelMedium),
          const Divider(height: 24),
          Text(post.cuerpo, style: t.bodyLarge),
        ],
      ),
    );
  }
}
