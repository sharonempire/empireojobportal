import 'package:empire_job/features/application/authentication/controller/auth_controller.dart';
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/routes/router_consts.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:empire_job/shared/providers/theme_providers.dart';
import 'package:empire_job/shared/styles/appstyles.dart';
import 'package:empire_job/shared/utils/snackbar_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonNavbar extends ConsumerWidget {
  const CommonNavbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isSmallScreen = AppStyles.isSmallScreen(context);
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final authState = ref.watch(authControllerProvider);
    final isVerified = authState.isVerified;

    return Container(
      padding: isSmallScreen
          ? const EdgeInsets.all(10)
          : const EdgeInsets.symmetric(horizontal: 70, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: context.themeDark.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _BrandLogo(),
          const Spacer(),
          Row(
            children: [
              _NavIconButton(
                label: 'Dashboard',
                onPressed: isVerified
                    ? () {
                        final currentLocation = GoRouterState.of(
                          context,
                        ).uri.toString();
                        if (!currentLocation.contains(RouterConsts.dashboardPath)) {
                          context.go(RouterConsts.dashboardPath);
                        }
                      }
                    : () {
                        context.showErrorSnackbar(
                          'Please verify your account to access the dashboard',
                        );
                      },
                isActive: GoRouterState.of(
                  context,
                ).uri.toString().contains(RouterConsts.dashboardPath),
                isDisabled: !isVerified,
              ),
              const SizedBox(width: 20),
              _NavIconButton(
                label: 'Jobs',
                onPressed: isVerified
                    ? () {
                        final currentLocation = GoRouterState.of(
                          context,
                        ).uri.toString();
                        if (!currentLocation.contains(RouterConsts.manageJobsPath)) {
                          context.go(RouterConsts.manageJobsPath);
                        }
                      }
                    : () {
                        context.showErrorSnackbar(
                          'Please verify your account to access jobs',
                        );
                      },
                showBadge: true,
                isActive: GoRouterState.of(
                  context,
                ).uri.toString().contains(RouterConsts.manageJobsPath),
                isDisabled: !isVerified,
              ),
              const SizedBox(width: 20),
              _NavIconButton(
                label: 'Settings',
                onPressed: () {
                  if (kIsWeb) {
                    final currentLocation = GoRouterState.of(
                      context,
                    ).uri.toString();
                    if (!currentLocation.contains(RouterConsts.settingsPath)) {
                      context.go(RouterConsts.settingsPath);
                    }
                  }
                },
                isActive: GoRouterState.of(
                  context,
                ).uri.toString().contains(RouterConsts.settingsPath),
              ),
              const SizedBox(width: 20),
              _NotificationIconButton(),
              const SizedBox(width: 20),
              _ProfileSection(),
            ],
          ),
        ],
      ),
    );
  }
}

class _BrandLogo extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        final currentLocation = GoRouterState.of(context).uri.toString();
        if (!currentLocation.contains(RouterConsts.dashboardPath)) {
          context.go(RouterConsts.dashboardPath);
        }
      },
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : context.themeDark,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'E',
                style: GoogleFonts.inter(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? context.themeDark
                      : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          CustomText(
            text: 'Empireo',
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}

class _NavIconButton extends StatelessWidget {
  // final String icon;
  final String? label;
  final VoidCallback onPressed;
  final bool showBadge;
  final bool hideLabel;
  final bool isActive;
  final bool isDisabled;

  const _NavIconButton({
    // required this.icon,
    this.label,
    required this.onPressed,
    this.showBadge = false,
    this.hideLabel = false,
    this.isActive = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDisabled
        ? context.themeIconGrey
        :  context.themeDark ;

    return InkWell(
      onTap: isDisabled ? null : onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Stack(
                children: [
                  // SvgPicture.asset(
                  //   icon,
                  //   width: 20,
                  //   height: 20,
                  //   colorFilter: ColorFilter.mode(
                  //     Theme.of(context).iconTheme.color ?? ColorConsts.black,
                  //     BlendMode.srcIn,
                  //   ),
                  // ),
                  // if (showBadge)
                  //   Positioned(
                  //     right: 0,
                  //     top: 0,
                  //     child: Container(
                  //       width: 8,
                  //       height: 8,
                  //       decoration: const BoxDecoration(
                  //         color: Colors.red,
                  //         shape: BoxShape.circle,
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
              if (label != null && !hideLabel) ...[
                const SizedBox(width: 8),
                CustomText(
                  text: label!,
                  color: textColor,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                  fontSize: 14,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationIconButton extends StatelessWidget {
  const _NotificationIconButton();

  @override
  Widget build(BuildContext context) {
    final isActive = GoRouterState.of(context).uri.toString().contains(
          RouterConsts.notificationsPath,
        );
    final hasUnreadNotifications = true; // TODO: Replace with actual notification state

    return InkWell(
      onTap: () {
        if (kIsWeb) {
          final currentLocation = GoRouterState.of(context).uri.toString();
          if (!currentLocation.contains(RouterConsts.notificationsPath)) {
            context.go(RouterConsts.notificationsPath);
          }
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Icon(
              Icons.notifications_outlined,
              size: 24,
              color: isActive
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).iconTheme.color,
            ),
            if (hasUnreadNotifications)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProfileSection extends ConsumerWidget {
  const _ProfileSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [const CircleAvatar(radius: 16)]),
      ),
    );
  }
}
