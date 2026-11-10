/// Validadores de formulario (devuelven null cuando el valor es válido).
String? validarNombre(String? v) {
  if (v == null || v.trim().isEmpty) return 'El nombre es obligatorio';
  if (v.trim().length < 3) return 'Escribe al menos 3 caracteres';
  return null;
}

String? validarLatitud(String? v) {
  final n = double.tryParse((v ?? '').trim().replaceAll(',', '.'));
  if (n == null) return 'Número no válido';
  if (n < -90 || n > 90) return 'La latitud va de -90 a 90';
  return null;
}

String? validarLongitud(String? v) {
  final n = double.tryParse((v ?? '').trim().replaceAll(',', '.'));
  if (n == null) return 'Número no válido';
  if (n < -180 || n > 180) return 'La longitud va de -180 a 180';
  return null;
}

double parseCoordenada(String v) => double.parse(v.trim().replaceAll(',', '.'));
