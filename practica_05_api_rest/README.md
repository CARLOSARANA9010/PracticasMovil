Práctica 5: Consumo de API REST y Procesamiento JSON

Objetivo

Consumir un servicio REST mediante HTTP, convertir las respuestas JSON a objetos Dart fuertemente tipados y representar visualmente los estados de la petición (carga, éxito y error) en una aplicación móvil construida con Flutter.

Requisitos

Para ejecutar este proyecto, necesitas tener instalado lo siguiente en tu entorno de desarrollo:

Flutter SDK (Versión estable más reciente recomendada).

Dart SDK (Incluido con Flutter).

Un emulador (Android/iOS) o un dispositivo físico configurado para depuración.

Conexión a Internet activa (requerida para consumir la API pública).

Editor de código (Visual Studio Code o Android Studio).

Instalación

Sigue estos pasos para clonar y preparar el entorno local:

Ubícate en la rama correspondiente a la práctica:

git checkout practica-05-api-rest


Instala las dependencias del proyecto (incluyendo el paquete http):

flutter pub get


Ejecución

Para compilar y correr la aplicación en tu dispositivo o emulador, ejecuta el siguiente comando en la raíz del proyecto de la práctica:

flutter run


Comandos de Calidad (Pruebas y Formato)

Antes de realizar cualquier modificación, verifica que el código cumple con los estándares:

Dar formato al código: dart format .

Analizar sintaxis: flutter analyze

Ejecutar pruebas automatizadas: flutter test

Características Implementadas

Consumo REST: Petición GET al endpoint /posts de JSONPlaceholder.

Mapeo de Datos: Conversión de JSON dinámico al modelo Post de Dart.

Manejo de Estados UI:

CircularProgressIndicator durante la carga.

Diseño visual amigable y botón de reintento en caso de error o falta de internet.

RefreshIndicator para actualizar la lista interactiva.

Navegación: Pantalla de detalle (PostDetailPage) al tocar cualquier publicación.
