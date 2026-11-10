import 'package:flutter_test/flutter_test.dart';
import 'package:practica_10_integracion_final_josue/data/registros_repository.dart';
import 'package:practica_10_integracion_final_josue/models/registro.dart';
import 'package:practica_10_integracion_final_josue/providers/registros_provider.dart';

/// Repositorio en memoria para probar el provider sin SQLite.
class RepoFalso implements RegistrosRepository {
  final List<Registro> datos = [];
  bool falla = false;
  int _siguiente = 1;

  @override
  Future<List<Registro>> listar() async {
    if (falla) throw Exception('fallo');
    return List.of(datos);
  }

  @override
  Future<Registro> insertar(Registro registro) async {
    if (falla) throw Exception('fallo');
    final guardado = registro.copyWith(id: _siguiente++);
    datos.add(guardado);
    return guardado;
  }

  @override
  Future<void> eliminar(int id) async {
    if (falla) throw Exception('fallo');
    datos.removeWhere((r) => r.id == id);
  }
}

Registro _registro(String lugar) => Registro(
  lugar: lugar,
  categoria: 'Otro',
  nota: 'Nota de prueba larga',
  calificacion: 4,
  fecha: DateTime(2026, 11, 9),
);

void main() {
  test('cargar con repositorio vacío deja la lista lista y vacía', () async {
    final p = RegistrosProvider(RepoFalso());
    await p.cargar();
    expect(p.estado, EstadoLista.listo);
    expect(p.registros, isEmpty);
  });

  test('agregar inserta al inicio y asigna id', () async {
    final p = RegistrosProvider(RepoFalso());
    await p.cargar();
    expect(await p.agregar(_registro('Uno')), isTrue);
    expect(await p.agregar(_registro('Dos')), isTrue);
    expect(p.registros.first.lugar, 'Dos');
    expect(p.registros.first.id, 2);
  });

  test('eliminar quita el registro de la lista', () async {
    final repo = RepoFalso();
    final p = RegistrosProvider(repo);
    await p.agregar(_registro('Uno'));
    await p.eliminar(1);
    expect(p.registros, isEmpty);
    expect(repo.datos, isEmpty);
  });

  test('un fallo del repositorio al cargar deja estado de error', () async {
    final repo = RepoFalso()..falla = true;
    final p = RegistrosProvider(repo);
    await p.cargar();
    expect(p.estado, EstadoLista.error);
    expect(p.error, isNotNull);
  });

  test('un fallo al guardar devuelve false y no agrega nada', () async {
    final repo = RepoFalso();
    final p = RegistrosProvider(repo);
    await p.cargar();
    repo.falla = true;
    expect(await p.agregar(_registro('Uno')), isFalse);
    expect(p.registros, isEmpty);
  });
}
