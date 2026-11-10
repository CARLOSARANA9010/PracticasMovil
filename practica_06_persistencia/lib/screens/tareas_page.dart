import 'package:flutter/material.dart';

import '../database/db.dart';
import '../prefs.dart';
import 'notas_page.dart';

/// Ejercicio evaluable: gestor offline de tareas. El filtro se recuerda con SharedPreferences.
class TareasPage extends StatefulWidget {
  const TareasPage({super.key});

  @override
  State<TareasPage> createState() => _TareasPageState();
}

class _TareasPageState extends State<TareasPage> {
  final _form = GlobalKey<FormState>();
  final _nueva = TextEditingController();
  List<Map<String, dynamic>> _tareas = [];
  Filtro _filtro = Filtro.todas;

  @override
  void initState() {
    super.initState();
    leerFiltro().then((f) {
      _filtro = f;
      _cargar();
    });
  }

  @override
  void dispose() {
    _nueva.dispose();
    super.dispose();
  }

  Future<void> _cargar() async {
    final tareas = await DB.listarTareas(
      completada: switch (_filtro) {
        Filtro.todas => null,
        Filtro.pendientes => false,
        Filtro.completadas => true,
      },
    );
    if (mounted) setState(() => _tareas = tareas);
  }

  static String? _validar(String? v) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return 'Escribe un título';
    if (t.length > 100) return 'Máximo 100 caracteres';
    return null;
  }

  Future<void> _agregar() async {
    if (!_form.currentState!.validate()) return;
    await DB.insertarTarea(_nueva.text.trim());
    _nueva.clear();
    await _cargar();
  }

  Future<void> _editar(Map<String, dynamic> t) async {
    final key = GlobalKey<FormState>();
    final ctrl = TextEditingController(text: t['titulo'] as String);
    final nuevo = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Editar tarea'),
        content: Form(
          key: key,
          child: TextFormField(
            controller: ctrl,
            autofocus: true,
            validator: _validar,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (key.currentState!.validate()) {
                Navigator.pop(c, ctrl.text.trim());
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    ctrl.dispose();
    if (nuevo == null) return;
    await DB.editarTarea(t['id'] as int, nuevo);
    await _cargar();
  }

  Future<void> _eliminar(int id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Eliminar tarea'),
        content: const Text('Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await DB.eliminarTarea(id);
    await _cargar();
  }

  Future<void> _cambiarFiltro(Filtro f) async {
    setState(() => _filtro = f);
    await guardarFiltro(f);
    await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas offline'),
        actions: [
          IconButton(
            tooltip: 'Notas (ejemplo guiado)',
            icon: const Icon(Icons.note),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotasPage()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Form(
              key: _form,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _nueva,
                      decoration: const InputDecoration(
                        labelText: 'Nueva tarea',
                      ),
                      validator: _validar,
                      onFieldSubmitted: (_) => _agregar(),
                    ),
                  ),
                  IconButton.filled(
                    tooltip: 'Agregar',
                    icon: const Icon(Icons.add),
                    onPressed: _agregar,
                  ),
                ],
              ),
            ),
          ),
          SegmentedButton<Filtro>(
            segments: const [
              ButtonSegment(value: Filtro.todas, label: Text('Todas')),
              ButtonSegment(
                value: Filtro.pendientes,
                label: Text('Pendientes'),
              ),
              ButtonSegment(
                value: Filtro.completadas,
                label: Text('Completadas'),
              ),
            ],
            selected: {_filtro},
            onSelectionChanged: (s) => _cambiarFiltro(s.first),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _tareas.isEmpty
                ? const Center(child: Text('No hay tareas'))
                : ListView.builder(
                    itemCount: _tareas.length,
                    itemBuilder: (_, i) {
                      final t = _tareas[i];
                      final hecha = t['completada'] == 1;
                      return CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        value: hecha,
                        onChanged: (v) async {
                          await DB.marcarTarea(t['id'] as int, v ?? false);
                          await _cargar();
                        },
                        title: Text(
                          t['titulo'] as String,
                          style: hecha
                              ? const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                )
                              : null,
                        ),
                        secondary: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'Editar',
                              icon: const Icon(Icons.edit),
                              onPressed: () => _editar(t),
                            ),
                            IconButton(
                              tooltip: 'Eliminar',
                              icon: const Icon(Icons.delete),
                              onPressed: () => _eliminar(t['id'] as int),
                            ),
                          ],
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
