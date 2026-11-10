import 'package:flutter/material.dart';

/// Vista reutilizable para los estados de carga, error y vacío.
class EstadoVista extends StatelessWidget {
  const EstadoVista.cargando({super.key})
    : icono = null,
      mensaje = null,
      onReintentar = null;

  const EstadoVista.vacio({super.key, required this.mensaje})
    : icono = Icons.inbox_outlined,
      onReintentar = null;

  const EstadoVista.error({
    super.key,
    required this.mensaje,
    required this.onReintentar,
  }) : icono = Icons.error_outline;

  final IconData? icono;
  final String? mensaje;
  final VoidCallback? onReintentar;

  @override
  Widget build(BuildContext context) {
    if (icono == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, size: 48),
            const SizedBox(height: 12),
            Text(mensaje ?? '', textAlign: TextAlign.center),
            if (onReintentar != null) ...[
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: onReintentar,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
