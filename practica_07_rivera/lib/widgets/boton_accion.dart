import 'package:flutter/material.dart';

/// Botón con icono y texto, usado en el contador y en los diálogos.
class BotonAccion extends StatelessWidget {
  const BotonAccion({
    super.key,
    required this.icono,
    required this.texto,
    required this.onPressed,
  });

  final IconData icono;
  final String texto;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icono),
      label: Text(texto),
    );
  }
}
