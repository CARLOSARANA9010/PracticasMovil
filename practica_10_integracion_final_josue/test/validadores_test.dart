import 'package:flutter_test/flutter_test.dart';
import 'package:practica_10_integracion_final_josue/utils/validadores.dart';

void main() {
  test('lugar obligatorio y de al menos 3 caracteres', () {
    expect(validarLugar(null), isNotNull);
    expect(validarLugar('  '), isNotNull);
    expect(validarLugar('ab'), isNotNull);
    expect(validarLugar('Edzná'), isNull);
  });

  test('nota obligatoria y de al menos 10 caracteres', () {
    expect(validarNota(''), isNotNull);
    expect(validarNota('corta'), isNotNull);
    expect(validarNota('Una nota suficientemente larga'), isNull);
  });

  test('categoría obligatoria', () {
    expect(validarCategoria(null), isNotNull);
    expect(validarCategoria(''), isNotNull);
    expect(validarCategoria('Playa'), isNull);
  });
}
