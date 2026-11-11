import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/tarea.dart';
import '../providers/tareas_provider.dart';
import '../widgets/dialogos.dart';
import '../widgets/encabezado.dart';
import '../widgets/tarea_tile.dart';
import 'contador_screen.dart';

/// Proyecto integrador: gestor de tareas de la práctica 6 refactorizado.
/// Pantalla sin estado propio salvo el formulario.
class TareasScreen extends StatelessWidget {
  const TareasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas'),
        actions: [
          IconButton(
            tooltip: 'Contador (ejemplo guiado)',
            icon: const Icon(Icons.exposure_plus_1),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ContadorScreen()),
            ),
          ),
        ],
      ),
      body: const Column(
        children: [
          _Resumen(),
          _NuevaTarea(),
          _SelectorFiltro(),
          SizedBox(height: 8),
          Expanded(child: _ListaTareas()),
        ],
      ),
    );
  }
}

class _Resumen extends StatelessWidget {
  const _Resumen();

  @override
  Widget build(BuildContext context) {
    // select: solo se reconstruye si cambia el número de pendientes.
    final n = context.select<TareasProvider, int>((p) => p.pendientes);
    return Encabezado('Mis tareas', subtitulo: '$n pendiente(s)');
  }
}

class _NuevaTarea extends StatefulWidget {
  const _NuevaTarea();

  @override
  State<_NuevaTarea> createState() => _NuevaTareaState();
}

class _NuevaTareaState extends State<_NuevaTarea> {
  final _form = GlobalKey<FormState>();
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _agregar() {
    if (!_form.currentState!.validate()) return;
    context.read<TareasProvider>().agregar(_ctrl.text);
    _ctrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Form(
        key: _form,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                controller: _ctrl,
                decoration: const InputDecoration(labelText: 'Nueva tarea'),
                validator: TareasProvider.validar,
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
    );
  }
}

class _SelectorFiltro extends StatelessWidget {
  const _SelectorFiltro();

  @override
  Widget build(BuildContext context) {
    final filtro = context.select<TareasProvider, Filtro>((p) => p.filtro);
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SegmentedButton<Filtro>(
        segments: const [
          ButtonSegment(value: Filtro.todas, label: Text('Todas')),
          ButtonSegment(value: Filtro.pendientes, label: Text('Pendientes')),
          ButtonSegment(value: Filtro.completadas, label: Text('Completadas')),
        ],
        selected: {filtro},
        onSelectionChanged: (s) =>
            context.read<TareasProvider>().cambiarFiltro(s.first),
      ),
    );
  }
}

class _ListaTareas extends StatelessWidget {
  const _ListaTareas();

  Future<void> _editar(BuildContext context, Tarea t) async {
    final provider = context.read<TareasProvider>();
    final nuevo = await pedirTexto(
      context,
      titulo: 'Editar tarea',
      inicial: t.titulo,
      validator: TareasProvider.validar,
    );
    if (nuevo != null) await provider.editar(t.id, nuevo);
  }

  Future<void> _eliminar(BuildContext context, Tarea t) async {
    final provider = context.read<TareasProvider>();
    if (await confirmar(
      context,
      'Eliminar tarea',
      '¿Eliminar "${t.titulo}"?',
    )) {
      await provider.eliminar(t.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TareasProvider>();
    if (provider.cargando) {
      return const Center(child: CircularProgressIndicator());
    }
    final tareas = provider.visibles;
    if (tareas.isEmpty) return const Center(child: Text('No hay tareas'));
    // builder: solo construye las tarjetas visibles en pantalla.
    return ListView.builder(
      itemCount: tareas.length,
      itemBuilder: (_, i) {
        final t = tareas[i];
        return TareaTile(
          key: ValueKey(t.id),
          tarea: t,
          onMarcar: (v) => provider.marcar(t.id, v),
          onEditar: () => _editar(context, t),
          onEliminar: () => _eliminar(context, t),
        );
      },
    );
  }
}
