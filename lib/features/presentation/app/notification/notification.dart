import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:empire_job/shared/utils/responsive.dart';
import 'package:empire_job/shared/widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, List<NotificationItem>>((ref) {
      return NotificationsNotifier();
    });

class NotificationsNotifier extends StateNotifier<List<NotificationItem>> {
  NotificationsNotifier() : super(_getInitialNotifications());

  static List<NotificationItem> _getInitialNotifications() {
    return [
      NotificationItem(
        initials: 'SE',
        avatarColor: const Color(0xFF4CAF50),
        title: 'Senior Software Engineer',
        timestamp: '1h ago',
        message:
            'Your job posting "Senior Software Engineer" has been published successfully.',
        isUnread: true,
      ),
      NotificationItem(
        initials: 'ME',
        avatarColor: const Color(0xFFFF9800),
        title: 'Mechanical Engineer',
        timestamp: '1h 30m ago',
        message:
            'Your job posting for "Mechanical Engineer - Dubai" is pending review.',
        isUnread: true,
      ),
      NotificationItem(
        initials: 'SD',
        avatarColor: const Color(0xFFF44336),
        title: 'Software Developer',
        timestamp: '1h ago',
        message:
            'You received 12 new applications for "Software Developer - Canada"',
        isUnread: true,
      ),
      NotificationItem(
        initials: 'SE',
        avatarColor: const Color(0xFF9E9E9E),
        title: 'Software Engineer',
        timestamp: '1h ago',
        message:
            'Your job post "Sales Executive - Dubai" has been published successfully.',
        isUnread: false,
      ),
      NotificationItem(
        initials: 'SE',
        avatarColor: const Color(0xFF2196F3),
        title: 'Senior Software Engineer',
        timestamp: '1h ago',
        message:
            'Your job posting "Senior Software Engineer" has been published successfully.',
        isUnread: false,
      ),
      NotificationItem(
        initials: 'ME',
        avatarColor: const Color(0xFFFF9800),
        title: 'Mechanical Engineer',
        timestamp: '1h 30m ago',
        message:
            'Your job posting for "Mechanical Engineer - Dubai" is pending review.',
        isUnread: false,
      ),
      NotificationItem(
        initials: 'SD',
        avatarColor: const Color(0xFFF44336),
        title: 'Software Developer',
        timestamp: '1h ago',
        message:
            'You received 12 new applications for "Software Developer - Canada"',
        isUnread: false,
      ),
    ];
  }

  void markAsRead(int index) {
    if (index >= 0 && index < state.length) {
      final notification = state[index];
      if (notification.isUnread) {
        state = [
          ...state.sublist(0, index),
          NotificationItem(
            initials: notification.initials,
            avatarColor: notification.avatarColor,
            title: notification.title,
            timestamp: notification.timestamp,
            message: notification.message,
            isUnread: false,
          ),
          ...state.sublist(index + 1),
        ];
      }
    }
  }

  void markAllAsRead() {
    state = state
        .map(
          (n) => NotificationItem(
            initials: n.initials,
            avatarColor: n.avatarColor,
            title: n.title,
            timestamp: n.timestamp,
            message: n.message,
            isUnread: false,
          ),
        )
        .toList();
  }
}

class NotificationPageApp extends ConsumerStatefulWidget {
  const NotificationPageApp({super.key});

  @override
  ConsumerState<NotificationPageApp> createState() =>
      _NotificationPageAppState();
}

class _NotificationPageAppState extends ConsumerState<NotificationPageApp> {
  int _selectedTab = 0;

  List<NotificationItem> _getFilteredNotifications(
    List<NotificationItem> notifications,
  ) {
    if (_selectedTab == 1) {
      return notifications.where((n) => n.isUnread).toList();
    }
    return notifications;
  }

  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationsProvider);
    final filteredNotifications = _getFilteredNotifications(notifications);

    return Scaffold(
      backgroundColor: ColorConsts.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(notifications),
            // Notification List
            Expanded(
              child: filteredNotifications.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_off_outlined,
                            size: context.rIconSize(48),
                            color: ColorConsts.iconGrey,
                          ),
                          SizedBox(height: context.rSpacing(16)),
                          CustomText(
                            text: _selectedTab == 1
                                ? 'No unread notifications'
                                : 'No notifications yet',
                            fontSize: context.rFontSize(14),
                            color: ColorConsts.textColor,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.rSpacing(16),
                        vertical: context.rSpacing(8),
                      ),
                      itemCount: filteredNotifications.length,
                      itemBuilder: (context, index) {
                        final notification = filteredNotifications[index];
                        final actualIndex = notifications.indexOf(notification);
                        return GestureDetector(
                          onTap: () {
                            ref
                                .read(notificationsProvider.notifier)
                                .markAsRead(actualIndex);
                          },
                          child: Column(
                            children: [
                              _buildNotificationItem(notification),
                              Divider(
                                color: ColorConsts.lightGrey,
                                thickness: 1,
                                height: context.rSpacing(24),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(List<NotificationItem> notifications) {
    final unreadCount = notifications.where((n) => n.isUnread).length;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.rSpacing(16),
        vertical: context.rSpacing(12),
      ),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () => context.pop(),
            child: Icon(
              Icons.chevron_left,
              size: context.rIconSize(25),
              color: ColorConsts.black,
            ),
          ),
          SizedBox(width: context.rSpacing(8)),
          // Title
          CustomText(
            text: 'Notifications',
            fontSize: context.rFontSize(16),
            fontWeight: FontWeight.bold,
            color: ColorConsts.black,
          ),
          const Spacer(),
          // Filter Tabs
          _buildFilterTab('All', 0),
          SizedBox(width: context.rSpacing(8)),
          _buildFilterTab('Unread', 1),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String label, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? ColorConsts.lightGrey : ColorConsts.white,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: context.rSpacing(12),
          vertical: context.rSpacing(6),
        ),

        child: CustomText(
          text: label,
          fontSize: context.rFontSize(10),
          fontWeight: FontWeight.w500,
          color: isSelected
              ? ColorConsts.textColorBlack
              : ColorConsts.textColorBlack,
        ),
      ),
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    return Container(
      margin: EdgeInsets.only(bottom: context.rSpacing(12)),
      padding: EdgeInsets.all(context.rSpacing(12)),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: context.rSpacing(40),
            height: context.rSpacing(40),
            decoration: BoxDecoration(
              color: notification.avatarColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomText(
                text: notification.initials,
                fontSize: context.rFontSize(14),
                fontWeight: FontWeight.bold,
                color: ColorConsts.white,
              ),
            ),
          ),
          SizedBox(width: context.rSpacing(12)),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomText(
                        text: notification.title,
                        fontSize: context.rFontSize(14),
                        fontWeight: FontWeight.w600,
                        color: ColorConsts.black,
                      ),
                    ),
                    CustomText(
                      text: notification.timestamp,
                      fontSize: context.rFontSize(11),
                      color: ColorConsts.textColor,
                    ),
                  ],
                ),
                SizedBox(height: context.rSpacing(4)),
                CustomText(
                  text: notification.message,
                  fontSize: context.rFontSize(12),
                  color: ColorConsts.textColor,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          // Unread Indicator
          if (notification.isUnread)
            Container(
              width: context.rSpacing(8),
              height: context.rSpacing(8),
              margin: EdgeInsets.only(
                left: context.rSpacing(8),
                top: context.rSpacing(6),
              ),
              decoration: const BoxDecoration(
                color: ColorConsts.colorGreen,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
