import 'package:empire_job/features/application/settings/controllers/settings_controller.dart';
import 'package:empire_job/features/presentation/web/settings/widgets/settings_item_card_widget.dart';
import 'package:empire_job/shared/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SecuritySectionWidget extends ConsumerStatefulWidget {
  const SecuritySectionWidget({super.key});

  @override
  ConsumerState<SecuritySectionWidget> createState() =>
      _SecuritySectionWidgetState();
}

class _SecuritySectionWidgetState extends ConsumerState<SecuritySectionWidget> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdatePassword() async {
    if (_oldPasswordController.text.isEmpty) {
      context.showErrorSnackbar('Please enter your current password');
      return;
    }

    if (_newPasswordController.text.isEmpty) {
      context.showErrorSnackbar('Please enter a new password');
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      context.showErrorSnackbar('Passwords do not match');
      return;
    }

    if (_newPasswordController.text.length < 6) {
      context.showErrorSnackbar('Password must be at least 6 characters');
      return;
    }

    if (_oldPasswordController.text == _newPasswordController.text) {
      context.showErrorSnackbar(
        'New password must be different from current password',
      );
      return;
    }

    final notifier = ref.read(settingsProvider.notifier);

    try {
      await notifier.changePassword(
        oldPassword: _oldPasswordController.text,
        newPassword: _newPasswordController.text,
      );

      if (mounted) {
        _oldPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();

        context.showSuccessSnackbar('Password updated successfully');
      }
    } catch (e) {
      if (mounted) {
        String errorMessage;
        if (e is String) {
          errorMessage = e;
        } else {
          final errorStr = e.toString();
          if (errorStr.contains('Current password is incorrect')) {
            errorMessage = 'Current password is incorrect. Please check your password and try again.';
          } else if (errorStr.contains('User not authenticated')) {
            errorMessage = 'You are not authenticated. Please log in again.';
          } else if (errorStr.contains('invalid') || errorStr.contains('credentials')) {
            errorMessage = 'Current password is incorrect. Please check your password and try again.';
          } else {
            errorMessage = 'Failed to update password. Please try again.';
          }
        }
        context.showErrorSnackbar(errorMessage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsState = ref.watch(settingsProvider);

    return Column(
      children: [
        SettingsItemCardWidget(
          title: 'Change Password',
          subtitle: 'Strengthen your account security with a quick password update.',
          sectionHead: 'Password',
          description:
              'Update your password regularly to protect your account from unauthorized access. Choose a strong, unique password and avoid reusing old ones to ensure maximum security.',
          fields: [
            SettingsField(
              label: 'Old Password',
              hintText: 'Enter your old password',
              controller: _oldPasswordController,
              obscureText: true, 
            ),
            SettingsField(
              label: 'New Password',
              hintText: 'Enter your new password',
              controller: _newPasswordController,
              obscureText: true, 
            ),
            SettingsField(
              label: 'Confirm Password',
              hintText: 'Confirm your password',
              controller: _confirmPasswordController,
              obscureText: true, 
            ),
          ],
          buttonText: 'Update Password',
          onButtonPressed: _handleUpdatePassword,
          isLoading: settingsState.isLoading,
        ),
      ],
    );
  }
}