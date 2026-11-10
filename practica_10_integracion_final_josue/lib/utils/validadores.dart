/// Validadores de formulario (null = válido).
String? validarLugar(String? v) {
  final texto = v?.trim() ?? '';
  if (texto.isEmpty) {
    return 'El nombre del lugar es obligatorio';
  }
  if (texto.length < 3) {
    return 'Escribe al menos 3 caracteres';
  }
  return null;
}

String? validarNota(String? v) {
  final texto = v?.trim() ?? '';
  if (texto.isEmpty) {
    return 'Escribe una nota sobre tu visita';
  }
  if (texto.length < 10) {
    return 'La nota debe tener al menos 10 caracteres';
  }
  return null;
}

String? validarCategoria(String? v) {
  if (v == null || v.isEmpty) {
    return 'Selecciona una categoría';
  }
  return null;
}
