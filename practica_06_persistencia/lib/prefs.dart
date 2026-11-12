import 'package:shared_preferences/shared_preferences.dart';

Future<void> guardarNombre(String nombre) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('nombre_usuario', nombre);
}

Future<String> leerNombre() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('nombre_usuario') ?? 'Invitado';
}

enum Filtro { todas, pendientes, completadas }

Future<void> guardarFiltro(Filtro filtro) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('filtro_tareas', filtro.name);
}

Future<Filtro> leerFiltro() async {
  final prefs = await SharedPreferences.getInstance();
  return Filtro.values.asNameMap()[prefs.getString('filtro_tareas')] ??
      Filtro.todas;
}
