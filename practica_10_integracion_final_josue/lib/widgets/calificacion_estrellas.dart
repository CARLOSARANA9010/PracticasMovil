import 'package:flutter/material.dart';

class CalificacionEstrellas extends StatelessWidget {
  final int valor;
  const CalificacionEstrellas({super.key, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 1; i <= 5; i++)
          Icon(
            i <= valor ? Icons.star : Icons.star_border,
            size: 18,
            color: Colors.amber,
          ),
      ],
    );
  }
}
