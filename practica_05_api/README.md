# Práctica 05 · Consumo de API REST y procesamiento JSON

## Objetivo
Consumir un servicio REST mediante HTTP, convertir JSON a objetos Dart y representar los estados de carga, éxito, error y lista vacía.

## Funciones
- **Ejemplo guiado** (`UsuariosPage`): lista de usuarios de `/users` (botón 👥 en la barra superior).
- **Ejercicio evaluable** (`PostsPage`): las 100 publicaciones de `/posts` con título y cuerpo, indicador de carga, error con botón *Reintentar*, mensaje de lista vacía, `RefreshIndicator` (deslizar hacia abajo) y pantalla de detalle al tocar una publicación (`PostDetallePage`).

## API consumida
| Endpoint | Método | Respuesta |
|----------|--------|-----------|
| `https://jsonplaceholder.typicode.com/users` | GET | `[{"id": 1, "name": "...", "email": "..."}]` |
| `https://jsonplaceholder.typicode.com/posts` | GET | `[{"userId": 1, "id": 1, "title": "...", "body": "..."}]` |

Si el status no es `200` se lanza `Exception('HTTP <código>')` y la UI muestra el error. La petición tiene un timeout de 10 s.

## Estructura
```
lib/
  main.dart
  models/      post.dart, usuario.dart   (factory fromJson)
  services/    api.dart                  (http.get + validación de status + jsonDecode)
  screens/     posts_page.dart, post_detalle_page.dart, usuarios_page.dart,
               estados.dart              (carga / error / vacío / éxito)
test/
  widget_test.dart                       (modelos, lista + detalle, error 500, lista vacía)
```

## Requisitos
- Flutter SDK (Dart ^3.x)
- Conexión a Internet
- Paquete `http` (ya incluido en `pubspec.yaml`)
- Android: permiso `INTERNET` ya agregado en `AndroidManifest.xml`

## Instalación y ejecución
```bash
cd practica_05_api
flutter pub get
flutter run            # elegir dispositivo (Android, Chrome o Windows)
```

## Pruebas
```bash
flutter analyze        # No issues found!
flutter test           # 5 pruebas: All tests passed!
```
Las pruebas de widgets usan `MockClient` de `package:http/testing.dart`, así no dependen de la red.

## Participantes
- Carlos Rivera
