import 'package:flutter_test/flutter_test.dart';
import 'package:practica06_persistencia/main.dart';
import 'package:practica06_persistencia/models/nota.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('La nota conserva sus datos al convertirla a Map', () {
    final nota = Nota(
      id: 1,
      titulo: 'Practica 06',
      contenido: 'Probar persistencia local',
      completada: true,
      pendienteSincronizar: true,
    );

    final mapa = nota.toMap();
    final notaConvertida = Nota.fromMap(mapa);

    expect(notaConvertida.id, 1);
    expect(notaConvertida.titulo, 'Practica 06');
    expect(notaConvertida.contenido, 'Probar persistencia local');
    expect(notaConvertida.completada, true);
    expect(notaConvertida.pendienteSincronizar, true);
  });

  test('La aplicacion tiene el titulo correcto', () {
    const app = MiAplicacion();

    expect(app, isA<MiAplicacion>());
  });
}
