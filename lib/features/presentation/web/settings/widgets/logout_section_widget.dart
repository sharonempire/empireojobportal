import 'package:empire_job/features/data/storage/shared_preferences.dart';
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/features/presentation/widgets/primary_button_widget.dart';
import 'package:empire_job/routes/router_consts.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LogoutSectionWidget extends ConsumerStatefulWidget {
  const LogoutSectionWidget({super.key});

  @override
  ConsumerState<LogoutSectionWidget> createState() =>
      _LogoutSectionWidgetState();
}

class _LogoutSectionWidgetState extends ConsumerState<LogoutSectionWidget> {
  Future<void> _handleLogout() async {
    try {
      await Supabase.instance.client.auth.signOut();
      final prefs = ref.read(sharedPrefsProvider);
      await prefs.clear();

      if (mounted) {
        context.go(RouterConsts.loginPath);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error logging out: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Logout',
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(height: 8),
              CustomText(
                text: 'Securely end your session',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: context.themeIconGrey,
              ),
            ],
          ),
        ),
        const SizedBox(width: 40),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CustomText(
              //   text:
              //       'Log out to ensure your account stays protected, especially when using shared or public devices. You can easily sign back in whenever you need.',
              //   fontSize: 14,
              //   fontWeight: FontWeight.w400,
              //   color: context.themeIconGrey,
              // ),
              // const SizedBox(height: 40),
              _buildLogoutDialog(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutDialog(BuildContext context) {
    return Container(
      width: 600,
      padding: const EdgeInsets.all(56),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.themeBorderLightGrey, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            text: 'Are You Logging Out ?',
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 8),
          CustomText(
            text: 'Protect your privacy with one tap',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: context.themeIconGrey,
          ),
          const SizedBox(height: 16),
          CustomText(
            text:
                'Logging out ensures no one else can access your account after you\'re done. It\'s a simple step for stronger security.',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: context.themeIconGrey,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // PrimaryButtonWidget(
              //   text: 'Cancel',
              //   showShadow: false,
              //   onPressed: () {},
              //   backgroundColor: context.themeWhite,
              //   textColor: context.themeDark,
              //   height: 40,
              //   fontSize: 16,
              //   fontWeight: FontWeight.w600,
              //   borderRadius: 100,
              //   showBorder: true,
              //   borderColor: context.themeDivider,
              //   width: 140,
              // ),
              // const SizedBox(width: 16),
              PrimaryButtonWidget(
                text: 'Log out',
                onPressed: _handleLogout,
                backgroundColor: context.themeDark,
                textColor: context.themeWhite,
                height: 40,
                borderRadius: 100,
                width: 140,
                showShadow: false,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                showBorder: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
