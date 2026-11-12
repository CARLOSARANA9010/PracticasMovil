# Práctica 06 · Persistencia local y funcionamiento offline

## Objetivo
Persistir preferencias simples (`shared_preferences`) y registros estructurados (`sqflite`) en almacenamiento local, implementando operaciones CRUD y una estrategia básica offline.

## Funciones
- **Ejercicio evaluable** (`TareasPage`, pantalla inicial): gestor de tareas con SQLite.
  - Crear (con validación: título obligatorio, máx. 100 caracteres), consultar, editar (diálogo), eliminar (con confirmación) y marcar como completada (checkbox, texto tachado).
  - Filtro *Todas / Pendientes / Completadas*; el filtro elegido se guarda con SharedPreferences y se restaura al reabrir la app.
- **Ejemplo guiado** (`NotasPage`, botón 📝 en la barra superior):
  - Dos `TextField` + botón *Guardar/Actualizar*; las notas de `DB.listar()` se muestran en un `ListView`.
  - Tocar una nota carga sus datos para editarla; botón eliminar con diálogo de confirmación.
  - Nombre del usuario guardado con SharedPreferences (botón 👤) y mostrado en la barra al iniciar (`Invitado` por defecto).
- **Offline**: todo vive en el dispositivo; no hay ninguna llamada de red, así que funciona igual en modo avión.

## Bandera `pendiente_sincronizar`
La tabla `notas` tiene la columna `pendiente_sincronizar INTEGER DEFAULT 1`. Cada alta o edición local la pone en `1` (icono ☁️⬆ en la lista). Un futuro proceso de sincronización haría:
1. `SELECT * FROM notas WHERE pendiente_sincronizar = 1`
2. Enviar cada registro al servidor.
3. Si la respuesta es exitosa, `UPDATE notas SET pendiente_sincronizar = 0 WHERE id = ?` (icono ☁️✔).

Las bajas necesitarían un borrado lógico (`eliminado = 1`) para poder avisar al servidor antes de borrar la fila.

## Base de datos (`practica06.db`)
| Tabla | Columnas |
|-------|----------|
| `notas` | `id` PK autoincrement, `titulo`, `contenido`, `pendiente_sincronizar` |
| `tareas` | `id` PK autoincrement, `titulo` NOT NULL, `completada` (0/1) |

## Estructura
```
lib/
  main.dart
  database/db.dart          (clase DB: CRUD de notas y tareas)
  prefs.dart                (nombre_usuario y filtro_tareas en SharedPreferences)
  screens/  tareas_page.dart, notas_page.dart
test/
  widget_test.dart          (CRUD notas, CRUD + filtro tareas, preferencias, validación UI)
```

## Requisitos
- Flutter SDK (Dart ^3.x)
- Paquetes: `sqflite`, `shared_preferences`, `path`, `sqflite_common_ffi_web` (SQLite en navegador) y `sqflite_common_ffi` (solo para pruebas)
- No requiere Internet

## Instalación y ejecución
```bash
cd practica_06_persistencia
flutter pub get
flutter run            # emulador o dispositivo Android
flutter run -d edge --release --no-web-resources-cdn --web-port 8080   # navegador, funciona offline
```

**Web:** `sqflite` no tiene implementación web, así que en navegador `main.dart` usa `databaseFactoryFfiWebNoWebWorker` con `web/sqlite3.wasm` (SQLite compilado a WebAssembly, versión del paquete `sqlite3` 3.5.2). Los datos se guardan en IndexedDB. Para que la app abra sin internet, `--no-web-resources-cdn` sirve CanvasKit desde el equipo en lugar del CDN de Google, y la fuente Roboto va empaquetada en `assets/fonts/` (en web Flutter la descargaría de Google Fonts).

**Offline en navegador (DevTools → Network → Offline → recargar):** `web/sw.js` es un *service worker* que responde red primero y, sin conexión, desde la caché (`practica06`). En la instalación precarga los archivos base (`main.dart.js`, CanvasKit, `sqlite3.wasm`, fuentes) para que la primera visita ya quede disponible offline. `web/flutter_bootstrap.js` no registra el service worker de Flutter porque está obsoleto y se da de baja solo, lo que borraría el nuestro. Usar `--release` (en debug el servidor de desarrollo necesita conexión para hot reload) y un puerto fijo (`--web-port 8080`): la caché y la base IndexedDB dependen del origen `localhost:puerto`.

**Windows con Flutter en `C:\Program Files`:** los *build hooks* de `sqlite3` fallan por el espacio en la ruta (`'C:\Program' is not recognized...`). Solución: usar la ruta corta (`C:\PROGRA~1\flutter\bin\flutter.bat run -d edge`, igual para `test` y `build`) o instalar Flutter en una ruta sin espacios (p. ej. `C:\src\flutter`).

## Pruebas
```bash
flutter analyze
flutter test           # usa sqflite_common_ffi para correr SQLite en el equipo
```
Casos manuales:
1. Crear, editar, completar y eliminar tareas.
2. Elegir un filtro, cerrar la app por completo y reabrir: el filtro y las tareas siguen ahí.
3. Cambiar el nombre en Notas, reiniciar: se muestra el nombre guardado.
4. Activar modo avión y repetir 1–3: todo funciona.

Evidencias en `docs/evidencias/practica-06/`.

## Participantes
- Carlos Rivera
