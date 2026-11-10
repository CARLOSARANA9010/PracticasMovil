# Práctica 9 – Cámara multimedia y sensores de movimiento

## Objetivo
Integrar captura de imágenes y lectura de sensores para crear interacción con hardware del dispositivo.

## Qué incluye
- **Ejemplo guiado (pestaña "Ejemplo guiado"):** botón "Tomar fotografía" y lectura de acelerómetro y giroscopio.
- **Ejercicio evaluable (pestaña "Bitácora"):** captura de foto, fecha/hora y valores actuales de ambos sensores en una tarjeta de evidencia; manejo de cancelación de cámara y de permisos.
- Los sensores se escuchan con flujos (`Stream`) sin bloquear la interfaz; cada lectura usa un `ValueNotifier` para reconstruir solo su widget. Si el sensor no existe (por ejemplo en una laptop) se muestra un mensaje.
- La imagen se muestra con `Image.memory` (bytes), compatible con móvil, web y escritorio.

## Requisitos
- Flutter SDK; **para ver valores reales de los sensores se necesita un celular o tableta** (en laptops suelen no existir)
- Paquetes: `image_picker`, `sensors_plus`, `intl`

## Instalación
```bash
flutter create practica_09_multimedia_sensores_josue
cd practica_09_multimedia_sensores_josue
flutter pub add image_picker sensors_plus intl
```
Copiar `lib/`, `test/` y este `README.md`. Borrar `test/widget_test.dart`.

### Permisos (solo para iOS; Android no requiere declarar permisos para la cámara con image_picker)
`ios/Runner/Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>Se usa la cámara para tomar fotografías de evidencia.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Se accede a las fotos para adjuntar evidencia.</string>
<key>NSMotionUsageDescription</key>
<string>Se leen los sensores de movimiento para la bitácora.</string>
```
Si la versión de `sensors_plus` o `image_picker` exige más configuración, seguir su documentación en pub.dev.

## Ejecución
```bash
flutter run -d chrome     # cámara/archivo y mensajes de sensor no disponible
flutter run               # con un dispositivo físico conectado
```
En web, la lectura de sensores requiere un navegador móvil y contexto seguro (HTTPS o `localhost`).

## Estructura
```
lib/
  main.dart
  models/    lectura_sensor.dart, registro_inspeccion.dart
  services/  sensores_service.dart, monitor_sensores.dart, camara_service.dart
  screens/   home_screen.dart, bitacora_screen.dart, ejemplo_guiado_screen.dart
  widgets/   lectura_card.dart, tarjeta_evidencia.dart
test/        logica_test.dart
```

## Pruebas
```bash
dart format .
flutter analyze
flutter test
```
Casos manuales: tomar foto, cancelar la cámara, negar el permiso, mover el dispositivo y observar X/Y/Z, capturar evidencia y eliminarla.

## Participantes
- (Nombre completo) – práctica individual

## Entrega en GitHub
```bash
git checkout develop
git pull origin develop
git checkout -b practica-09-multimedia-sensores-josue
dart format .
flutter analyze
flutter test
git add .
git commit -m "feat: completa practica 09"
git push -u origin practica-09-multimedia-sensores-josue
```
Pull request hacia `develop`. Evidencias en `docs/evidencias/practica-09/josue/` (puede incluirse un GIF o video breve mediante enlace).
