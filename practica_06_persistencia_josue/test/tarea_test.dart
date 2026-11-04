import 'package:flutter_test/flutter_test.dart';
import 'package:practica_06_persistencia/models/tarea.dart';

void main() {
  test('Tarea.toMap convierte booleanos a enteros', () {
    const t = Tarea(id: 1, titulo: 'a', completada: true);
    final m = t.toMap();
    expect(m['completada'], 1);
    expect(m['pendiente_sincronizar'], 1);
  });

  test('Tarea.fromMap reconstruye la tarea', () {
    final t = Tarea.fromMap({
      'id': 3,
      'titulo': 'estudiar',
      'descripcion': 'flutter',
      'completada': 0,
      'pendiente_sincronizar': 0,
    });
    expect(t.id, 3);
    expect(t.titulo, 'estudiar');
    expect(t.completada, false);
    expect(t.pendienteSincronizar, false);
  });

  test('copyWith conserva id y cambia solo lo indicado', () {
    const t = Tarea(id: 5, titulo: 'x');
    final c = t.copyWith(completada: true);
    expect(c.id, 5);
    expect(c.titulo, 'x');
    expect(c.completada, true);
  });
}
