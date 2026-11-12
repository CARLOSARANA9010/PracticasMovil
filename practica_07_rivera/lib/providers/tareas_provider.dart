import 'package:flutter/foundation.dart';

import '../models/tarea.dart';
import '../services/tareas_service.dart';

/// Estado de la pantalla de tareas. La UI solo lee getters y llama métodos;
/// nunca toca el servicio directamente.
class TareasProvider extends ChangeNotifier {
  TareasProvider(this._service);

  final TareasService _service;
  List<Tarea> _tareas = [];
  Filtro _filtro = Filtro.todas;
  bool _cargando = true;

  Filtro get filtro => _filtro;
  bool get cargando => _cargando;
  int get pendientes => _tareas.where((t) => !t.completada).length;

  /// Filtrado aquí y no en build(): el widget recibe la lista ya lista.
  List<Tarea> get visibles => switch (_filtro) {
    Filtro.todas => _tareas,
    Filtro.pendientes => _tareas.where((t) => !t.completada).toList(),
    Filtro.completadas => _tareas.where((t) => t.completada).toList(),
  };

  Future<void> cargar() async {
    _filtro = await _service.leerFiltro();
    _tareas = await _service.cargar();
    _cargando = false;
    notifyListeners();
  }

  static String? validar(String? v) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return 'Escribe un título';
    if (t.length > 100) return 'Máximo 100 caracteres';
    return null;
  }

  Future<void> agregar(String titulo) {
    final id = _tareas.isEmpty
        ? 1
        : _tareas.map((t) => t.id).reduce((a, b) => a > b ? a : b) + 1;
    _tareas = [
      Tarea(id: id, titulo: titulo.trim(), creada: DateTime.now()),
      ..._tareas,
    ];
    return _persistir();
  }

  Future<void> editar(int id, String titulo) =>
      _reemplazar(id, (t) => t.copyWith(titulo: titulo.trim()));

  Future<void> marcar(int id, bool completada) =>
      _reemplazar(id, (t) => t.copyWith(completada: completada));

  Future<void> eliminar(int id) {
    _tareas = _tareas.where((t) => t.id != id).toList();
    return _persistir();
  }

  Future<void> cambiarFiltro(Filtro f) async {
    _filtro = f;
    notifyListeners();
    await _service.guardarFiltro(f);
  }

  Future<void> _reemplazar(int id, Tarea Function(Tarea) cambio) {
    _tareas = [for (final t in _tareas) t.id == id ? cambio(t) : t];
    return _persistir();
  }

  Future<void> _persistir() {
    notifyListeners();
    return _service.guardar(_tareas);
  }
}
