import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../models/registro.dart';
import '../providers/registros_provider.dart';
import '../services/camara_service.dart';
import '../services/clima_service.dart';
import '../services/notificaciones_service.dart';
import '../services/ubicacion_service.dart';
import '../utils/formato.dart';
import '../utils/validadores.dart';
import '../widgets/calificacion_estrellas.dart';

/// Formulario validado: lugar, categoría, nota y calificación, más foto,
/// coordenadas GPS y fecha/hora automática.
class NuevoRegistroScreen extends StatefulWidget {
  const NuevoRegistroScreen({super.key});

  @override
  State<NuevoRegistroScreen> createState() => _NuevoRegistroScreenState();
}

class _NuevoRegistroScreenState extends State<NuevoRegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _lugar = TextEditingController();
  final _nota = TextEditingController();
  final _camara = CamaraService();
  final _ubicacion = UbicacionService();
  final _clima = ClimaService();

  final DateTime _fecha = DateTime.now();
  String? _categoria;
  double _calificacion = 3;
  ResultadoFoto? _foto;
  Position? _posicion;
  ResultadoUbicacion? _resultadoUbicacion;
  bool _buscandoUbicacion = false;
  bool _guardando = false;

  @override
  void dispose() {
    _lugar.dispose();
    _nota.dispose();
    super.dispose();
  }

  void _aviso(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  Future<void> _tomarFoto() async {
    final r = await _camara.tomarFoto();
    if (!mounted) return;
    if (r.estado == EstadoCamara.ok) {
      setState(() => _foto = r);
    } else {
      _aviso(r.mensaje);
    }
  }

  Future<void> _obtenerUbicacion() async {
    setState(() => _buscandoUbicacion = true);
    final r = await _ubicacion.obtenerActual();
    if (!mounted) return;
    setState(() {
      _buscandoUbicacion = false;
      _resultadoUbicacion = r;
      if (r.exito) _posicion = r.posicion;
    });
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<RegistrosProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    setState(() => _guardando = true);

    // El clima es opcional: si no hay red el registro se guarda igual.
    double? temperatura;
    final pos = _posicion;
    if (pos != null) {
      try {
        temperatura = (await _clima.obtener(
          pos.latitude,
          pos.longitude,
        )).temperatura;
      } catch (_) {
        temperatura = null;
      }
    }

    final registro = Registro(
      lugar: _lugar.text.trim(),
      categoria: _categoria!,
      nota: _nota.text.trim(),
      calificacion: _calificacion.round(),
      latitud: pos?.latitude,
      longitud: pos?.longitude,
      fecha: _fecha,
      foto: _foto?.bytes,
      temperatura: temperatura,
    );

    final ok = await provider.agregar(registro);
    if (!mounted) return;

    if (!ok) {
      setState(() => _guardando = false);
      messenger.showSnackBar(
        const SnackBar(content: Text('No se pudo guardar el registro')),
      );
      return;
    }

    final sistema = await NotificacionesService.mostrarRegistroGuardado(
      registro.lugar,
    );
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          sistema ? 'Registro guardado' : 'Registro guardado (aviso dentro de la app: notificaciones del sistema no disponibles)',
        ),
      ),
    );
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final bytes = _foto?.bytes;
    final r = _resultadoUbicacion;
    final pos = _posicion;

    return Scaffold(
      appBar: AppBar(title: const Text('Nueva visita')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _lugar,
              decoration: const InputDecoration(
                labelText: 'Lugar visitado',
                border: OutlineInputBorder(),
              ),
              validator: validarLugar,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _categoria,
              decoration: const InputDecoration(
                labelText: 'Categoría',
                border: OutlineInputBorder(),
              ),
              items: [
                for (final c in Registro.categorias)
                  DropdownMenuItem(value: c, child: Text(c)),
              ],
              onChanged: (v) => setState(() => _categoria = v),
              validator: validarCategoria,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nota,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Nota de la visita',
                border: OutlineInputBorder(),
              ),
              validator: validarNota,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Calificación'),
                Expanded(
                  child: Slider(
                    value: _calificacion,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: _calificacion.round().toString(),
                    onChanged: (v) => setState(() => _calificacion = v),
                  ),
                ),
                CalificacionEstrellas(valor: _calificacion.round()),
              ],
            ),
            const Divider(),
            Text('Fecha y hora: ${formatearFecha(_fecha)}'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: _tomarFoto,
                  icon: const Icon(Icons.camera_alt),
                  label: Text(bytes == null ? 'Tomar foto' : 'Cambiar foto'),
                ),
                OutlinedButton.icon(
                  onPressed: _buscandoUbicacion ? null : _obtenerUbicacion,
                  icon: _buscandoUbicacion
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.my_location),
                  label: const Text('Obtener ubicación'),
                ),
                if (r != null && r.puedeAbrirAjustes)
                  TextButton(
                    onPressed: () => _ubicacion.abrirAjustes(r.estado),
                    child: const Text('Abrir ajustes'),
                  ),
              ],
            ),
            if (bytes != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(bytes, height: 200, fit: BoxFit.cover),
              ),
            ],
            const SizedBox(height: 8),
            if (pos != null)
              Text(
                'Ubicación: ${formatearCoordenada(pos.latitude)}, '
                '${formatearCoordenada(pos.longitude)} '
                '(±${pos.accuracy.toStringAsFixed(0)} m)',
              )
            else if (r != null)
              Text(
                r.mensaje,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              )
            else
              const Text('Ubicación opcional: sin coordenadas'),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _guardando ? null : _guardar,
              icon: _guardando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: const Text('Guardar visita'),
            ),
          ],
        ),
      ),
    );
  }
}
