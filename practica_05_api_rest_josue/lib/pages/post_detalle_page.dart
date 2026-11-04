import 'package:flutter/material.dart';

import '../models/post.dart';

class PostDetallePage extends StatelessWidget {
  final Post post;
  const PostDetallePage({super.key, required this.post});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Publicación #${post.id}')),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.titulo, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Usuario: ${post.userId}',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const Divider(height: 24),
            Text(post.cuerpo, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    ),
  );
}
