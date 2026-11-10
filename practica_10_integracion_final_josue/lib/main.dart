import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'data/sqlite_registros_repository.dart';
import 'providers/clima_provider.dart';
import 'providers/registros_provider.dart';
import 'screens/home_screen.dart';
import 'services/clima_service.dart';
import 'services/notificaciones_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // sqflite no funciona en web por defecto; se usa el adaptador FFI web.
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }
  await NotificacionesService.iniciar();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              RegistrosProvider(SqliteRegistrosRepository())..cargar(),
        ),
        ChangeNotifierProvider(create: (_) => ClimaProvider(ClimaService())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Explora Campeche',
        theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
        home: const HomeScreen(),
      ),
    );
  }
}
