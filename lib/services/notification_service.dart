import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  NotificationService() {
    _init();
  }

  Future<void> _init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidInit);
    await _plugin.initialize(settings);
  }

  Future<void> showNow(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'petcare_channel',
      'PetCare Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const notifDetails = NotificationDetails(android: androidDetails);
    await _plugin.show(0, title, body, notifDetails);
  }
}
