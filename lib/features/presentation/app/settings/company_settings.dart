import 'package:empire_job/features/application/authentication/controller/auth_controller.dart';
import 'package:empire_job/features/application/settings/controllers/settings_controller.dart';
import 'package:empire_job/features/presentation/widgets/common_textfield_widget.dart';
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/features/presentation/widgets/primary_button_widget.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:empire_job/shared/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CompanySettings extends ConsumerStatefulWidget {
  const CompanySettings({super.key});

  @override
  ConsumerState<CompanySettings> createState() => _CompanySettingsState();
}

class _CompanySettingsState extends ConsumerState<CompanySettings> {
  final _companyNameController = TextEditingController();
  final _companyWebsiteController = TextEditingController();
  final _companyEmailController = TextEditingController();
  final _companyAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load company data when page opens
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

  void _updateControllersFromState() {
    final settingsState = ref.read(settingsProvider);
    final authState = ref.read(authControllerProvider);

    if (_companyNameController.text.isEmpty &&
        (settingsState.companyName ?? authState.companyName) != null) {
      _companyNameController.text =
          settingsState.companyName ?? authState.companyName ?? '';
    }
    if (_companyEmailController.text.isEmpty &&
        (settingsState.companyEmail ?? authState.email) != null) {
      _companyEmailController.text =
          settingsState.companyEmail ?? authState.email ?? '';
    }
    if (_companyWebsiteController.text.isEmpty &&
        settingsState.companyWebsite != null) {
      _companyWebsiteController.text = settingsState.companyWebsite ?? '';
    }
    if (_companyAddressController.text.isEmpty &&
        settingsState.companyAddress != null) {
      _companyAddressController.text = settingsState.companyAddress ?? '';
    }
  }

