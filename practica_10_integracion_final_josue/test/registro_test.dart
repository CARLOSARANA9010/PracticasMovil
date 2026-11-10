import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:practica_10_integracion_final_josue/models/registro.dart';

void main() {
  final base = Registro(
    id: 4,
    lugar: 'Baluarte de la Soledad',
    categoria: 'Historia',
    nota: 'Visita guiada por las murallas',
    calificacion: 5,
    latitud: 19.8441,
    longitud: -90.5387,
    fecha: DateTime(2026, 11, 9, 10, 30),
    foto: Uint8List.fromList([1, 2, 3]),
    temperatura: 29.5,
  );

  test('toMap y fromMap son inversos', () {
    final copia = Registro.fromMap(base.toMap());
    expect(copia.id, 4);
    expect(copia.lugar, 'Baluarte de la Soledad');
    expect(copia.calificacion, 5);
    expect(copia.latitud, 19.8441);
    expect(copia.fecha, DateTime(2026, 11, 9, 10, 30));
    expect(copia.foto, [1, 2, 3]);
    expect(copia.temperatura, 29.5);
  });

  test('las coordenadas y la foto pueden ser nulas', () {
    final r = Registro(
      lugar: 'Museo',
      categoria: 'Museo',
      nota: 'Sin ubicación guardada',
      calificacion: 3,
      fecha: DateTime(2026, 1, 1),
    );
    final copia = Registro.fromMap(r.toMap());
    expect(copia.tieneUbicacion, isFalse);
    expect(copia.foto, isNull);
    expect(copia.id, isNull);
  });

  test('toMap omite el id cuando es nulo (lo asigna SQLite)', () {
    final r = Registro(
      lugar: 'x',
      categoria: 'Otro',
      nota: 'nota de prueba',
      calificacion: 1,
      fecha: DateTime(2026, 1, 1),
    );
    expect(r.toMap().containsKey('id'), isFalse);
  });

  test('copyWith asigna el id y conserva lo demás', () {
    final r = base.copyWith(id: 99);
    expect(r.id, 99);
    expect(r.lugar, base.lugar);
  });
}
