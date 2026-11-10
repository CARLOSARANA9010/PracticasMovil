# Práctica 08: Geolocalización en Flutter

## 1. Introducción

En esta práctica se desarrolló una aplicación móvil utilizando Flutter que permite obtener la ubicación actual del dispositivo mediante el paquete Geolocator y abrir las coordenadas obtenidas en Google Maps utilizando Url Launcher.

La aplicación solicita los permisos de ubicación cuando el usuario utiliza la funcionalidad correspondiente y muestra información sobre la posición obtenida.

## 2. Objetivo

Implementar funcionalidades de geolocalización en Flutter mediante el uso de paquetes externos, comprendiendo la solicitud de permisos, la obtención de coordenadas geográficas y la apertura de aplicaciones externas.

## 3. Tecnologías utilizadas

- Flutter.
- Dart.
- Visual Studio Code.
- Geolocator 14.1.2.
- Url Launcher 6.3.3.
- Google Maps.
- Git y GitHub.

## 4. Estructura del proyecto

```text
practica_08_geolocalizacion/
├── android/
│   └── app/
│       └── src/
│           └── main/
│               └── AndroidManifest.xml
├── lib/
│   ├── main.dart
│   ├── screens/
│   │   └── ubicacion_page.dart
│   └── services/
│       └── ubicacion_service.dart
├── test/
│   └── widget_test.dart
├── pubspec.yaml
└── README.md
```

## 5. Paquetes utilizados

### Geolocator

Se utiliza para consultar el estado del servicio de ubicación, comprobar y solicitar permisos y obtener las coordenadas actuales.

### Url Launcher

Permite abrir Google Maps mediante una dirección URL construida con la latitud y longitud obtenidas.

## 6. Funcionalidades implementadas

- Comprobación de la disponibilidad del servicio de ubicación.
- Verificación y solicitud de permisos de ubicación.
- Obtención de la posición actual.
- Visualización de latitud y longitud.
- Visualización de la precisión de la ubicación en metros.
- Mensajes para informar al usuario sobre el estado de la operación.
- Apertura de Google Maps con las coordenadas obtenidas.
- Control de errores durante la obtención de ubicación y apertura del mapa.

## 7. Permisos de ubicación

Se configuraron los siguientes permisos en `android/app/src/main/AndroidManifest.xml`:

- `ACCESS_FINE_LOCATION`
- `ACCESS_COARSE_LOCATION`

Los permisos se solicitan durante la ejecución cuando el usuario intenta obtener su ubicación.

## 8. Organización del código

El proyecto se organizó en diferentes archivos:

- `main.dart`: inicializa la aplicación y configura la pantalla principal.
- `screens/ubicacion_page.dart`: contiene la interfaz, los botones y la apertura de Google Maps.
- `services/ubicacion_service.dart`: contiene la lógica para comprobar los permisos y obtener la ubicación.
- `test/widget_test.dart`: contiene la prueba de widgets de la pantalla principal.

## 9. Instalación y ejecución

Clonar el repositorio y entrar a la carpeta del proyecto:

```bash
git clone https://github.com/CARLOSARANA9010/PracticasMovil.git
cd PracticasMovil/practica_08_geolocalizacion
```

Instalar las dependencias:

```bash
flutter pub get
```

Ejecutar la aplicación en Chrome:

```bash
flutter run -d chrome
```

También se puede ejecutar en Edge:

```bash
flutter run -d edge
```

Para utilizar la geolocalización en el navegador, se debe conceder el permiso de ubicación y tener habilitados los servicios de ubicación del sistema operativo.

## 10. Verificación y pruebas

Se realizaron las siguientes comprobaciones:

```bash
dart format .
flutter pub get
flutter analyze
flutter test
```

Resultados:

- Formato del código aplicado correctamente.
- Dependencias instaladas correctamente.
- Análisis estático sin problemas.
- Pruebas de widgets ejecutadas correctamente.
- Aplicación ejecutada y probada en Chrome y Edge.
- Obtención de coordenadas y apertura de Google Maps comprobadas.

## 11. Observaciones

La precisión de las coordenadas depende de los servicios de ubicación, los permisos concedidos y las capacidades del dispositivo o sistema operativo utilizado.

Durante las pruebas en Chrome y Edge se obtuvieron coordenadas y se comprobó la apertura de Google Maps. La precisión observada puede variar y no representa una garantía de exactitud a nivel de pocos metros.

## 12. Conclusión

Mediante esta práctica se comprendió cómo integrar servicios de geolocalización en Flutter, gestionar permisos durante la ejecución, obtener coordenadas geográficas y utilizar Url Launcher para abrir aplicaciones externas.

También se reforzó la organización del código mediante la separación de la interfaz y la lógica de servicios.