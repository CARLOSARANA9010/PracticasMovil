import 'package:flutter/material.dart';

class Encabezado extends StatelessWidget {
  final String texto;
  const Encabezado({super.key, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Text(texto, style: Theme.of(context).textTheme.titleLarge);
  }
}
