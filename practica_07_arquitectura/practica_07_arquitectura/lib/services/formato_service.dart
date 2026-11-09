import 'package:intl/intl.dart';

class FormatoService {
  static String formatearFecha(DateTime fecha) {
    return DateFormat('yyyy-MM-dd – kk:mm:ss').format(fecha);
  }
}
