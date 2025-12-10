import 'dart:ui';

class NotificationItem {
  final String initials;
  final Color avatarColor;
  final String title;
  final String timestamp;
  final String message;
  final bool isUnread;

  NotificationItem({
    required this.initials,
    required this.avatarColor,
    required this.title,
    required this.timestamp,
    required this.message,
    required this.isUnread,
  });
}