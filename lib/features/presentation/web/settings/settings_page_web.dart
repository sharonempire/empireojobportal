import 'package:empire_job/features/application/authentication/controller/auth_controller.dart';
import 'package:empire_job/features/application/settings/controllers/settings_controller.dart';
import 'package:empire_job/features/presentation/web/settings/widgets/settings_content_builder.dart';
import 'package:empire_job/features/presentation/web/settings/widgets/settings_tab_widget.dart';
import 'package:empire_job/features/presentation/widgets/common_navbar.dart';
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/features/presentation/widgets/responsive_horizontal_scroll.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPageWeb extends ConsumerStatefulWidget {
  const SettingsPageWeb({super.key});

  @override
  ConsumerState<SettingsPageWeb> createState() => _SettingsPageWebState();
}

class _SettingsPageWebState extends ConsumerState<SettingsPageWeb> {
  bool _hasLoadedData = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDataIfNeeded();
    });
  }

  Future<void> _loadDataIfNeeded() async {
    if (_hasLoadedData) return;

    final authState = ref.read(authControllerProvider);
    if (authState.isCheckingAuth || !authState.isAuthenticated || authState.userId == null) {
      return;
    }

    final settingsState = ref.read(settingsProvider);
    if (!settingsState.isLoadingCompanyData) {
      _hasLoadedData = true;
      await ref.read(settingsProvider.notifier).loadCompanyData();
    }
  }

  static const List<String> tabs = [
    'Company',
    'Security',
    'Logout',
  ];

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final settingsState = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);

    // Try to load data if auth is ready and we haven't loaded yet
    if (!_hasLoadedData &&
        !authState.isCheckingAuth &&
        authState.isAuthenticated &&
        authState.userId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _loadDataIfNeeded();
      });
    }

    return Scaffold(
      backgroundColor: context.themeScaffoldCourse,
      body: ResponsiveHorizontalScroll(
        child: SafeArea(
          child: Column(
            children: [
              CommonNavbar(),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding:  EdgeInsets.symmetric(
                      horizontal:  100,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          text: 'Settings',
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(height: 4),
                        CustomText(
                          text: 'Manage your account settings and preferences.',
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: context.themeGrey600,
                        ),
                        const SizedBox(height: 32),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: List.generate(tabs.length, (index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: context.themeSelectedMenuProfile
                                    .withOpacity(.6),
                              ),
                              child: SettingsTabButton(
                                label: tabs[index],
                                isSelected:
                                    settingsState.selectedTabIndex == index,
                                onTap: () => settingsNotifier.selectTab(index),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 40),
                        SettingsContentBuilder(
                          selectedIndex: settingsState.selectedTabIndex,
                          notifier: settingsNotifier,
                          isLoading: settingsState.isLoading,
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
