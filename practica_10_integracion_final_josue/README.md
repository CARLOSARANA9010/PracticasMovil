# Práctica 10 – Notificaciones y proyecto móvil integrador: Explora Campeche

## Objetivo
Integrar las competencias del curso en una aplicación móvil funcional y configurar notificaciones locales como base conceptual para alertas al usuario.

## Aplicación
**Explora Campeche** registra visitas a sitios turísticos, incluso sin Internet.

| Requisito del manual | Cómo se cumple |
|---|---|
| 3 o más pantallas | Mis visitas, Nueva visita, Detalle y Clima |
| Formulario validado | Lugar, categoría, nota (mín. 10 caracteres) y calificación |
| API REST/JSON | Open-Meteo (clima actual) en la pestaña Clima y temperatura guardada con cada visita |
| Persistencia local | SQLite (`sqflite`); funciona sin conexión |
| Capacidad del dispositivo | GPS (latitud/longitud) y cámara |
| Notificación | Notificación local al guardar (aviso dentro de la app donde no está disponible, como en web) |
| Arquitectura | `models`, `data`, `services`, `providers`, `screens`, `widgets`, `utils` con Provider |
| Estados de carga/error | `EstadoVista` (cargando, error con "Reintentar", vacío) |

## Requisitos
- Flutter SDK; Chrome para el flujo general y un **dispositivo Android físico** para notificaciones, GPS y cámara reales
- Paquetes: `provider`, `http`, `intl`, `sqflite`, `path`, `sqflite_common_ffi_web`, `geolocator`, `image_picker`, `url_launcher`, `flutter_local_notifications`

## Instalación
```bash
flutter create practica_10_integracion_final_josue
cd practica_10_integracion_final_josue
flutter pub add provider http intl sqflite path sqflite_common_ffi_web geolocator image_picker url_launcher flutter_local_notifications
dart run sqflite_common_ffi_web:setup
```
Copiar `lib/`, `test/` y este `README.md`. Borrar `test/widget_test.dart`.
El comando `setup` genera `web/sqlite3.wasm` y `web/sqflite_sw.js` (necesarios para SQLite en Chrome).

### Configuración de Android
`android/app/src/main/AndroidManifest.xml`, dentro de `<manifest>`:
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<queries>
  <intent>
    <action android:name="android.intent.action.VIEW"/>
    <data android:scheme="https"/>
  </intent>
</queries>
```
`flutter_local_notifications` requiere *core library desugaring*. En `android/app/build.gradle.kts`:
```kotlin
android {
    compileOptions {
        isCoreLibraryDesugaringEnabled = true
    }
}
dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
```
(En proyectos con `build.gradle` en Groovy: `coreLibraryDesugaringEnabled true` y `coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.1.4'`.)
Si el compilador marca errores en `initialize`/`show`, revisar la API de la versión instalada (`pubspec.lock`); solo hay que ajustar `lib/services/notificaciones_service.dart`.

### Configuración de iOS
`ios/Runner/Info.plist`: claves `NSLocationWhenInUseUsageDescription`, `NSCameraUsageDescription` y `NSPhotoLibraryUsageDescription` con una descripción de uso.

## Ejecución
```bash
flutter run -d chrome
flutter run              # con un dispositivo físico conectado
```

## Estructura
```
lib/
  main.dart
  models/     registro.dart, clima.dart
  data/       registros_repository.dart, sqlite_registros_repository.dart
  services/   clima_service.dart, ubicacion_service.dart, camara_service.dart,
              notificaciones_service.dart, mapa_service.dart
  providers/  registros_provider.dart, clima_provider.dart
  screens/    home, registros, nuevo_registro, detalle, clima
  widgets/    registro_card, estado_vista, calificacion_estrellas
  utils/      validadores.dart, formato.dart
test/         registro, clima, validadores, registros_provider
```

## Pruebas
```bash
dart format .
flutter analyze
flutter test
```
Casos manuales: ver la sección 8 del reporte (guardar, validar, foto/cancelar, ubicación con y sin permiso, reinicio, clima con y sin red, detalle/mapa, eliminar).

## Errores conocidos y limitaciones
- Las notificaciones del sistema no existen en web: se muestra un aviso dentro de la app.
- GPS, cámara y notificaciones reales deben demostrarse en un dispositivo físico.
- Las fotos se guardan como BLOB y se reducen de tamaño; no hay sincronización con un servidor.

## Participantes
- (Nombre completo) – práctica individual

## Entrega en GitHub y versión final
```bash
git checkout develop
git pull origin develop
git checkout -b practica-10-integracion-final-josue
dart format .
flutter analyze
flutter test
git add .
git commit -m "feat: completa practica 10"
git push -u origin practica-10-integracion-final-josue
# versión final etiquetada
git tag -a v1.0.0 -m "Versión final Explora Campeche"
git push origin v1.0.0
```
Pull request hacia `develop`. Evidencias en `docs/evidencias/practica-10/josue/`.
