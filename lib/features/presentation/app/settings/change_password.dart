import 'package:empire_job/features/application/settings/controllers/settings_controller.dart';
import 'package:empire_job/features/presentation/widgets/common_textfield_widget.dart';
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/features/presentation/widgets/primary_button_widget.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:empire_job/shared/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ChangePassword extends ConsumerStatefulWidget {
  const ChangePassword({super.key});

  @override
  ConsumerState<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends ConsumerState<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _toggleOldPasswordVisibility() {
    setState(() {
      _obscureOldPassword = !_obscureOldPassword;
    });
  }

  void _toggleNewPasswordVisibility() {
    setState(() {
      _obscureNewPassword = !_obscureNewPassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  Future<void> _updatePassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_newPasswordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords do not match'),
            backgroundColor: ColorConsts.textColorRed,
          ),
        );
        return;
      }

      try {
        await ref
            .read(settingsProvider.notifier)
            .changePassword(
              oldPassword: _oldPasswordController.text,
              newPassword: _newPasswordController.text,
            );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password updated successfully!')),
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
  }

  @override
  Widget build(BuildContext context) {
    final settingsState = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: ColorConsts.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(context.rSpacing(16)),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      CustomText(
                        text: 'Change Password',
                        fontSize: context.rFontSize(16),
                        fontWeight: FontWeight.bold,
                        color: ColorConsts.black,
                      ),
                      SizedBox(height: context.rSpacing(8)),
                      CustomText(
                        text:
                            'Protect your account by setting a new, secure password.',
                        fontSize: context.rFontSize(12),
                        color: ColorConsts.textColor,
                      ),
                      SizedBox(height: context.rSpacing(32)),
                      // Password Section
                      _buildPasswordSection(),
                    ],
                  ),
                ),
              ),
            ),
            // Update Button
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
                          text: 'Update Password',
                          onPressed: _updatePassword,
                          backgroundColor: ColorConsts.black,
                          textColor: ColorConsts.white,
                          showBorder: false,
                          showShadow: false,
                          height: context.rHeight(35),
                          borderRadius: 24,
                          width: context.rSpacing(155),
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

  Widget _buildPasswordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Password',
          fontSize: context.rFontSize(14),
          fontWeight: FontWeight.bold,
          color: ColorConsts.black,
        ),
        SizedBox(height: context.rSpacing(16)),
        // Old Password
        _buildFieldLabel('Old Password'),
        SizedBox(height: context.rSpacing(8)),
        CommonTextfieldWidget(
          controller: _oldPasswordController,
          obscureText: _obscureOldPassword,
          useBorderOnly: true,
          height: context.rHeight(48),
          borderRadius: 20,
          requiredField: true,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureOldPassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: ColorConsts.iconGrey,
              size: context.rIconSize(18),
            ),
            onPressed: _toggleOldPasswordVisibility,
          ),
        ),
        SizedBox(height: context.rSpacing(16)),
        // New Password
        _buildFieldLabel('New Password'),
        SizedBox(height: context.rSpacing(8)),
        CommonTextfieldWidget(
          controller: _newPasswordController,
          obscureText: _obscureNewPassword,
          useBorderOnly: true,
          height: context.rHeight(48),
          borderRadius: 20,
          requiredField: true,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureNewPassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: ColorConsts.iconGrey,
              size: context.rIconSize(18),
            ),
            onPressed: _toggleNewPasswordVisibility,
          ),
        ),
        SizedBox(height: context.rSpacing(16)),
        // Confirm Password
        _buildFieldLabel('Confirm Password'),
        SizedBox(height: context.rSpacing(8)),
        CommonTextfieldWidget(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          useBorderOnly: true,
          height: context.rHeight(48),
          borderRadius: 20,
          requiredField: true,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmPassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: ColorConsts.iconGrey,
              size: context.rIconSize(18),
            ),
            onPressed: _toggleConfirmPasswordVisibility,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Required';
            }
            if (value != _newPasswordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
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
