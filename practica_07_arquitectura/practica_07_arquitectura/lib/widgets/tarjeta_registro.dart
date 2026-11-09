import 'package:flutter/material.dart';
import '../models/registro.dart';
import '../services/formato_service.dart';

class TarjetaRegistro extends StatelessWidget {
  final Registro registro;

  const TarjetaRegistro({super.key, required this.registro});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: ListTile(
        leading: CircleAvatar(child: Text('${registro.valor}')),
        title: const Text('Clic registrado'),
        subtitle: Text(FormatoService.formatearFecha(registro.fecha)),
      ),
    );
  }
}
