import 'dart:io';
import 'package:flutter/material.dart';
import '../models/incidencia.dart';
import '../services/hardware_service.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloCtrl = TextEditingController();
  final _descripcionCtrl = TextEditingController();

  final _hardwareService = HardwareService();
  final _storageService = StorageService();

  static const List<String> _categorias = [
    'Infraestructura',
    'Servicios Públicos',
    'Seguridad',
    'Medio Ambiente',
    'Tecnología / Red',
  ];

  String _categoriaSeleccionada = _categorias.first;
  String? _fotoPath;
  double? _latitud;
  double? _longitud;
  bool _obteniendoGps = false;
  bool _guardando = false;

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _descripcionCtrl.dispose();
    super.dispose();
  }

  Future<void> _capturarFoto() async {
    try {
      final path = await _hardwareService.tomarFotografia();
      if (path != null && mounted) {
        setState(() => _fotoPath = path);
      }
    } catch (e) {
      _mostrarMensaje('No se pudo abrir la cámara: $e');
    }
  }

  Future<void> _obtenerUbicacion() async {
    setState(() => _obteniendoGps = true);
    try {
      final pos = await _hardwareService.obtenerUbicacionActual();
      if (!mounted) return;
      setState(() {
        _latitud = pos.latitude;
        _longitud = pos.longitude;
      });
      _mostrarMensaje('Ubicación capturada correctamente.');
    } catch (e) {
      _mostrarMensaje(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _obteniendoGps = false);
    }
  }

  String _formatearFechaActual() {
    final now = DateTime.now();
    String dosDigitos(int n) => n.toString().padLeft(2, '0');
    return '${dosDigitos(now.day)}/${dosDigitos(now.month)}/${now.year} '
        '${dosDigitos(now.hour)}:${dosDigitos(now.minute)}';
  }

  Future<void> _guardarIncidencia() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);
    try {
      final nueva = Incidencia(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        titulo: _tituloCtrl.text.trim(),
        descripcion: _descripcionCtrl.text.trim(),
        categoria: _categoriaSeleccionada,
        fotoPath: _fotoPath,
        latitud: _latitud,
        longitud: _longitud,
        fechaHora: _formatearFechaActual(),
      );

      await _storageService.guardarReporte(nueva);

      await Notificaciones.mostrar(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        titulo: 'Reporte guardado (${nueva.categoria})',
        cuerpo: 'Se registró "${nueva.titulo}" correctamente.',
      );

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      _mostrarMensaje('Error al guardar reporte: $e');
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  void _mostrarMensaje(String texto) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo Reporte de Incidencia')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _tituloCtrl,
                decoration: const InputDecoration(
                  labelText: 'Título de la incidencia *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El título es obligatorio';
                  }
                  if (value.trim().length < 4) {
                    return 'Ingresa al menos 4 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _categoriaSeleccionada,
                decoration: const InputDecoration(
                  labelText: 'Categoría *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: _categorias
                    .map(
                      (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                    )
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _categoriaSeleccionada = val);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descripcionCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descripción detallada *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'La descripción es obligatoria';
                  }
                  if (value.trim().length < 10) {
                    return 'Describe el problema con al menos 10 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _capturarFoto,
                      icon: const Icon(Icons.camera_alt),
                      label: Text(
                        _fotoPath == null ? 'Tomar Foto' : 'Cambiar Foto',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _obteniendoGps ? null : _obtenerUbicacion,
                      icon: _obteniendoGps
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.my_location),
                      label: const Text('Obtener GPS'),
                    ),
                  ),
                ],
              ),
              if (_latitud != null && _longitud != null) ...[
                const SizedBox(height: 12),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.location_on, color: Colors.green),
                    title: const Text('Coordenadas registradas'),
                    subtitle: Text('Lat: $_latitud | Lon: $_longitud'),
                  ),
                ),
              ],
              if (_fotoPath != null && File(_fotoPath!).existsSync()) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(_fotoPath!),
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _guardando ? null : _guardarIncidencia,
                icon: const Icon(Icons.save),
                label: Text(_guardando ? 'Guardando...' : 'Guardar Reporte'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
