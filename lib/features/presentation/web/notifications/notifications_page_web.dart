import 'package:empire_job/features/application/notifications/models/notification_item_model.dart';
import 'package:empire_job/features/presentation/web/notifications/widgets/filter_button_widget.dart';
import 'package:empire_job/features/presentation/web/notifications/widgets/notification_tile_widget.dart';
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/features/presentation/widgets/responsive_horizontal_scroll.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationsPageWeb extends StatefulWidget {
  const NotificationsPageWeb({super.key});

  @override
  State<NotificationsPageWeb> createState() => _NotificationsPageWebState();
}

class _NotificationsPageWebState extends State<NotificationsPageWeb> {
  String _selectedFilter = 'All';

  final List<NotificationItem> _notifications = [
    NotificationItem(
      initials: 'SE',
      avatarColor: Colors.blue,
      title: 'Senior Software Engineer',
      timestamp: '1h ago',
      message: 'Your job posting "Senior Software Engineer" has been published successfully.',
      isUnread: true,
    ),
    NotificationItem(
      initials: 'ME',
      avatarColor: Colors.orange,
      title: 'Mechanical Engineer',
      timestamp: '1h 30m ago',
      message: 'Your job posting for "Mechanical Engineer - Dubai" is pending review.',
      isUnread: true,
    ),
    NotificationItem(
      initials: 'SD',
      avatarColor: Colors.red,
      title: 'Software Developer',
      timestamp: '1h ago',
      message: 'You received 12 new applications for "Software Developer - Canada"',
      isUnread: true,
    ),
    NotificationItem(
      initials: 'SE',
      avatarColor: Colors.green,
      title: 'Software Engineer',
      timestamp: '1h ago',
      message: 'Your job post "Sales Executive - Dubai" has reached 100+ views.',
      isUnread: false,
    ),
    NotificationItem(
      initials: 'SE',
      avatarColor: Colors.blue,
      title: 'Senior Software Engineer',
      timestamp: '1h ago',
      message: 'Your job posting "Senior Software Engineer" has been published successfully.',
      isUnread: true,
    ),
    NotificationItem(
      initials: 'ME',
      avatarColor: Colors.orange,
      title: 'Mechanical Engineer',
      timestamp: '1h 30m ago',
      message: 'Your job posting for "Mechanical Engineer - Dubai" is pending review.',
      isUnread: true,
    ),
    NotificationItem(
      initials: 'SD',
      avatarColor: Colors.red,
      title: 'Software Developer',
      timestamp: '1h ago',
      message: 'You received 12 new applications for "Software Developer - Canada"',
      isUnread: true,
    ),
    NotificationItem(
      initials: 'SE',
      avatarColor: Colors.green,
      title: 'Software Engineer',
      timestamp: '1h ago',
      message: 'Your job post "Sales Executive - Dubai" has reached 100+ views.',
      isUnread: false,
    ),
  ];

  List<NotificationItem> get _filteredNotifications {
    if (_selectedFilter == 'Unread') {
      return _notifications.where((n) => n.isUnread).toList();
    }
    return _notifications;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.themeScaffoldCourse,
      body: ResponsiveHorizontalScroll(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 100,
                      vertical: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios,size: 18,),
                              onPressed: () => context.pop(),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 32),
                            const CustomText(
                              text: 'Notifications',
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                            ),
                            const Spacer(),
                            FilterButtonWidget(
                              label: 'All',
                              isSelected: _selectedFilter == 'All',
                              onTap: () => setState(() => _selectedFilter = 'All'),
                            ),
                            const SizedBox(width: 16),
                            FilterButtonWidget(
                              label: 'Unread',
                              isSelected: _selectedFilter == 'Unread',
                              onTap: () => setState(() => _selectedFilter = 'Unread'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _filteredNotifications.length,
                            separatorBuilder: (context, index) => Divider(
                              height: 1,
                              thickness: 1,
                              color: context.themeDivider,
                            ),
                            itemBuilder: (context, index) {
                              final notification = _filteredNotifications[index];
                              return NotificationTileWidget(
                                notification: notification,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}







