import 'package:flutter/material.dart';

/// Construye la vista de carga / error / vacío / éxito de un FutureBuilder.
Widget vistaFuture<T>(
  AsyncSnapshot<List<T>> s, {
  required VoidCallback reintentar,
  required Widget Function(List<T> datos) exito,
}) {
  if (s.connectionState == ConnectionState.waiting) {
    return const Center(child: CircularProgressIndicator());
  }
  if (s.hasError) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 8),
          Text('Error: ${s.error}', textAlign: TextAlign.center),
          const SizedBox(height: 8),
          FilledButton(onPressed: reintentar, child: const Text('Reintentar')),
        ],
      ),
    );
  }
  final datos = s.data ?? [];
  if (datos.isEmpty) {
    return const Center(child: Text('No hay datos para mostrar'));
  }
  return exito(datos);
}
