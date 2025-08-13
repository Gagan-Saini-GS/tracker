import 'package:tracker/enums/notification_type.dart';

/// Props for sending a notification
class NotificationProps {
  final String title;
  final String body;
  final NotificationType type;
  final DateTime? scheduledTime; // For scheduled notifications
  final String? bigText; // For big text notifications

  NotificationProps({
    required this.title,
    required this.body,
    required this.type,
    this.scheduledTime,
    this.bigText,
  });
}