  Future<void> _saveChanges() async {
    try {
      await ref
          .read(settingsProvider.notifier)
          .saveCompanyInfo(
            website: _companyWebsiteController.text,
            address: _companyAddressController.text,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Changes saved successfully!')),
        );
        context.pop();
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

  @override
  Widget build(BuildContext context) {
    final settingsState = ref.watch(settingsProvider);
    final authState = ref.watch(authControllerProvider);

    // Update controllers when data loads
    _updateControllersFromState();

    return Scaffold(
      backgroundColor: ColorConsts.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            // Content
            Expanded(
              child: settingsState.isLoadingCompanyData
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: ColorConsts.black,
                      ),
                    )
                  : SingleChildScrollView(
                      padding: EdgeInsets.all(context.rSpacing(16)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          CustomText(
                            text: 'Company Settings',
                            fontSize: context.rFontSize(16),
                            fontWeight: FontWeight.bold,
                            color: ColorConsts.black,
                          ),
                          SizedBox(height: context.rSpacing(8)),
                          CustomText(
                            text: 'For managing HR or company account details.',
                            fontSize: context.rFontSize(12),
                            color: ColorConsts.textColor,
                          ),
                          SizedBox(height: context.rSpacing(8)),
                          const Divider(
                            color: ColorConsts.lightGrey,
                            thickness: 1,
                          ),
                          SizedBox(height: context.rSpacing(24)),
                          // Company Logo Section
                          _buildCompanyLogoSection(authState),
                          SizedBox(height: context.rSpacing(32)),
                          // Basic Info Section
                          _buildBasicInfoSection(),
                          SizedBox(height: context.rSpacing(32)),
                          // Contact Info Section
                          _buildContactInfoSection(),
                        ],
                      ),
                    ),
            ),
            // Save Button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.all(context.rSpacing(16)),
                  child: settingsState.isLoading
                      ? const CircularProgressIndicator(
                          color: ColorConsts.black,
                        )
                      : PrimaryButtonWidget(
                          text: 'Save Changes',
                          onPressed: _saveChanges,
                          backgroundColor: ColorConsts.black,
                          textColor: ColorConsts.white,
                          showBorder: false,
                          showShadow: false,
                          height: context.rHeight(35),
                          borderRadius: 24,
                          width: context.rSpacing(135),
                          fontSize: context.rFontSize(12),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.rSpacing(16),
        vertical: context.rSpacing(12),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: context.rSpacing(40),
              height: context.rSpacing(40),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: ColorConsts.lightGreyBackground,
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.chevron_left,
                size: context.rIconSize(24),
                color: ColorConsts.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyLogoSection(authState) {
    final companyName = authState.companyName ?? 'Company';
    final initial = companyName.isNotEmpty ? companyName[0].toUpperCase() : 'C';

    return Row(
      children: [
        // Logo Preview
        Container(
          width: context.rSpacing(56),
          height: context.rSpacing(56),
          decoration: BoxDecoration(
            color: ColorConsts.black,
            borderRadius: BorderRadius.circular(90),
          ),
          child: Center(
            child: CustomText(
              text: initial,
              fontSize: context.rFontSize(20),
              fontWeight: FontWeight.bold,
              color: ColorConsts.white,
            ),
          ),
        ),
        SizedBox(width: context.rSpacing(16)),
        // Logo Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Company Logo',
                fontSize: context.rFontSize(12),
                fontWeight: FontWeight.w600,
                color: ColorConsts.black,
              ),
              SizedBox(height: context.rSpacing(2)),
              CustomText(
                text: 'PNG , JPEG under 15MB',
                fontSize: context.rFontSize(8),
                color: ColorConsts.textColor,
              ),
            ],
          ),
        ),
        PrimaryButtonWidget(
          text: 'Upload New Picture',
          onPressed: () {
            // TODO: Implement image picker
          },
          backgroundColor: ColorConsts.white,
          textColor: ColorConsts.black,
          showBorder: true,
          showShadow: true,
          height: context.rHeight(32),
          width: context.rSpacing(130),
          borderRadius: 26,
          fontSize: context.rFontSize(8),
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Basic Info',
          fontSize: context.rFontSize(14),
          fontWeight: FontWeight.bold,
          color: ColorConsts.black,
        ),
        SizedBox(height: context.rSpacing(16)),
        _buildFieldLabel('Company Name'),
        SizedBox(height: context.rSpacing(8)),
        CommonTextfieldWidget(
          controller: _companyNameController,
          useBorderOnly: true,
          height: context.rHeight(48),
          borderRadius: 8,
          readOnly: true, // Company name is read-only
        ),
        SizedBox(height: context.rSpacing(16)),
        _buildFieldLabel('Company Website'),
        SizedBox(height: context.rSpacing(8)),
        CommonTextfieldWidget(
          controller: _companyWebsiteController,
          useBorderOnly: true,
          height: context.rHeight(48),
          borderRadius: 8,
          hintText: 'https://www.example.com',
        ),
      ],
    );
  }

  Widget _buildContactInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Contact Info',
          fontSize: context.rFontSize(13),
          fontWeight: FontWeight.bold,
          color: ColorConsts.black,
        ),
        SizedBox(height: context.rSpacing(16)),
        _buildFieldLabel('Company Email'),
        SizedBox(height: context.rSpacing(8)),
        CommonTextfieldWidget(
          controller: _companyEmailController,
          useBorderOnly: true,
          height: context.rHeight(48),
          borderRadius: 20,
          hintFontSize: context.rFontSize(10),
          readOnly: true, // Email is read-only
        ),
        SizedBox(height: context.rSpacing(16)),
        _buildFieldLabel('Company Address'),
        SizedBox(height: context.rSpacing(8)),
        CommonTextfieldWidget(
          controller: _companyAddressController,
          useBorderOnly: true,
          height: context.rHeight(80),
          borderRadius: 8,
          maxLines: 3,
          hintFontSize: context.rFontSize(10),
          hintText: 'Enter your company address',
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label) {
    return CustomText(
      text: label,
      fontSize: context.rFontSize(12),
      color: ColorConsts.textColor,
    );
  }
}
