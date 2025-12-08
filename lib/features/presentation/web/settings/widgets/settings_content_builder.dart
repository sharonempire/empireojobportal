
import 'package:empire_job/features/application/settings/controllers/settings_controller.dart';
import 'package:empire_job/features/presentation/web/settings/widgets/company_section_widget.dart';
import 'package:empire_job/features/presentation/web/settings/widgets/security_section_widget.dart';
import 'package:flutter/material.dart';

class SettingsContentBuilder extends StatelessWidget {
  final int selectedIndex;
  final SettingsNotifier notifier;
  final bool isLoading;

  const SettingsContentBuilder({
    super.key,
    required this.selectedIndex,
    required this.notifier,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    switch (selectedIndex) {
      case 0:
        return CompanySectionWidget();
      case 1:
        return  SecuritySectionWidget();
      case 2:
        return SecuritySectionWidget(

        );
 
      default:
        return const SizedBox();
    }
  }
}
