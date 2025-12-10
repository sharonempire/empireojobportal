import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:empire_job/shared/utils/bottonavigationbar.dart';
import 'package:empire_job/shared/utils/responsive.dart';
import 'package:empire_job/shared/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsPageApp extends StatefulWidget {
  const SettingsPageApp({super.key});

  @override
  State<SettingsPageApp> createState() => _SettingsPageAppState();
}

class _SettingsPageAppState extends State<SettingsPageApp> {
  void _onNavTap(int index) {
    switch (index) {
      case 0:
        context.goNamed('dashboard');
        break;
      case 1:
        context.goNamed('addJob');
        break;
      case 2:
        // Already on settings
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConsts.white,
      appBar: CommonAppBar(
        title: 'Settings',
        showBackButton: true,
        onBackPressed: () => context.goNamed('dashboard'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(context.rSpacing(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company Name Card
              _buildCompanyCard(),
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

  Widget _buildCompanyCard() {
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
                  text: 'Company Name',
                  fontSize: context.rFontSize(15),
                  fontWeight: FontWeight.w600,
                  color: ColorConsts.black,
                ),
                SizedBox(height: context.rSpacing(4)),
                CustomText(
                  text: 'annaben123@gmail.com',
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
              image: const DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&h=100&fit=crop',
                ),
                fit: BoxFit.cover,
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
            onTap: () {
              // Handle notifications
            },
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
            onTap: () {
              // Handle logout
              context.goNamed('login');
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.rSpacing(16),
                vertical: context.rSpacing(14),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.logout,
                    size: context.rIconSize(18),
                    color: ColorConsts.textColorRed,
                  ),
                  SizedBox(width: context.rSpacing(8)),
                  CustomText(
                    text: 'Logout',
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
