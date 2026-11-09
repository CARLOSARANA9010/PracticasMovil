import 'package:flutter/material.dart';
import 'database/db.dart';
import 'preferencias.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Practica6App());
}

class Practica6App extends StatelessWidget {
  const Practica6App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Práctica 6 - Offline',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const NotasPantalla(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NotasPantalla extends StatefulWidget {
  const NotasPantalla({super.key});

  @override
  State<NotasPantalla> createState() => _NotasPantallaState();
}

class _NotasPantallaState extends State<NotasPantalla> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _contenidoController = TextEditingController();

  String _nombreUsuario = 'Cargando...';
  List<Map<String, dynamic>> _notas = [];
  int? _notaSeleccionadaId;
  bool _pendienteSincronizar = false;

  @override
  void initState() {
    super.initState();
    _cargarDatosIniciales();
  }

  Future<void> _cargarDatosIniciales() async {
    String nombre = await leerNombre();
    await _refrescarNotas();
    setState(() {
      _nombreUsuario = nombre;
    });
  }

  Future<void> _editarNombreUsuario() async {
    // 1. Corrección: Variable local sin guion bajo
    TextEditingController nombreController = TextEditingController(
      text: _nombreUsuario == 'Invitado' ? '' : _nombreUsuario,
    );

    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        // Se renombra el contexto del diálogo
        title: const Text('Cambiar Nombre'),
        content: TextField(
          controller: nombreController,
          decoration: const InputDecoration(hintText: 'Ingresa tu nombre'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              if (nombreController.text.isNotEmpty) {
                await guardarNombre(nombreController.text);
                setState(() {
                  _nombreUsuario = nombreController.text;
                });

                // 2. Corrección: Validar que el contexto exista después del await
                if (!dialogContext.mounted) return;
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Future<void> _refrescarNotas() async {
    try {
      final datos = await DB.listar();
      setState(() {
        _notas = datos;
      });
    } catch (e) {
      debugPrint("Error base de datos: $e");
    }
  }

  Future<void> _guardarOActualizar() async {
    if (_tituloController.text.isEmpty || _contenidoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, ingresa un título y un contenido.'),
        ),
      );
      return;
    }

    try {
      if (_notaSeleccionadaId == null) {
        await DB.insertar(_tituloController.text, _contenidoController.text);
      } else {
        await DB.actualizar(
          _notaSeleccionadaId!,
          _tituloController.text,
          _contenidoController.text,
        );
      }

      if (!mounted) return;

      setState(() {
        _pendienteSincronizar = true;
      });

      _limpiarFormulario();
      await _refrescarNotas();

      // 3. Corrección: Nueva validación por el _refrescarNotas asíncrono
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nota guardada correctamente.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: Asegúrate de correr en Android/iOS - $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _cargarNotaParaEditar(Map<String, dynamic> nota) {
    setState(() {
      _notaSeleccionadaId = nota['id'];
      _tituloController.text = nota['titulo'];
      _contenidoController.text = nota['contenido'];
    });
  }

  Future<void> _eliminarNotaConConfirmacion(int id) async {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar nota'),
        content: const Text('¿Estás seguro de eliminar este registro?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await DB.eliminar(id);

              if (!dialogContext.mounted) return;
              Navigator.pop(
                dialogContext,
              ); // Cierra el diálogo usando su propio contexto

              setState(() {
                _pendienteSincronizar = true;
              });
              await _refrescarNotas();

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nota eliminada.')),
                );
              }
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _limpiarFormulario() {
    setState(() {
      _notaSeleccionadaId = null;
      _tituloController.clear();
      _contenidoController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hola, $_nombreUsuario'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editarNombreUsuario,
          ),
          if (_pendienteSincronizar)
            const Icon(Icons.sync_problem, color: Colors.orange),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(labelText: 'Título de la nota'),
            ),
            TextField(
              controller: _contenidoController,
              decoration: const InputDecoration(labelText: 'Contenido'),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _guardarOActualizar,
                  child: Text(
                    _notaSeleccionadaId == null ? 'Guardar' : 'Actualizar',
                  ),
                ),
                if (_notaSeleccionadaId != null)
                  ElevatedButton(
                    onPressed: _limpiarFormulario,
                    child: const Text('Cancelar edición'),
                  ),
              ],
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: _notas.length,
                itemBuilder: (context, index) {
                  final nota = _notas[index];
                  return ListTile(
                    title: Text(nota['titulo']),
                    subtitle: Text(nota['contenido']),
                    onTap: () => _cargarNotaParaEditar(nota),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _eliminarNotaConConfirmacion(nota['id']),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
