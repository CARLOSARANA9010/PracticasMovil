
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'database/db.dart';
import 'models/nota.dart';

void main() {
  runApp(const MiAplicacion());
}

class MiAplicacion extends StatelessWidget {
  const MiAplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Práctica 06 - Persistencia',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const PantallaNotas(),
    );
  }
}

class PantallaNotas extends StatefulWidget {
  const PantallaNotas({super.key});

  @override
  State<PantallaNotas> createState() => _PantallaNotasState();
}

class _PantallaNotasState extends State<PantallaNotas> {
  final TextEditingController tituloController =
      TextEditingController();

  final TextEditingController contenidoController =
      TextEditingController();

  List<Nota> notas = [];

  String nombreUsuario = 'Usuario';

  int pendientesSincronizar = 0;

  int? idEditando;

  @override
  void initState() {
    super.initState();
    inicializar();
  }

  Future<void> inicializar() async {
    await cargarNombre();
    await cargarNotas();
  }

  // Obtener el nombre guardado en SharedPreferences.
  Future<void> cargarNombre() async {
    final preferencias = await SharedPreferences.getInstance();

    final nombre = preferencias.getString('nombre_usuario');

    if (!mounted) return;

    if (nombre == null || nombre.isEmpty) {
      await solicitarNombre();
    } else {
      setState(() {
        nombreUsuario = nombre;
      });
    }
  }

  // Guardar el nombre del usuario.
  Future<void> solicitarNombre() async {
    final controlador = TextEditingController();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Bienvenido'),
          content: TextField(
            controller: controlador,
            decoration: const InputDecoration(
              labelText: 'Escribe tu nombre',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final nombre = controlador.text.trim();

                if (nombre.isEmpty) return;

                final preferencias =
                    await SharedPreferences.getInstance();

                await preferencias.setString(
                  'nombre_usuario',
                  nombre,
                );

                if (!context.mounted) return;

                setState(() {
                  nombreUsuario = nombre;
                });

                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );

    controlador.dispose();
  }

  // Cargar las notas de SQLite.
  Future<void> cargarNotas() async {
    final resultado = await DB.listar();
    final pendientes = await DB.contarPendientes();

    if (!mounted) return;

    setState(() {
      notas = resultado;
      pendientesSincronizar = pendientes;
    });
  }

  // Limpiar los campos.
  void limpiarCampos() {
    tituloController.clear();
    contenidoController.clear();
    idEditando = null;
  }

  // Guardar o actualizar una nota.
  Future<void> guardarNota() async {
    final titulo = tituloController.text.trim();
    final contenido = contenidoController.text.trim();

    if (titulo.isEmpty || contenido.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa el título y el contenido.'),
        ),
      );
      return;
    }

    if (idEditando == null) {
      final nuevaNota = Nota(
        titulo: titulo,
        contenido: contenido,
        completada: false,
        pendienteSincronizar: true,
      );

      await DB.insertar(nuevaNota);
    } else {
      final notaActualizada = Nota(
        id: idEditando,
        titulo: titulo,
        contenido: contenido,
        completada: false,
        pendienteSincronizar: true,
      );

      await DB.actualizar(notaActualizada);
    }

    limpiarCampos();

    await cargarNotas();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          idEditando == null
              ? 'Nota guardada correctamente.'
              : 'Nota actualizada correctamente.',
        ),
      ),
    );

    setState(() {
      idEditando = null;
    });
  }

  // Seleccionar una nota para editar.
  void editarNota(Nota nota) {
    setState(() {
      idEditando = nota.id;
      tituloController.text = nota.titulo;
      contenidoController.text = nota.contenido;
    });
  }

  // Eliminar una nota.
  Future<void> confirmarEliminar(Nota nota) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar nota'),
          content: const Text(
            '¿Estás seguro de que deseas eliminar esta nota?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmar == true && nota.id != null) {
      await DB.eliminar(nota.id!);
      await cargarNotas();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nota eliminada correctamente.'),
        ),
      );
    }
  }

  // Cambiar el estado de una nota.
  Future<void> cambiarEstado(Nota nota, bool completada) async {
    if (nota.id == null) return;

    await DB.cambiarEstado(
      nota.id!,
      completada,
    );

    await cargarNotas();
  }

  @override
  void dispose() {
    tituloController.dispose();
    contenidoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis notas'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Información del usuario.
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text('Bienvenido, $nombreUsuario'),
                subtitle: const Text(
                  'Tus notas se guardan localmente.',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: 'Cambiar nombre',
                  onPressed: solicitarNombre,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Información de sincronización.
            Card(
              color: Colors.orange.shade50,
              child: ListTile(
                leading: const Icon(
                  Icons.sync_problem,
                  color: Colors.orange,
                ),
                title: const Text('Pendientes de sincronización'),
                trailing: Text(
                  '$pendientesSincronizar',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Formulario de notas.
            TextField(
              controller: tituloController,
              decoration: const InputDecoration(
                labelText: 'Título de la nota',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: contenidoController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Contenido de la nota',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
            ),

            const SizedBox(height: 12),

            // Botones de guardar y cancelar.
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: guardarNota,
                    icon: Icon(
                      idEditando == null ? Icons.save : Icons.edit,
                    ),
                    label: Text(
                      idEditando == null
                          ? 'Guardar nota'
                          : 'Actualizar nota',
                    ),
                  ),
                ),
                if (idEditando != null) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: 'Cancelar edición',
                    onPressed: () {
                      setState(() {
                        limpiarCampos();
                      });
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 15),

            const Divider(),

            // Encabezado de la lista.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Mis notas guardadas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('${notas.length} notas'),
              ],
            ),

            const SizedBox(height: 10),

            // Lista de notas.
            Expanded(
              child: notas.isEmpty
                  ? const Center(
                      child: Text(
                        'Todavía no tienes notas guardadas.',
                      ),
                    )
                  : ListView.builder(
                      itemCount: notas.length,
                      itemBuilder: (context, index) {
                        final nota = notas[index];

                        return Card(
                          child: ListTile(
                            leading: Checkbox(
                              value: nota.completada,
                              onChanged: (valor) {
                                cambiarEstado(
                                  nota,
                                  valor ?? false,
                                );
                              },
                            ),
                            title: Text(
                              nota.titulo,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: nota.completada
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            subtitle: Text(nota.contenido),
                            onTap: () => editarNota(nota),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  tooltip: 'Editar',
                                  onPressed: () => editarNota(nota),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  tooltip: 'Eliminar',
                                  onPressed: () =>
                                      confirmarEliminar(nota),
                                ),
                              ],
                            ),
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
