import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'pages/notas_page.dart';
import 'pages/tareas_page.dart';
import 'services/preferencias.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // sqflite no funciona en web por defecto; se usa el adaptador FFI web
  // (almacena la base de datos en el navegador).
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Práctica 6 - Persistencia',
    theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
    home: const InicioPage(),
  );
}

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  int _indice = 0;
  String _nombre = 'Invitado';

  static const _paginas = [TareasPage(), NotasPage()];

  @override
  void initState() {
    super.initState();
    _cargarNombre();
  }

  Future<void> _cargarNombre() async {
    final n = await Preferencias.leerNombre();
    if (!mounted) return;
    setState(() => _nombre = n);
  }

  Future<void> _editarNombre() async {
    final ctrl = TextEditingController(
      text: _nombre == 'Invitado' ? '' : _nombre,
    );
    final nuevo = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nombre de usuario'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Nombre'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    ctrl.dispose();
    if (nuevo == null || nuevo.isEmpty) return;
    await Preferencias.guardarNombre(nuevo);
    if (!mounted) return;
    setState(() => _nombre = nuevo);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Hola, $_nombre'),
      actions: [
        IconButton(
          icon: const Icon(Icons.person),
          tooltip: 'Cambiar nombre',
          onPressed: _editarNombre,
        ),
      ],
    ),
    body: _paginas[_indice],
    bottomNavigationBar: NavigationBar(
      selectedIndex: _indice,
      onDestinationSelected: (i) => setState(() => _indice = i),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.checklist), label: 'Tareas'),
        NavigationDestination(
          icon: Icon(Icons.note_alt_outlined),
          label: 'Notas',
        ),
      ],
    ),
  );
}
