import 'package:flutter/material.dart';

class ContadorCard extends StatelessWidget {
  final int valor;
  const ContadorCard({super.key, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
        child: Text('$valor', style: Theme.of(context).textTheme.displayLarge),
      ),
    );
  }
}
