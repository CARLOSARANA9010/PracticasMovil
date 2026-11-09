import 'package:flutter/foundation.dart';
import '../models/registro.dart';

class ContadorProvider extends ChangeNotifier {
  int _valor = 0;
  final List<Registro> _historial = [];

  int get valor => _valor;
  List<Registro> get historial => _historial;

  void incrementar() {
    _valor++;
    _historial.insert(0, Registro(valor: _valor, fecha: DateTime.now()));
    notifyListeners();
  }
}
