import 'package:flutter/foundation.dart';

import '../models/clima.dart';
import '../services/clima_service.dart';

enum EstadoClima { inicial, cargando, listo, error }

class ClimaProvider extends ChangeNotifier {
  ClimaProvider(this._servicio);

  final ClimaService _servicio;

  EstadoClima _estado = EstadoClima.inicial;
  Clima? _clima;
  String? _error;
  String _etiqueta = '';
  double? _lat;
  double? _lng;
  bool _disposed = false;

  EstadoClima get estado => _estado;
  Clima? get clima => _clima;
  String? get error => _error;
  String get etiqueta => _etiqueta;

  Future<void> cargar(double lat, double lng, {String etiqueta = ''}) async {
    _lat = lat;
    _lng = lng;
    _etiqueta = etiqueta;
    _estado = EstadoClima.cargando;
    _error = null;
    _notificar();
    try {
      _clima = await _servicio.obtener(lat, lng);
      _estado = EstadoClima.listo;
    } on ClimaException catch (e) {
      _error = e.mensaje;
      _estado = EstadoClima.error;
    }
    _notificar();
  }

  Future<void> reintentar() async {
    final lat = _lat;
    final lng = _lng;
    if (lat == null || lng == null) return;
    await cargar(lat, lng, etiqueta: _etiqueta);
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
