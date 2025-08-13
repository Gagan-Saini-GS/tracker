import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker/services/notification_service.dart';

/// Provider for the NotificationService
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});
