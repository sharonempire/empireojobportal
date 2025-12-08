import 'package:empire_job/features/presentation/web/settings/widgets/settings_item_card_widget.dart';
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

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCompanyData();
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _companyWebsiteController.dispose();
    _companyEmailController.dispose();
    _companyAddressController.dispose();
    super.dispose();
  }

  Future<void> _loadCompanyData() async {}

  Future<void> _handleSaveBasicInfo() async {
    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Company information saved successfully'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving information: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            ),
            SettingsField(
              label: 'Company Website',
              hintText: 'Enter your company name',
              controller: _companyWebsiteController,
              keyboardType: TextInputType.url,
            ),
            SettingsField(
              label: 'Company Email',
              hintText: 'Enter your email',
              controller: _companyEmailController,
              keyboardType: TextInputType.emailAddress,
            ),
            SettingsField(
              label: 'Company Address',
              hintText: 'Enter your company address',
              controller: _companyAddressController,
            ),
          ],
          buttonText: 'Save Changes',
          onButtonPressed: _handleSaveBasicInfo,
          isLoading: _isLoading,
        ),
      ],
    );
  }
}
