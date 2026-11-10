import 'package:flutter/material.dart';

import '../database/db.dart';
import '../prefs.dart';

/// Ejemplo guiado: CRUD de notas con SQLite + nombre con SharedPreferences.
class NotasPage extends StatefulWidget {
  const NotasPage({super.key});

  @override
  State<NotasPage> createState() => _NotasPageState();
}

class _NotasPageState extends State<NotasPage> {
  final _titulo = TextEditingController();
  final _contenido = TextEditingController();
  List<Map<String, dynamic>> _notas = [];
  int? _editandoId;
  String _nombre = 'Invitado';

  @override
  void initState() {
    super.initState();
    _cargar();
    leerNombre().then((n) => setState(() => _nombre = n));
  }

  @override
  void dispose() {
    _titulo.dispose();
    _contenido.dispose();
    super.dispose();
  }

  Future<void> _cargar() async {
    final notas = await DB.listar();
    if (mounted) setState(() => _notas = notas);
  }

  void _limpiar() {
    _titulo.clear();
    _contenido.clear();
    setState(() => _editandoId = null);
  }

  Future<void> _guardar() async {
    final titulo = _titulo.text.trim();
    if (titulo.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('El título es obligatorio')));
      return;
    }
    if (_editandoId == null) {
      await DB.insertar(titulo, _contenido.text.trim());
    } else {
      await DB.actualizar(_editandoId!, titulo, _contenido.text.trim());
    }
    _limpiar();
    await _cargar();
  }

  Future<void> _eliminar(int id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Eliminar nota'),
        content: const Text('¿Seguro que deseas eliminar esta nota?'),
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
    await DB.eliminar(id);
    if (_editandoId == id) _limpiar();
    await _cargar();
  }

  Future<void> _cambiarNombre() async {
    final ctrl = TextEditingController(text: _nombre);
    final nuevo = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Tu nombre'),
        content: TextField(controller: ctrl, autofocus: true),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(c, ctrl.text.trim()),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    ctrl.dispose();
    if (nuevo == null || nuevo.isEmpty) return;
    await guardarNombre(nuevo);
    setState(() => _nombre = nuevo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hola, $_nombre'),
        actions: [
          IconButton(
            tooltip: 'Cambiar nombre',
            icon: const Icon(Icons.person),
            onPressed: _cambiarNombre,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _titulo,
                  decoration: const InputDecoration(labelText: 'Título'),
                ),
                TextField(
                  controller: _contenido,
                  decoration: const InputDecoration(labelText: 'Contenido'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    FilledButton(
                      onPressed: _guardar,
                      child: Text(
                        _editandoId == null ? 'Guardar' : 'Actualizar',
                      ),
                    ),
                    if (_editandoId != null)
                      TextButton(
                        onPressed: _limpiar,
                        child: const Text('Cancelar'),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _notas.isEmpty
                ? const Center(child: Text('Sin notas'))
                : ListView.builder(
                    itemCount: _notas.length,
                    itemBuilder: (_, i) {
                      final n = _notas[i];
                      return ListTile(
                        selected: n['id'] == _editandoId,
                        leading: Icon(
                          n['pendiente_sincronizar'] == 1
                              ? Icons.cloud_upload_outlined
                              : Icons.cloud_done,
                        ),
                        title: Text(n['titulo'] as String),
                        subtitle: Text(n['contenido'] as String? ?? ''),
                        onTap: () {
                          _titulo.text = n['titulo'] as String;
                          _contenido.text = n['contenido'] as String? ?? '';
                          setState(() => _editandoId = n['id'] as int);
                        },
                        trailing: IconButton(
                          tooltip: 'Eliminar',
                          icon: const Icon(Icons.delete),
                          onPressed: () => _eliminar(n['id'] as int),
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
