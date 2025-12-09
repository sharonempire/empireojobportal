import 'package:empire_job/features/application/notifications/models/notification_item_model.dart';
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:flutter/material.dart';

class NotificationTileWidget extends StatelessWidget {
  final NotificationItem notification;

  const NotificationTileWidget({super.key, 
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, 
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: notification.avatarColor,
            child: CustomText(
              text: notification.initials,
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                Row(
                  children: [
                    CustomText(
                      text: notification.title,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(width: 12,),
                    CustomText(
                      text: notification.timestamp,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: context.themeGrey600,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                CustomText(
                  text: notification.message,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: context.themeGrey600,
                ),
              ],
            ),
          ),
          if (notification.isUnread) ...[
            const SizedBox(width: 12),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}