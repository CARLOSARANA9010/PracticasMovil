import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Notificaciones locales (Parte A del manual).
/// En web el paquete no está disponible: [mostrarRegistroGuardado] devuelve
/// false y la interfaz muestra un aviso dentro de la aplicación.
///
/// Nota: la API exacta puede variar entre versiones de flutter_local_notifications.
/// Si el compilador marca errores en initialize/show, revisar la documentación
/// de la versión declarada en pubspec.lock y ajustar solo este archivo.
class NotificacionesService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static bool _listo = false;

  static bool get disponible => _listo;

  static Future<void> iniciar() async {
    if (kIsWeb) return;
    try {
      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      const ios = DarwinInitializationSettings();
      const settings = InitializationSettings(android: android, iOS: ios);
      await _plugin.initialize(settings: settings);
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
      _listo = true;
    } catch (_) {
      _listo = false;
    }
  }

  /// Devuelve true si se mostró una notificación del sistema.
  static Future<bool> mostrarRegistroGuardado(String lugar) async {
    if (!_listo) return false;
    try {
      const detalles = NotificationDetails(
        android: AndroidNotificationDetails(
          'canal_registros',
          'Registros de visitas',
          channelDescription: 'Avisos al guardar un registro',
          importance: Importance.high,
          priority: Priority.high,
        ),
      );
      await _plugin.show(
        id: (DateTime.now().millisecondsSinceEpoch ~/ 1000) % 100000,
        title: 'Registro guardado',
        body: 'Se guardó tu visita a $lugar',
        notificationDetails: detalles,
      );
      return true;
    } catch (_) {
      return false;
    }
  }
}
