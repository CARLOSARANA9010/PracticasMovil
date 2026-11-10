# Práctica 07: Arquitectura en Flutter

## Introducción

Esta práctica tiene como finalidad comprender la separación de responsabilidades en Flutter mediante una arquitectura organizada, la administración de estado con Provider y la integración de paquetes externos.

## Objetivo

Estructurar una aplicación Flutter mediante componentes reutilizables, administración de estado y buenas prácticas de optimización.

## Tecnologías utilizadas

- Flutter.
- Dart.
- Provider 6.1.5+1.
- Intl 0.20.3.

## Estructura del proyecto

```text
lib/
├── main.dart
├── models/
├── services/
├── providers/
│   └── contador_provider.dart
├── screens/
│   └── contador_screen.dart
└── widgets/
    ├── contador_tarjeta.dart
    └── contador_botones.dart
```

## Funcionalidades implementadas

- Incrementar el contador.
- Decrementar el contador.
- Reiniciar el contador.
- Administrar el estado mediante ChangeNotifier.
- Actualizar la interfaz mediante Provider.
- Mostrar la fecha actual utilizando Intl.
- Separar la pantalla y los componentes reutilizables.

## Paquetes utilizados

**Provider:** permite administrar el estado de la aplicación y notificar los cambios a los widgets.

**Intl:** permite dar formato a fechas y números.

## Pruebas realizadas

- Ejecución en Google Chrome.
- Ejecución en Microsoft Edge.
- Prueba de incremento, decremento y reinicio.
- Análisis estático mediante flutter analyze.
- Pruebas automatizadas mediante flutter test.

## Comandos para ejecutar

```bash
flutter pub get
flutter run -d chrome
```

También se puede ejecutar en Microsoft Edge:

```bash
flutter run -d edge
```

## Conclusión

La práctica permitió comprender la importancia de separar las responsabilidades dentro de una aplicación Flutter, administrar el estado mediante Provider y utilizar paquetes externos para mejorar la organización y funcionalidad del proyecto.