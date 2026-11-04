# Práctica 6 – Persistencia local y funcionamiento offline

## Objetivo
Persistir preferencias simples (SharedPreferences) y registros estructurados (SQLite) en almacenamiento local, implementando operaciones CRUD y una estrategia básica offline.

## Requisitos
- Flutter SDK
- Paquetes: `shared_preferences`, `sqflite`, `path`, `sqflite_common_ffi_web` (solo para ejecutar en Chrome)
- Git y GitHub

## Instalación
```bash
flutter create practica_06_persistencia
cd practica_06_persistencia
flutter pub add shared_preferences sqflite path sqflite_common_ffi_web
```
Copiar `lib/`, `test/` y este README. Para ejecutar en **Chrome**, generar los archivos que necesita SQLite en web:
```bash
dart run sqflite_common_ffi_web:setup
```
(crea `web/sqlite3.wasm` y `web/sqflite_sw.js`).

## Ejecución
```bash
flutter run -d chrome
```

## Funcionalidades
- **Tareas (ejercicio evaluable):** crear, consultar, editar, eliminar (con confirmación) y marcar como completada, con SQLite.
- **Notas (actividad guiada):** dos campos de texto, Guardar/Actualizar, lista, edición al tocar y eliminación con confirmación.
- **SharedPreferences:** nombre de usuario (se muestra al iniciar) y filtro de tareas (Todas/Pendientes/Completadas).
- **Offline:** todos los datos se guardan localmente, sin depender de Internet.
- **Bandera `pendiente_sincronizar`:** cada alta, cambio o completado marca la tarea como pendiente de enviar a un servidor.

## Estructura
```
lib/
  main.dart
  database/     db.dart
  models/       tarea.dart
  services/     preferencias.dart
  pages/        tareas_page.dart, notas_page.dart
test/
  tarea_test.dart
```

## Discusión: bandera pendiente_sincronizar
Cada registro modificado localmente queda con `pendiente_sincronizar = 1`. Una futura sincronización enviaría esos registros al servidor y, al recibir confirmación, los pondría en 0. Para las bajas habría que usar borrado lógico (columna `eliminada`) o una tabla de eliminaciones pendientes, ya que una fila borrada no puede conservar su bandera.

## Pruebas
```bash
dart format .
flutter analyze
flutter test
```
Casos manuales: alta, edición, completar, eliminar, reinicio de la app (los datos permanecen), nombre y filtro conservados, red en modo Offline.

## Participantes
- (Nombre del equipo)

## Entrega en GitHub
```bash
git checkout develop
git pull origin develop
git checkout -b practica-06-persistencia
dart format .
flutter analyze
flutter test
git add .
git commit -m "feat: completa practica 06"
git push -u origin practica-06-persistencia
```
Después crear la pull request hacia `develop`. Evidencias en `docs/evidencias/practica-06/`.

