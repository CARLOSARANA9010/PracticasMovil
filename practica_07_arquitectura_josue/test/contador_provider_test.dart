import 'package:flutter_test/flutter_test.dart';
import 'package:practica_07_arquitectura_josue/providers/contador_provider.dart';

void main() {
  test('inicia en cero', () {
    expect(ContadorProvider().valor, 0);
  });

  test('incrementar suma 1 y notifica a los oyentes', () {
    final c = ContadorProvider();
    var avisos = 0;
    c.addListener(() => avisos++);
    c.incrementar();
    c.incrementar();
    expect(c.valor, 2);
    expect(avisos, 2);
  });

  test('decrementar no baja de cero', () {
    final c = ContadorProvider();
    c.decrementar();
    expect(c.valor, 0);
    c.incrementar();
    c.decrementar();
    expect(c.valor, 0);
  });

  test('reiniciar regresa a cero', () {
    final c = ContadorProvider();
    c.incrementar();
    c.incrementar();
    c.reiniciar();
    expect(c.valor, 0);
  });
}
