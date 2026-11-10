# Práctica 8 – GPS, geolocalización y mapas

## Objetivo
Solicitar permisos de ubicación, obtener coordenadas del dispositivo y representarlas en una interfaz preparada para mapas.

## Qué incluye
- **Ejemplo guiado (pestaña "Mi ubicación"):** permisos en tiempo de ejecución, latitud, longitud, precisión y botón "Abrir en mapa".
- **Ejercicio evaluable (pestaña "Lugares"):** puntos de interés con nombre, latitud y longitud (mínimo tres), distancia desde la ubicación actual con `Geolocator.distanceBetween` y apertura de mapa externo.
- Manejo de estados: servicio desactivado, permiso denegado, denegado permanentemente, error y tiempo de espera. Los lugares se guardan con `shared_preferences`.

## Requisitos
- Flutter SDK; Chrome (permiso de ubicación del navegador, solo en `localhost`/HTTPS) o dispositivo físico Android/iOS
- Paquetes: `geolocator`, `url_launcher`, `shared_preferences`

## Instalación
```bash
flutter create practica_08_geolocalizacion_josue
cd practica_08_geolocalizacion_josue
flutter pub add geolocator url_launcher shared_preferences
```
Copiar `lib/`, `test/` y este `README.md`. Borrar `test/widget_test.dart`.

### Permisos (solo para Android / iOS)
**Android** – `android/app/src/main/AndroidManifest.xml`, dentro de `<manifest>`:
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<queries>
  <intent>
    <action android:name="android.intent.action.VIEW"/>
    <data android:scheme="https"/>
  </intent>
</queries>
```
**iOS** – `ios/Runner/Info.plist`:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>La app usa tu ubicación para calcular distancias a lugares guardados.</string>
```
En web no se requiere configuración: el navegador pide el permiso.

## Ejecución
```bash
flutter run -d chrome
# o, con un dispositivo conectado:
flutter run
```

## Estructura
```
lib/
  main.dart
  models/    lugar.dart
  services/  ubicacion_service.dart, mapa_service.dart, lugares_repository.dart
  utils/     formato.dart, validadores.dart
  screens/   home_screen.dart, ubicacion_screen.dart, lugares_screen.dart
  widgets/   lugar_tile.dart, tarjeta_posicion.dart, dialogo_lugar.dart
test/        logica_test.dart
```

## Pruebas
```bash
dart format .
flutter analyze
flutter test
```
Casos manuales: aceptar/negar permiso, servicio desactivado (en dispositivo), guardar tres lugares, distancias, abrir mapa, reiniciar la app y comprobar que los lugares permanecen.

> Nota: para registrar lugares distintos al actual, el formulario permite editar las coordenadas.

## Participantes
- (Nombre completo) – práctica individual

## Entrega en GitHub
```bash
git checkout develop
git pull origin develop
git checkout -b practica-08-geolocalizacion-josue
dart format .
flutter analyze
flutter test
git add .
git commit -m "feat: completa practica 08"
git push -u origin practica-08-geolocalizacion-josue
```
Pull request hacia `develop`. Evidencias en `docs/evidencias/practica-08/josue/`.
