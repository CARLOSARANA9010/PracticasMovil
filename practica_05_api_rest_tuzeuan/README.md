# Práctica 05: Consumo de API REST con Flutter

## 1. Objetivo

Desarrollar una aplicación móvil utilizando Flutter que consuma una API REST pública mediante solicitudes HTTP GET, procese respuestas en formato JSON y convierta los datos recibidos en objetos Dart.

La aplicación permite consultar información de usuarios, visualizar sus datos y acceder a una pantalla con información detallada.

## 2. API utilizada

**DummyJSON – Users API**

- URL base: https://dummyjson.com
- Endpoint: `https://dummyjson.com/users`
- Método HTTP: GET
- Formato de respuesta: JSON
- Autenticación: No requiere autenticación.

Se utiliza DummyJSON como alternativa a JSONPlaceholder para consumir información de usuarios.

### Datos obtenidos

- Identificador.
- Nombre.
- Apellido.
- Correo electrónico.
- Teléfono.
- Fotografía de perfil.

## 3. Tecnologías y herramientas

- Flutter.
- Dart.
- Visual Studio Code.
- Google Chrome.
- Paquete HTTP (`http: ^1.6.0`).
- Git y GitHub.
- DummyJSON.

## 4. Requisitos previos

- Tener instalado Flutter SDK.
- Tener instalado Dart SDK.
- Tener instalado Visual Studio Code.
- Disponer de Google Chrome.
- Contar con conexión a Internet para consumir la API.

## 5. Instalación

Clonar el repositorio:

```bash
git clone https://github.com/CARLOSARANA9010/PracticasMovil.git
```

Entrar en la carpeta de la práctica:

```bash
cd PracticasMovil/practica_05_api_rest_tuzeuan
```

Instalar las dependencias:

```bash
flutter pub get
```

## 6. Ejecución

Ejecutar la aplicación en Google Chrome:

```bash
flutter run -d chrome
```

## 7. Organización del proyecto

```text
practica_05_api_rest_tuzeuan/
│
├── lib/
│   ├── models/
│   │   └── user.dart
│   │
│   ├── services/
│   │   └── user_service.dart
│   │
│   ├── screens/
│   │   ├── users_screen.dart
│   │   └── user_detail_screen.dart
│   │
│   └── main.dart
│
├── test/
│   └── widget_test.dart
│
├── docs/
│   └── evidencias/
│       └── practica-05/
│
├── pubspec.yaml
├── pubspec.lock
└── README.md
```

## 8. Funcionalidades implementadas

- Consumo de API REST mediante HTTP GET.
- Validación del código de respuesta HTTP.
- Conversión de JSON a objetos Dart mediante el modelo User.
- Visualización de usuarios en una lista.
- Visualización de fotografías, nombres y correos electrónicos.
- Consulta del detalle de cada usuario.
- Indicador de carga.
- Manejo de errores de conexión y del servidor.
- Mensaje cuando no existen usuarios disponibles.
- Botón para actualizar la información.
- Funcionalidad para reintentar una solicitud fallida.

## 9. Pruebas realizadas

Se realizaron las siguientes comprobaciones:

| Prueba | Resultado |
|---|---|
| Conversión de JSON a User | Aprobada |
| Generación del nombre completo | Aprobada |
| Visualización de lista vacía | Aprobada |
| Consumo de DummyJSON | Correcto |
| Visualización de usuarios | Correcto |
| Navegación al detalle | Correcto |
| Manejo de errores de conexión | Comprobado |
| Recuperación de conexión | Comprobada |

### Comandos de validación

Formatear el código:

```bash
dart format .
```

Analizar el proyecto:

```bash
flutter analyze
```

Ejecutar las pruebas:

```bash
flutter test
```

**Resultados obtenidos:**

- Dart Format: 6 archivos formateados.
- Flutter Analyze: No issues found.
- Flutter Test: 3 pruebas aprobadas.

## 10. Evidencias

Las capturas de pantalla de la aplicación y de las comprobaciones se almacenan en:

`docs/evidencias/practica-05/`

## 11. Participantes

- Eduardo Tuz Euan.

## 12. Repositorio y rama de trabajo

Repositorio: https://github.com/CARLOSARANA9010/PracticasMovil

Rama de trabajo: `practica-05-api-rest-TuzEuan`

Pull Request: Pendiente de creación.

Commit final: Pendiente de publicación.
