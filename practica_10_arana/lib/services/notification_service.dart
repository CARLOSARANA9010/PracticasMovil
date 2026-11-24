import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notificaciones {
  static final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> iniciar() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await plugin.initialize(settings: settings);

    await plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  static Future<void> mostrar({
    int id = 1,
    String titulo = 'Tópicos de Programación Móvil',
    String cuerpo = 'Tienes una actividad pendiente',
  }) async {
    const detalles = NotificationDetails(
      android: AndroidNotificationDetails(
        'canal_practica',
        'Práctica móvil',
        channelDescription: 'Alertas de la aplicación',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    await plugin.show(
      id: id,
      title: titulo,
      body: cuerpo,
      notificationDetails: detalles,
    );
  }
}
