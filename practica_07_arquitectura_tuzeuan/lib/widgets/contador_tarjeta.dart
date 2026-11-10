import 'package:flutter/material.dart';

class ContadorTarjeta extends StatelessWidget {
  final int valor;

  const ContadorTarjeta({super.key, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            const Icon(Icons.calculate, size: 50, color: Colors.blue),
            const SizedBox(height: 15),
            const Text('Valor actual', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text(
              '$valor',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
