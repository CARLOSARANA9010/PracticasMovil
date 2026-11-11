import 'package:flutter/foundation.dart';

/// Ejemplo guiado: proveedor de estado sencillo.
class ContadorProvider extends ChangeNotifier {
  int _valor = 0;
  int get valor => _valor;

  void incrementar() {
    _valor++;
    notifyListeners();
  }
}
