import 'package:intl/intl.dart';

final DateFormat _formatoFecha = DateFormat('dd/MM/yyyy HH:mm');

String formatearFecha(DateTime fecha) => _formatoFecha.format(fecha);

String formatearCoordenada(double valor) => valor.toStringAsFixed(5);

String formatearTemperatura(double grados) => '${grados.toStringAsFixed(1)} °C';
