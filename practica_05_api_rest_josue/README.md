# Práctica 5 – Consumo de API REST y procesamiento JSON

## Objetivo
Consumir un servicio REST mediante HTTP, convertir JSON a objetos Dart y representar estados de carga, éxito, error y lista vacía.

## Requisitos
- Flutter SDK instalado
- Conexión a Internet
- Paquete `http`
- Git y GitHub

## Instalación
```bash
flutter create practica_05_api   # si aún no existe el proyecto
cd practica_05_api
flutter pub add http
```
Copiar las carpetas `lib/` y `test/` de este proyecto.

En Android, verificar que `android/app/src/main/AndroidManifest.xml` incluya:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

## Ejecución
```bash
flutter run
```

## Funcionalidades
- Ejemplo guiado: lista de usuarios (`/users`) con `FutureBuilder`.
- Ejercicio evaluable: lista de 100 publicaciones (`/posts`) con título y cuerpo.
- Indicador de carga, manejo de error con botón "Reintentar", lista vacía.
- Actualización con `RefreshIndicator` (pull to refresh).
- Pantalla de detalle al tocar una publicación.

## Estructura
```
lib/
  main.dart
  models/        usuario.dart, post.dart
  services/      api_service.dart
  pages/         usuarios_page.dart, posts_page.dart, post_detalle_page.dart
test/
  api_test.dart
```

## Vinculación con el proyecto integrador
- Endpoint: `GET https://jsonplaceholder.typicode.com/posts`
- Método: GET
- JSON: `[{ "userId": 1, "id": 1, "title": "...", "body": "..." }]`

## Pruebas
```bash
dart format .
flutter analyze
flutter test
```
Casos manuales: carga inicial, pull to refresh, modo avión (error), tocar publicación (detalle).



## Entrega en GitHub
```bash
git checkout develop
git pull origin develop
git checkout -b practica-05-api-rest
dart format .
flutter analyze
flutter test
git add .
git commit -m "feat: completa practica 05"
git push -u origin practica-05-api-rest
```
Después, crear la pull request hacia `develop` (propósito, funciones, pasos para ejecutar, pruebas, capturas y pendientes). Evidencias en `docs/evidencias/practica-05/`.
