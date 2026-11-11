import 'package:flutter/foundation.dart';

/// Proveedor de estado sencillo del ejemplo guiado del manual.
class ContadorProvider extends ChangeNotifier {
  int _valor = 0;
  int get valor => _valor;

  void incrementar() {
    _valor++;
    notifyListeners();
  }

  void decrementar() {
    if (_valor == 0) return;
    _valor--;
    notifyListeners();
  }

  void reiniciar() {
    if (_valor == 0) return;
    _valor = 0;
    notifyListeners();
  }
}
