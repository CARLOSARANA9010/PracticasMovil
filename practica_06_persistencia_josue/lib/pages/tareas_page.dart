import 'package:flutter/material.dart';

import '../database/db.dart';
import '../models/tarea.dart';
import '../services/preferencias.dart';

/// Ejercicio evaluable: gestor offline de tareas con SQLite
/// (crear, consultar, editar, eliminar y marcar completada) y filtro
/// recordado con SharedPreferences.
class TareasPage extends StatefulWidget {
  const TareasPage({super.key});

  @override
  State<TareasPage> createState() => _TareasPageState();
}

class _TareasPageState extends State<TareasPage> {
  List<Tarea> _tareas = [];
  String _filtro = 'todas';
  int _pendientesSync = 0;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _iniciar();
  }

  Future<void> _iniciar() async {
    final filtro = await Preferencias.leerFiltro();
    if (!mounted) return;
    _filtro = filtro;
    await _cargar();
  }

  Future<void> _cargar() async {
    final tareas = await DB.listarTareas(filtro: _filtro);
    final sync = await DB.contarPendientesSincronizar();
    if (!mounted) return;
    setState(() {
      _tareas = tareas;
      _pendientesSync = sync;
      _cargando = false;
    });
  }

  Future<void> _cambiarFiltro(String filtro) async {
    setState(() => _filtro = filtro);
    await Preferencias.guardarFiltro(filtro);
    await _cargar();
  }

  Future<void> _abrirFormulario([Tarea? tarea]) async {
    final r = await showDialog<({String titulo, String descripcion})>(
      context: context,
      builder: (_) => _TareaDialog(tarea: tarea),
    );
    if (r == null) return;
    if (tarea == null) {
      await DB.insertarTarea(
        Tarea(titulo: r.titulo, descripcion: r.descripcion),
      );
    } else {
      await DB.actualizarTarea(
        tarea.copyWith(titulo: r.titulo, descripcion: r.descripcion),
      );
    }
    await _cargar();
  }

  Future<void> _confirmarEliminar(Tarea t) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar tarea'),
        content: Text('¿Eliminar "${t.titulo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await DB.eliminarTarea(t.id!);
    await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        icon: const Icon(Icons.add),
        label: const Text('Nueva tarea'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'todas', label: Text('Todas')),
                ButtonSegment(value: 'pendientes', label: Text('Pendientes')),
                ButtonSegment(value: 'completadas', label: Text('Completadas')),
              ],
              selected: {_filtro},
              onSelectionChanged: (s) => _cambiarFiltro(s.first),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                const Icon(Icons.cloud_off, size: 16),
                const SizedBox(width: 6),
                Text('Cambios locales sin sincronizar: $_pendientesSync'),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _cargando
                ? const Center(child: CircularProgressIndicator())
                : _tareas.isEmpty
                ? const Center(child: Text('No hay tareas'))
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 88),
                    itemCount: _tareas.length,
                    itemBuilder: (context, i) {
                      final t = _tareas[i];
                      return ListTile(
                        leading: Checkbox(
                          value: t.completada,
                          onChanged: (v) async {
                            await DB.marcarCompletada(t.id!, v ?? false);
                            await _cargar();
                          },
                        ),
                        title: Text(
                          t.titulo,
                          style: TextStyle(
                            decoration: t.completada
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        subtitle: t.descripcion.isEmpty
                            ? null
                            : Text(
                                t.descripcion,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                        onTap: () => _abrirFormulario(t),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          tooltip: 'Eliminar',
                          onPressed: () => _confirmarEliminar(t),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _TareaDialog extends StatefulWidget {
  final Tarea? tarea;
  const _TareaDialog({this.tarea});

  @override
  State<_TareaDialog> createState() => _TareaDialogState();
}

class _TareaDialogState extends State<_TareaDialog> {
  late final TextEditingController _titulo;
  late final TextEditingController _descripcion;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titulo = TextEditingController(text: widget.tarea?.titulo ?? '');
    _descripcion = TextEditingController(text: widget.tarea?.descripcion ?? '');
  }

  @override
  void dispose() {
    _titulo.dispose();
    _descripcion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.tarea == null ? 'Nueva tarea' : 'Editar tarea'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titulo,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Título'),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'El título es obligatorio'
                  : null,
            ),
            TextFormField(
              controller: _descripcion,
              decoration: const InputDecoration(labelText: 'Descripción'),
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, (
                titulo: _titulo.text.trim(),
                descripcion: _descripcion.text.trim(),
              ));
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
