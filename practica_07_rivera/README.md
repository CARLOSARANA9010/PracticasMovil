# Práctica 07 · Arquitectura Flutter: componentes, paquetes y optimización

## Objetivo
Estructurar una aplicación Flutter escalable separando modelos, servicios, estado y UI; administrar el estado con **Provider**, integrar paquetes externos justificados y aplicar prácticas básicas de rendimiento.

## Funciones
- **Ejemplo guiado** (`ContadorScreen`, botón **+1** en la barra superior): `ContadorProvider` (`ChangeNotifier`) registrado en la raíz; el valor se consume con `Consumer` y el botón usa `context.read` para no reconstruirse.
- **Proyecto integrador** (`TareasScreen`, pantalla inicial): el gestor de tareas de la práctica 6, refactorizado.
  - Crear (validación: obligatorio, máx. 100 caracteres), editar (diálogo), eliminar (confirmación) y marcar como completada.
  - Filtro *Todas / Pendientes / Completadas*, contador de pendientes y fecha de creación formateada con `intl`.
  - Tareas y filtro persisten entre ejecuciones (`shared_preferences`, JSON).

## Arquitectura
```
lib/
  main.dart                      App + MultiProvider en la raíz
  models/tarea.dart              Tarea (inmutable, toJson/fromJson) y enum Filtro
  services/tareas_service.dart   Persistencia: único lugar que conoce SharedPreferences
  providers/
    contador_provider.dart       Ejemplo guiado
    tareas_provider.dart         Estado y reglas (CRUD, filtro, validación)
  screens/
    tareas_screen.dart           UI del integrador, dividida en widgets privados pequeños
    contador_screen.dart         UI del ejemplo guiado
  widgets/                       Componentes reutilizables sin dependencia de Provider
    encabezado.dart, boton_accion.dart, tarea_tile.dart, dialogos.dart
test/widget_test.dart
```
Flujo: **Screen → Provider → Service → almacenamiento**. La UI nunca llama al servicio; el servicio no sabe nada de widgets.

### Antes (práctica 6) vs. después
| Práctica 6 | Práctica 7 |
|---|---|
| `StatefulWidget` con `setState` y llamadas directas a `DB` | `StatelessWidget` + `TareasProvider`; solo el formulario conserva estado local |
| Filas como `Map<String, dynamic>` (`t['titulo'] as String`) | Modelo tipado `Tarea` |
| Diálogos de confirmación/edición copiados en cada pantalla | `widgets/dialogos.dart` reutilizable |
| Toda la pantalla se reconstruye al cambiar algo | `context.select` / `Consumer`: solo se reconstruye lo que depende del dato |
| Filtrado con consulta SQL en cada cambio | Filtrado en el provider sobre la lista en memoria |

## Paquetes y justificación
| Paquete | Por qué |
|---|---|
| `provider` | Administración de estado recomendada en la guía de Flutter; inyecta `TareasProvider` y `ContadorProvider` sin pasar datos por constructores. |
| `intl` | `DateFormat('dd/MM/yyyy HH:mm')` para mostrar la fecha de creación de cada tarea. |
| `shared_preferences` | Persistencia simple que funciona en Android, iOS, web y Windows sin configuración extra. Sustituye a `sqflite` de la práctica 6, que en web necesitaba SQLite wasm y fallaba en Windows con rutas con espacios. Al estar aislado en `TareasService`, volver a SQLite solo cambia esa clase. |

## Optimización aplicada
- `const` en widgets y argumentos constantes (lints de `flutter_lints` sin hallazgos).
- `ListView.builder` con `ValueKey(id)`: solo construye las tarjetas visibles.
- Sin trabajo costoso en `build()`: el filtrado vive en el provider y `DateFormat` se crea una vez (`static final`).
- Reconstrucciones acotadas: `_Resumen` y `_SelectorFiltro` usan `context.select`; el contador usa `Consumer` solo sobre el `Text`; los botones usan `context.read`.
- Widgets pequeños (`_Resumen`, `_NuevaTarea`, `_SelectorFiltro`, `_ListaTareas`, `TareaTile`).

## Comparación Flutter vs. solución nativa (hipotética)
| Aspecto | Flutter | Nativo (Kotlin + Swift) |
|---|---|---|
| Tiempo de desarrollo | Un solo código Dart para UI y lógica; hot reload. | Dos proyectos, dos lenguajes y dos UIs: aprox. el doble de trabajo y de pruebas. |
| Portabilidad | Este mismo código corre en Android, iOS, web y Windows sin cambios. | Cada plataforma se reescribe; web y escritorio serían proyectos aparte. |
| Desempeño percibido | Fluido para una app de listas y formularios; el binario es más grande y el primer arranque en web tarda más (descarga del motor). | Arranque y tamaño algo mejores y acceso directo a APIs del sistema; diferencia imperceptible para esta app. |

## Requisitos
- Flutter SDK 3.x (probado con Flutter 3.44.2 / Dart 3.12.2)
- Paquetes: `provider`, `intl`, `shared_preferences`

## Instalación y ejecución
```bash
cd practica_07_rivera
flutter pub get
flutter run                 # emulador o dispositivo Android
flutter run -d chrome       # navegador (o -d edge)
flutter run -d windows      # escritorio (requiere Modo de desarrollador en Windows)
```

## Pruebas
```bash
dart format .
flutter analyze             # No issues found!
flutter test                # 5 pruebas: contador, modelo, CRUD/filtro/persistencia, validación, UI
```
Casos manuales:
1. Agregar con el campo vacío: aparece *Escribe un título*.
2. Crear, editar, completar y eliminar tareas; el contador de pendientes se actualiza.
3. Elegir un filtro, cerrar y reabrir la app: filtro y tareas se conservan.
4. Abrir el contador (botón +1) e incrementar.

### Diferencias observadas entre destinos
| Destino | Observación |
|---|---|
| Android | _(completar tras probar)_ |
| Web (Chrome/Edge) | _(completar tras probar)_ |

Evidencias en `docs/evidencias/practica-07/`.

## Participantes
- Carlos Rivera
