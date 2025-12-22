import 'package:empire_job/features/application/authentication/controller/auth_controller.dart';
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:empire_job/shared/utils/bottonavigationbar.dart';
import 'package:empire_job/shared/utils/responsive.dart';
import 'package:empire_job/shared/widgets/common_app_bar.dart';
import 'package:empire_job/shared/widgets/shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsPageApp extends ConsumerStatefulWidget {
  const SettingsPageApp({super.key});

  @override
  ConsumerState<SettingsPageApp> createState() => _SettingsPageAppState();
}

class _SettingsPageAppState extends ConsumerState<SettingsPageApp> {
  void _onNavTap(int index) {
    switch (index) {
      case 0:
        context.goNamed('dashboard');
        break;
      case 1:
        context.goNamed('viewJob');
        break;
      case 2:
        // Already on settings
        break;
    }
  }

  Future<void> _handleLogout() async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Logout',
              style: TextStyle(color: ColorConsts.textColorRed),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      try {
        await ref.read(authControllerProvider.notifier).logout();
        if (mounted) {
          context.goNamed('splash');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: ColorConsts.textColorRed,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: ColorConsts.white,
      appBar: CommonAppBar(
        title: 'Settings',
        showBackButton: true,
        onBackPressed: () => context.goNamed('dashboard'),
      ),
      body: SafeArea(
        child: authState.isCheckingAuth
            ? const SettingsPageShimmer()
            : SingleChildScrollView(
          padding: EdgeInsets.all(context.rSpacing(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company Name Card
              _buildCompanyCard(authState),
              SizedBox(height: context.rSpacing(24)),
              // Account Section
              _buildAccountSection(),
              SizedBox(height: context.rSpacing(24)),
              // Logout Section
              _buildLogoutSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 2,
        onTap: _onNavTap,
      ),
    );
  }

  Widget _buildCompanyCard(authState) {
    return Container(
      padding: EdgeInsets.all(context.rSpacing(16)),
      decoration: BoxDecoration(
        color: ColorConsts.lightGreyBackground,
        borderRadius: BorderRadius.circular(context.rSpacing(25)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: authState.companyName ?? 'Company Name',
                  fontSize: context.rFontSize(15),
                  fontWeight: FontWeight.w600,
                  color: ColorConsts.black,
                ),
                SizedBox(height: context.rSpacing(4)),
                CustomText(
                  text: authState.email ?? 'email@example.com',
                  fontSize: context.rFontSize(12),
                  color: ColorConsts.textColor,
                ),
              ],
            ),
          ),
          Container(
            width: context.rSpacing(48),
            height: context.rSpacing(48),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: ColorConsts.textColorRed.withOpacity(0.3),
                width: 2,
              ),
              color: ColorConsts.lightGrey,
            ),
            child: Center(
              child: CustomText(
                text: (authState.companyName ?? 'C')[0].toUpperCase(),
                fontSize: context.rFontSize(18),
                fontWeight: FontWeight.bold,
                color: ColorConsts.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection() {
    return Container(
      decoration: BoxDecoration(
        color: ColorConsts.lightGreyBackground,
        borderRadius: BorderRadius.circular(context.rSpacing(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              context.rSpacing(16),
              context.rSpacing(16),
              context.rSpacing(16),
              context.rSpacing(8),
            ),
            child: CustomText(
              text: 'Account',
              fontSize: context.rFontSize(13),
              color: ColorConsts.textColor,
            ),
          ),
          _buildMenuItem(
            title: 'Company Settings',
            onTap: () => context.pushNamed('companySettings'),
          ),
          _buildDivider(),
          _buildMenuItem(
            title: 'Notifications',
            onTap: () => context.pushNamed('notifications'),
          ),
          _buildDivider(),
          _buildMenuItem(
            title: 'Security',
            onTap: () => context.pushNamed('changePassword'),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.rSpacing(16),
          vertical: context.rSpacing(14),
        ),
        child: Row(
          children: [
            Expanded(
              child: CustomText(
                text: title,
                fontSize: context.rFontSize(14),
                fontWeight: FontWeight.w500,
                color: ColorConsts.black,
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: context.rIconSize(20),
              color: ColorConsts.iconGrey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 0.5,
      indent: context.rSpacing(16),
      endIndent: context.rSpacing(16),
      color: ColorConsts.lightGrey,
    );
  }

  Widget _buildLogoutSection() {
    final authState = ref.watch(authControllerProvider);

    return Container(
      decoration: BoxDecoration(
        color: ColorConsts.lightGreyBackground,
        borderRadius: BorderRadius.circular(context.rSpacing(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              context.rSpacing(16),
              context.rSpacing(16),
              context.rSpacing(16),
              context.rSpacing(8),
            ),
            child: CustomText(
              text: 'Account Logout',
              fontSize: context.rFontSize(13),
              color: ColorConsts.textColor,
            ),
          ),
          InkWell(
            onTap: authState.isLoading ? null : _handleLogout,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.rSpacing(16),
                vertical: context.rSpacing(14),
              ),
              child: Row(
                children: [
                  authState.isLoading
                      ? SizedBox(
                          width: context.rIconSize(18),
                          height: context.rIconSize(18),
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: ColorConsts.textColorRed,
                          ),
                        )
                      : Icon(
                          Icons.logout,
                          size: context.rIconSize(18),
                          color: ColorConsts.textColorRed,
                        ),
                  SizedBox(width: context.rSpacing(8)),
                  CustomText(
                    text: authState.isLoading ? 'Logging out...' : 'Logout',
                    fontSize: context.rFontSize(14),
                    fontWeight: FontWeight.w500,
                    color: ColorConsts.textColorRed,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
