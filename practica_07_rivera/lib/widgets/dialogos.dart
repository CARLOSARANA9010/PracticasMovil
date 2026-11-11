import 'package:flutter/material.dart';

/// Diálogos reutilizables: antes estaban copiados en cada pantalla.
Future<bool> confirmar(
  BuildContext context,
  String titulo,
  String mensaje,
) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(titulo),
      content: Text(mensaje),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(c, true),
          child: const Text('Aceptar'),
        ),
      ],
    ),
  );
  return ok ?? false;
}

Future<String?> pedirTexto(
  BuildContext context, {
  required String titulo,
  String inicial = '',
  FormFieldValidator<String>? validator,
}) async {
  final key = GlobalKey<FormState>();
  final ctrl = TextEditingController(text: inicial);
  final res = await showDialog<String>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(titulo),
      content: Form(
        key: key,
        child: TextFormField(
          controller: ctrl,
          autofocus: true,
          validator: validator,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            if (key.currentState!.validate()) {
              Navigator.pop(c, ctrl.text.trim());
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    ),
  );
  ctrl.dispose();
  return res;
}
