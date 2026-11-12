# Práctica 08 · GPS, geolocalización y mapas

## Objetivo
Solicitar permisos de ubicación, obtener las coordenadas del dispositivo y mostrarlas en una interfaz preparada para mapas, calculando distancias y abriendo un mapa externo.

## Funciones
- **Ejemplo guiado** (`UbicacionPage`, botón 🎓 *Ejemplo guiado* en la barra superior): el código del manual. Obtiene la ubicación, muestra latitud, longitud y precisión, y la abre en Google Maps.
- **Ejercicio evaluable: puntos de interés** (`PuntosScreen`, pantalla inicial):
  - Al abrir obtiene la posición actual (latitud, longitud, precisión); botón *Actualizar ubicación*.
  - *Guardar punto*: nombre + coordenadas (prellenadas con la ubicación actual y editables para registrar lugares lejanos). Validación: nombre obligatorio (máx. 50), latitud entre -90 y 90, longitud entre -180 y 180; acepta coma o punto decimal.
  - Cada punto muestra sus coordenadas y la **distancia desde la ubicación actual** calculada con `Geolocator.distanceBetween` (m o km).
  - Botón de mapa en la ubicación actual y en cada punto (`url_launcher`, app externa); botón para eliminar.
  - Los puntos persisten entre ejecuciones (`shared_preferences`, JSON).

## Manejo de permisos y estados
`posicionActual()` (`lib/services/ubicacion_service.dart`) revisa cada estado y nunca deja escapar una excepción:

| Estado | Resultado en la UI |
|---|---|
| Servicio de ubicación apagado | Mensaje + SnackBar con **Ajustes** (`Geolocator.openLocationSettings`) |
| Permiso `denied` | Se solicita; si se vuelve a negar: *Permiso de ubicación denegado* |
| Permiso `deniedForever` | Mensaje + SnackBar con **Ajustes** (`Geolocator.openAppSettings`) |
| Timeout (20 s) o plugin no disponible | *No se pudo obtener la ubicación* |
| Concedido | Coordenadas y precisión |

Si `launchUrl` no puede abrir el mapa se muestra *No se pudo abrir el mapa*.

## Estructura
```
lib/
  main.dart                       App
  models/punto.dart               Punto (nombre, lat, lon, toJson/fromJson)
  services/ubicacion_service.dart Permisos + posición, distancia, abrir mapa, PuntosService
  screens/
    puntos_screen.dart            Ejercicio evaluable (lista + formulario)
    ubicacion_page.dart           Ejemplo guiado del manual
test/widget_test.dart
```

## Configuración de plataforma
- **Android** (`android/app/src/main/AndroidManifest.xml`): `ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION` y `<queries>` con `VIEW https` para que `url_launcher` encuentre el navegador o Maps en Android 11+.
- **iOS** (`ios/Runner/Info.plist`): `NSLocationWhenInUseUsageDescription`.
- **Web**: el navegador pide permiso; requiere `localhost` o HTTPS.

## Requisitos
- Flutter SDK 3.x (probado con Flutter 3.44.2 / Dart 3.12.2)
- Paquetes: `geolocator`, `url_launcher`, `shared_preferences`
- Dispositivo físico con ubicación activa, o emulador con ubicación simulada (Extended controls → Location)

## Instalación y ejecución
```bash
cd practica_08_rivera
flutter pub get
flutter run                 # dispositivo o emulador Android
flutter run -d chrome       # navegador
```

## Pruebas
```bash
dart format .
flutter analyze             # No issues found!
flutter test                # 6 pruebas: modelo, distancia, validaciones, persistencia, UI sin GPS, formulario
```
Casos manuales:
1. Primera ejecución: aparece el diálogo de permiso; al aceptarlo se muestran coordenadas y precisión.
2. Negar el permiso: mensaje sin cierre de la app; *Actualizar ubicación* lo vuelve a pedir.
3. Negar permanentemente / apagar el GPS: aparece la SnackBar con *Ajustes*.
4. Guardar tres puntos (p. ej. Zócalo 19.4326, -99.1332; Ángel 19.4270, -99.1677; Coyoacán 19.3500, -99.1620) y comprobar las distancias.
5. Botón de mapa: abre Google Maps en la coordenada.
6. Cerrar y reabrir: los puntos se conservan.

| Prueba en dispositivo | Resultado |
|---|---|
| Android | _(completar tras probar)_ |

Evidencias en `docs/evidencias/practica-08/`.

## Vinculación con el proyecto integrador
_(completar: dónde se usará la ubicación actual, la distancia o la apertura del mapa en el proyecto; si no aplica, justificar su uso como módulo técnico)._

## Participantes
- Carlos Rivera
