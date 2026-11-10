import '../models/registro.dart';

/// Contrato de persistencia: la interfaz y los providers no saben si por debajo
/// hay SQLite, archivos o una lista en memoria (útil para las pruebas).
abstract class RegistrosRepository {
  Future<List<Registro>> listar();
  Future<Registro> insertar(Registro registro);
  Future<void> eliminar(int id);
}
