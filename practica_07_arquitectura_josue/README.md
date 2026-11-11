# Práctica 7 – Arquitectura de la aplicación, gestión de estado y optimización

## Objetivo
Organizar una aplicación Flutter por capas (`models`, `services`, `providers`, `screens`, `widgets`), gestionar el estado con **Provider** y aplicar prácticas básicas de optimización y análisis estático.

## Qué incluye
- **Ejemplo guiado:** `ContadorProvider` (ChangeNotifier) con `Consumer`, `context.read` y widgets `const`.
- **Ejercicio evaluable:** refactorización de la práctica 5 (consumo de JSONPlaceholder): servicio HTTP, modelo, `PostsProvider` con estados (carga, error, vacío, lista) y widgets reutilizables.
- **Paquetes externos justificados:** `provider` (estado compartido sin pasar datos manualmente) e `intl` (formato de fechas).

## Requisitos
- Flutter SDK, Chrome (y Edge u otro destino para comparar)
- Paquetes: `provider`, `intl`, `http`

## Instalación
Desde la raíz del repositorio clonado, en la rama de la práctica:
```bash
flutter create practica_07_arquitectura_josue
cd practica_07_arquitectura_josue
flutter pub add provider intl http
```
Copiar encima las carpetas `lib/` y `test/` y este `README.md`. **Borrar `test/widget_test.dart`** (prueba el contador de ejemplo de `flutter create`).

## Ejecución
```bash
flutter run -d chrome
flutter run -d edge        # segundo destino para comparar
```

## Estructura
```
lib/
  main.dart
  models/      post.dart
  services/    api_service.dart
  providers/   contador_provider.dart, posts_provider.dart
  screens/     home_screen.dart, posts_screen.dart, contador_screen.dart
  widgets/     encabezado, contador_card, botones_contador, post_card,
               estado_vista, actualizacion_banner
test/          contador_provider_test, posts_provider_test, contador_screen_test
```

## Optimización aplicada
- Widgets `const` siempre que es posible y widgets pequeños reutilizables.
- `ListView.builder` para la lista de publicaciones.
- `Consumer` solo alrededor de la tarjeta que cambia; los botones usan `context.read`.
- Sin trabajo costoso dentro de `build()`.
- Para medir: DevTools > Widget Inspector > *Track widget rebuilds*.

## Pruebas
```bash
dart format .
flutter analyze
flutter test
```
Casos manuales: contador, carga de publicaciones, error con la red en *Offline*, reintento, y ejecución en dos destinos (registrar diferencias).

## Participantes
- (Nombre completo) – práctica individual

## Entrega en GitHub
```bash
git checkout develop
git pull origin develop
git checkout -b practica-07-arquitectura-josue
# desarrollar y comprobar la práctica
dart format .
flutter analyze
flutter test
git add .
git commit -m "feat: completa practica 07"
git push -u origin practica-07-arquitectura-josue
```
Crear la pull request hacia `develop` (propósito, funciones, pasos para ejecutar, pruebas, capturas y pendientes). Evidencias en `docs/evidencias/practica-07/josue/`. No subir `.dart_tool`, `build`, credenciales ni archivos generados.
