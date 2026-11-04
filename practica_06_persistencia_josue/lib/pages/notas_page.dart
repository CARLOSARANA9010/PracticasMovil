import 'package:flutter/material.dart';

import '../database/db.dart';

/// Actividad guiada: dos TextField, Guardar/Actualizar, lista, editar al tocar
/// y eliminar con diálogo de confirmación.
class NotasPage extends StatefulWidget {
  const NotasPage({super.key});

  @override
  State<NotasPage> createState() => _NotasPageState();
}

class _NotasPageState extends State<NotasPage> {
  final _tituloCtrl = TextEditingController();
  final _contenidoCtrl = TextEditingController();
  List<Map<String, dynamic>> _notas = [];
  int? _editandoId;
  String? _errorTitulo;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _contenidoCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargar() async {
    final datos = await DB.listar();
    if (!mounted) return;
    setState(() {
      _notas = datos;
      _cargando = false;
    });
  }

  void _limpiar() {
    _tituloCtrl.clear();
    _contenidoCtrl.clear();
    _editandoId = null;
    _errorTitulo = null;
  }

  Future<void> _guardar() async {
    final titulo = _tituloCtrl.text.trim();
    final contenido = _contenidoCtrl.text.trim();
    if (titulo.isEmpty) {
      setState(() => _errorTitulo = 'El título es obligatorio');
      return;
    }
    if (_editandoId == null) {
      await DB.insertar(titulo, contenido);
    } else {
      await DB.actualizar(_editandoId!, titulo, contenido);
    }
    if (!mounted) return;
    setState(_limpiar);
    await _cargar();
  }

  Future<void> _confirmarEliminar(Map<String, dynamic> nota) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar nota'),
        content: Text('¿Eliminar "${nota['titulo']}"?'),
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
    await DB.eliminar(nota['id'] as int);
    if (!mounted) return;
    if (_editandoId == nota['id']) setState(_limpiar);
    await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _tituloCtrl,
                decoration: InputDecoration(
                  labelText: 'Título',
                  border: const OutlineInputBorder(),
                  errorText: _errorTitulo,
                ),
                onChanged: (_) {
                  if (_errorTitulo != null) setState(() => _errorTitulo = null);
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _contenidoCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Contenido',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _guardar,
                      icon: Icon(_editandoId == null ? Icons.save : Icons.edit),
                      label: Text(
                        _editandoId == null ? 'Guardar' : 'Actualizar',
                      ),
                    ),
                  ),
                  if (_editandoId != null) ...[
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () => setState(_limpiar),
                      child: const Text('Cancelar'),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: _cargando
              ? const Center(child: CircularProgressIndicator())
              : _notas.isEmpty
              ? const Center(child: Text('No hay notas guardadas'))
              : ListView.builder(
                  itemCount: _notas.length,
                  itemBuilder: (context, i) {
                    final n = _notas[i];
                    return ListTile(
                      title: Text('${n['titulo']}'),
                      subtitle: Text(
                        '${n['contenido'] ?? ''}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      selected: _editandoId == n['id'],
                      onTap: () => setState(() {
                        _editandoId = n['id'] as int;
                        _tituloCtrl.text = '${n['titulo']}';
                        _contenidoCtrl.text = '${n['contenido'] ?? ''}';
                        _errorTitulo = null;
                      }),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        tooltip: 'Eliminar',
                        onPressed: () => _confirmarEliminar(n),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
