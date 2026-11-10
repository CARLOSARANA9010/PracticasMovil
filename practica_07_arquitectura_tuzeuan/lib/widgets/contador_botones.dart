import 'package:flutter/material.dart';

class ContadorBotones extends StatelessWidget {
  final VoidCallback incrementar;
  final VoidCallback decrementar;
  final VoidCallback reiniciar;

  const ContadorBotones({
    super.key,
    required this.incrementar,
    required this.decrementar,
    required this.reiniciar,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: [
        ElevatedButton.icon(
          onPressed: decrementar,
          icon: const Icon(Icons.remove),
          label: const Text('Restar'),
        ),
        ElevatedButton.icon(
          onPressed: incrementar,
          icon: const Icon(Icons.add),
          label: const Text('Sumar'),
        ),
        OutlinedButton.icon(
          onPressed: reiniciar,
          icon: const Icon(Icons.refresh),
          label: const Text('Reiniciar'),
        ),
      ],
    );
  }
}
