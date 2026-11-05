import 'package:flutter/material.dart';

import 'database/db.dart';
import 'models/nota.dart';
import 'services/preferencias_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MiAplicacion());
}

class MiAplicacion extends StatelessWidget {
  const MiAplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notas Offline',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF4F6FA),
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
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController contenidoController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();

  List<Nota> notas = [];

  String nombreUsuario = 'Invitado';
  int? notaEditando;
  int pendientes = 0;

  @override
  void initState() {
    super.initState();
    inicializar();
  }

  Future<void> inicializar() async {
    nombreUsuario = await PreferenciasService.leerNombre();
    await cargarNotas();

    if (mounted) setState(() {});
  }

  Future<void> cargarNotas() async {
    notas = await DB.listar();
    pendientes = await DB.contarPendientes();

    if (mounted) setState(() {});
  }

  Future<void> guardarNota() async {
    final titulo = tituloController.text.trim();
    final contenido = contenidoController.text.trim();

    if (titulo.isEmpty || contenido.isEmpty) {
      mostrarMensaje('Completa el título y el contenido');
      return;
    }

    if (notaEditando == null) {
      await DB.insertar(Nota(titulo: titulo, contenido: contenido));

      mostrarMensaje('Nota guardada correctamente');
    } else {
      final notaAnterior = notas.firstWhere((nota) => nota.id == notaEditando);

      await DB.actualizar(
        Nota(
          id: notaEditando,
          titulo: titulo,
          contenido: contenido,
          completada: notaAnterior.completada,
          pendienteSincronizar: true,
        ),
      );

      mostrarMensaje('Nota actualizada correctamente');
    }

    limpiarFormulario();
    await cargarNotas();
  }

  void editarNota(Nota nota) {
    setState(() {
      notaEditando = nota.id;
      tituloController.text = nota.titulo;
      contenidoController.text = nota.contenido;
    });
  }

  void limpiarFormulario() {
    tituloController.clear();
    contenidoController.clear();

    setState(() {
      notaEditando = null;
    });
  }

  Future<void> eliminarNota(Nota nota) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar nota'),
        content: Text('¿Deseas eliminar "${nota.titulo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await DB.eliminar(nota.id!);

      if (notaEditando == nota.id) {
        limpiarFormulario();
      }

      await cargarNotas();
      mostrarMensaje('Nota eliminada');
    }
  }

  Future<void> cambiarEstado(Nota nota, bool valor) async {
    await DB.cambiarEstado(
      Nota(
        id: nota.id,
        titulo: nota.titulo,
        contenido: nota.contenido,
        completada: valor,
      ),
    );

    await cargarNotas();
  }

  Future<void> guardarNombre() async {
    final nombre = nombreController.text.trim();

    if (nombre.isEmpty) {
      mostrarMensaje('Escribe tu nombre');
      return;
    }

    await PreferenciasService.guardarNombre(nombre);

    setState(() {
      nombreUsuario = nombre;
    });

    nombreController.clear();
    if (!mounted) return;
    Navigator.pop(context);

    mostrarMensaje('Nombre guardado correctamente');
  }

  void mostrarDialogoNombre() {
    nombreController.text = nombreUsuario;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nombre de usuario'),
        content: TextField(
          controller: nombreController,
          decoration: const InputDecoration(
            labelText: 'Tu nombre',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(onPressed: guardarNombre, child: const Text('Guardar')),
        ],
      ),
    );
  }

  void mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  void dispose() {
    tituloController.dispose();
    contenidoController.dispose();
    nombreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mis notas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Cambiar nombre',
            onPressed: mostrarDialogoNombre,
            icon: const Icon(Icons.person_outline),
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: cargarNotas,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // BIENVENIDA
            Card(
              color: Colors.indigo,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '¡Hola!',
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                    Text(
                      nombreUsuario,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tus notas están disponibles sin conexión.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ESTADO DE SINCRONIZACIÓN
            Card(
              child: ListTile(
                leading: const Icon(Icons.sync_problem, color: Colors.orange),
                title: const Text('Sincronización'),
                subtitle: Text('$pendientes cambios pendientes de sincronizar'),
                trailing: const Icon(Icons.cloud_off),
              ),
            ),

            const SizedBox(height: 20),

            // FORMULARIO
            Text(
              notaEditando == null ? 'Nueva nota' : 'Editar nota',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: tituloController,
              decoration: const InputDecoration(
                labelText: 'Título',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: contenidoController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Contenido',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: guardarNota,
                    icon: Icon(notaEditando == null ? Icons.save : Icons.edit),
                    label: Text(
                      notaEditando == null ? 'Guardar' : 'Actualizar',
                    ),
                  ),
                ),
                if (notaEditando != null) ...[
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    tooltip: 'Cancelar edición',
                    onPressed: limpiarFormulario,
                    icon: const Icon(Icons.close),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 24),

            // LISTADO
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Mis registros',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text('${notas.length} notas'),
              ],
            ),

            const SizedBox(height: 12),

            if (notas.isEmpty)
              const Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: [
                    Icon(Icons.note_alt_outlined, size: 60, color: Colors.grey),
                    SizedBox(height: 12),
                    Text('Todavía no tienes notas'),
                    Text('Crea tu primera nota arriba'),
                  ],
                ),
              ),

            ...notas.map((nota) {
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: Checkbox(
                    value: nota.completada,
                    onChanged: (valor) {
                      cambiarEstado(nota, valor ?? false);
                    },
                  ),
                  title: Text(
                    nota.titulo,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: nota.completada
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text(nota.contenido),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            nota.pendienteSincronizar
                                ? Icons.cloud_upload_outlined
                                : Icons.cloud_done_outlined,
                            size: 16,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            nota.pendienteSincronizar
                                ? 'Pendiente de sincronizar'
                                : 'Sincronizada',
                            style: const TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: PopupMenuButton<String>(
                    onSelected: (opcion) {
                      if (opcion == 'editar') {
                        editarNota(nota);
                      } else if (opcion == 'eliminar') {
                        eliminarNota(nota);
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'editar', child: Text('Editar')),
                      PopupMenuItem(value: 'eliminar', child: Text('Eliminar')),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
