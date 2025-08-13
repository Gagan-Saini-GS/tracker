import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tracker/enums/notification_type.dart';
import 'package:tracker/models/notification_props.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService() {
    _init();
  }

  /// Initialize the notification plugin
  Future<void> _init() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  /// Public function to send a notification
  Future<void> sendNotification(NotificationProps props) async {
    switch (props.type) {
      case NotificationType.simple:
        return _sendSimpleNotification(props.title, props.body);
      // Currently not sending any scheduled notification
      case NotificationType.scheduled:
        return;
      case NotificationType.bigText:
        if (props.bigText == null) {
          throw ArgumentError(
            "Big text cannot be null for big text notifications.",
          );
        }
        return _sendBigTextNotification(
          props.title,
          props.body,
          props.bigText!,
        );
    }
  }

  /// Private: Send a simple notification
  Future<void> _sendSimpleNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'simple_channel_id',
      'Simple Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  /// Private: Send a big text notification
  Future<void> _sendBigTextNotification(
    String title,
    String body,
    String bigText,
  ) async {
    final bigTextStyle = BigTextStyleInformation(
      bigText,
      contentTitle: title,
      summaryText: body,
    );

    final androidDetails = AndroidNotificationDetails(
      'bigtext_channel_id',
      'Big Text Notifications',
      styleInformation: bigTextStyle,
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      2,
      title,
      body,
      notificationDetails,
    );
  }
}
