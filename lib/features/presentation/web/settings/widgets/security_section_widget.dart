import 'package:empire_job/features/application/settings/controllers/settings_controller.dart';
import 'package:empire_job/features/presentation/web/settings/widgets/settings_item_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class SecuritySectionWidget extends ConsumerStatefulWidget {
  const SecuritySectionWidget({super.key});

  @override
  ConsumerState<SecuritySectionWidget> createState() => _SecuritySectionWidgetState();
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
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    if (_newPasswordController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 8 characters')),
      );
      return;
    }

    final notifier = ref.read(settingsProvider.notifier);
    
    try {
      await notifier.changePassword();

      if (mounted) {
        _oldPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating password: $e')),
        );
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