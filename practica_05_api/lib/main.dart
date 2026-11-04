import 'package:flutter/material.dart';

import 'screens/posts_page.dart';

void main() => runApp(
  MaterialApp(
    title: 'Práctica 05 API REST',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(colorSchemeSeed: Colors.indigo),
    home: const PostsPage(),
  ),
);
