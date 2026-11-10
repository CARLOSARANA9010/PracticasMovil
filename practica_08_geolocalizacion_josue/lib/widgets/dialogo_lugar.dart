import 'package:flutter/material.dart';

import '../models/lugar.dart';
import '../utils/validadores.dart';

/// Diálogo para guardar un lugar. Las coordenadas se precargan con la ubicación
/// actual y pueden editarse (así se pueden registrar lugares distintos al actual).
class DialogoLugar extends StatefulWidget {
  final double? latitudInicial;
  final double? longitudInicial;

  const DialogoLugar({super.key, this.latitudInicial, this.longitudInicial});

  @override
  State<DialogoLugar> createState() => _DialogoLugarState();
}

class _DialogoLugarState extends State<DialogoLugar> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombre;
  late final TextEditingController _lat;
  late final TextEditingController _lng;

  @override
  void initState() {
    super.initState();
    _nombre = TextEditingController();
    _lat = TextEditingController(
      text: widget.latitudInicial?.toStringAsFixed(6) ?? '',
    );
    _lng = TextEditingController(
      text: widget.longitudInicial?.toStringAsFixed(6) ?? '',
    );
  }

  @override
  void dispose() {
    _nombre.dispose();
    _lat.dispose();
    _lng.dispose();
    super.dispose();
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      Lugar(
        nombre: _nombre.text.trim(),
        latitud: parseCoordenada(_lat.text),
        longitud: parseCoordenada(_lng.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nuevo lugar'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nombre,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: validarNombre,
              ),
              TextFormField(
                controller: _lat,
                decoration: const InputDecoration(labelText: 'Latitud'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                validator: validarLatitud,
              ),
              TextFormField(
                controller: _lng,
                decoration: const InputDecoration(labelText: 'Longitud'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                validator: validarLongitud,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(onPressed: _guardar, child: const Text('Guardar')),
      ],
    );
  }
}
