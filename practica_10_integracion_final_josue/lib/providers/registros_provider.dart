import 'package:flutter/foundation.dart';

import '../data/registros_repository.dart';
import '../models/registro.dart';

enum EstadoLista { inicial, cargando, listo, error }

class RegistrosProvider extends ChangeNotifier {
  RegistrosProvider(this._repo);

  final RegistrosRepository _repo;

  EstadoLista _estado = EstadoLista.inicial;
  List<Registro> _registros = const [];
  String? _error;
  bool _disposed = false;

  EstadoLista get estado => _estado;
  List<Registro> get registros => _registros;
  String? get error => _error;

  Future<void> cargar() async {
    _estado = EstadoLista.cargando;
    _error = null;
    _notificar();
    try {
      _registros = await _repo.listar();
      _estado = EstadoLista.listo;
    } catch (_) {
      _error = 'No se pudieron leer los registros guardados';
      _estado = EstadoLista.error;
    }
    _notificar();
  }

  /// Devuelve true si el registro quedó guardado.
  Future<bool> agregar(Registro registro) async {
    try {
      final guardado = await _repo.insertar(registro);
      _registros = [guardado, ..._registros];
      _estado = EstadoLista.listo;
      _error = null;
      _notificar();
      return true;
    } catch (_) {
      _error = 'No se pudo guardar el registro';
      _notificar();
      return false;
    }
  }

  Future<void> eliminar(int id) async {
    try {
      await _repo.eliminar(id);
      _registros = _registros.where((r) => r.id != id).toList();
      _notificar();
    } catch (_) {
      _error = 'No se pudo eliminar el registro';
      _notificar();
    }
  }

  void _notificar() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
