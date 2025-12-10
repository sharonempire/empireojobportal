import 'package:empire_job/features/application/settings/controllers/settings_controller.dart';
import 'package:empire_job/features/application/settings/models/settings_state.dart';
import 'package:empire_job/features/presentation/web/settings/widgets/settings_item_card_widget.dart';
import 'package:empire_job/shared/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompanySectionWidget extends ConsumerStatefulWidget {
  const CompanySectionWidget({super.key});

  @override
  ConsumerState<CompanySectionWidget> createState() =>
      _CompanySectionWidgetState();
}

class _CompanySectionWidgetState extends ConsumerState<CompanySectionWidget> {
  final _companyNameController = TextEditingController();
  final _companyWebsiteController = TextEditingController();
  final _companyEmailController = TextEditingController();
  final _companyAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(settingsProvider.notifier).loadCompanyData();
    });
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _companyWebsiteController.dispose();
    _companyEmailController.dispose();
    _companyAddressController.dispose();
    super.dispose();
  }

  void _updateControllersFromState(SettingsState settingsState) {
    if (settingsState.companyName != null &&
        _companyNameController.text != settingsState.companyName) {
      _companyNameController.text = settingsState.companyName!;
    }
    if (settingsState.companyEmail != null &&
        _companyEmailController.text != settingsState.companyEmail) {
      _companyEmailController.text = settingsState.companyEmail!;
    }
    final websiteValue = settingsState.companyWebsite ?? '';
    if (_companyWebsiteController.text != websiteValue) {
      _companyWebsiteController.text = websiteValue;
    }
    final addressValue = settingsState.companyAddress ?? '';
    if (_companyAddressController.text != addressValue) {
      _companyAddressController.text = addressValue;
    }
  }

  Future<void> _handleSaveBasicInfo() async {
    try {
      await ref
          .read(settingsProvider.notifier)
          .saveCompanyInfo(
            website: _companyWebsiteController.text,
            address: _companyAddressController.text,
          );

      if (mounted) {
        context.showSuccessSnackbar('Company information saved successfully');
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackbar('Error saving information: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsState = ref.watch(settingsProvider);
    if (settingsState.companyName != null || settingsState.companyEmail != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _updateControllersFromState(settingsState);
        }
      });
    }

    return Column(
      children: [
        SettingsItemCardWidget(
          title: 'Basic Information',
          subtitle: 'Build Your Company Profile with Confidence',
          sectionHead: 'Basic Info',
          description:
              'Provide essential company details to create a trustworthy presence on the platform. Complete your profile to make your job postings more credible and help candidates understand your organization better.',
          fields: [
            SettingsField(
              label: 'Company Name',
              hintText: 'Enter your company name',
              controller: _companyNameController,
              readOnly: true,
            ),
            SettingsField(
              label: 'Company Website',
              hintText: 'Enter your company website',
              controller: _companyWebsiteController,
              keyboardType: TextInputType.url,
            ),
            SettingsField(
              label: 'Company Email',
              hintText: 'Enter your email',
              controller: _companyEmailController,
              keyboardType: TextInputType.emailAddress,
              readOnly: true,
            ),
            SettingsField(
              label: 'Company Address',
              hintText: 'Enter your company address',
              controller: _companyAddressController,
            ),
          ],
          buttonText: 'Save Changes',
          onButtonPressed: _handleSaveBasicInfo,
          isLoading: settingsState.isLoading,
        ),
      ],
    );
  }}