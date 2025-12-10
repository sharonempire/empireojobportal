import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({
    super.key,
    this.title,
    this.showBackButton = false,
    this.showProfile = false,
    this.showNotification = false,
    this.profileName,
    this.profileImageUrl,
    this.onBackPressed,
    this.onNotificationPressed,
    this.onProfilePressed,
    this.actions,
  });

  /// Title text to display (used when showProfile is false)
  final String? title;

  /// Show back button on the left
  final bool showBackButton;

  /// Show profile section with image and name
  final bool showProfile;

  /// Show notification icon on the right
  final bool showNotification;

  /// Profile name to display
  final String? profileName;

  /// Profile image URL
  final String? profileImageUrl;

  /// Callback when back button is pressed
  final VoidCallback? onBackPressed;

  /// Callback when notification icon is pressed
  final VoidCallback? onNotificationPressed;

  /// Callback when profile is pressed
  final VoidCallback? onProfilePressed;

  /// Additional action widgets
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorConsts.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // Left side: Back button or Profile
            if (showBackButton) ...[
              GestureDetector(
                onTap: onBackPressed ?? () => Navigator.of(context).pop(),
                child: const Icon(
                  Icons.chevron_left,
                  size: 28,
                  color: ColorConsts.black,
                ),
              ),
              const SizedBox(width: 8),
              if (title != null)
                CustomText(
                  text: title!,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorConsts.black,
                ),
            ] else if (showProfile) ...[
              GestureDetector(
                onTap: onProfilePressed,
                child: Row(
                  children: [
                    _buildProfileImage(),
                    const SizedBox(width: 12),
                    CustomText(
                      text: profileName ?? 'User',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: ColorConsts.black,
                    ),
                  ],
                ),
              ),
            ] else if (title != null) ...[
              CustomText(
                text: title!,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: ColorConsts.black,
              ),
            ],

            const Spacer(),

            // Right side: Actions or Notification
            if (actions != null) ...actions!,
            if (showNotification) _buildNotificationIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: ColorConsts.lightGrey, width: 1),
        image: profileImageUrl != null
            ? DecorationImage(
                image: NetworkImage(profileImageUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: profileImageUrl == null
          ? const Icon(Icons.person, color: ColorConsts.iconGrey)
          : null,
    );
  }

  Widget _buildNotificationIcon() {
    return GestureDetector(
      onTap: onNotificationPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: ColorConsts.lightGrey, width: 1),
        ),
        child: const Icon(
          Icons.notifications_outlined,
          size: 18,
          color: ColorConsts.black,
        ),
      ),
    );
  }
}
