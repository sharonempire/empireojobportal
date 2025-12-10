import 'package:empire_job/features/application/authentication/controller/auth_controller.dart';
import 'package:empire_job/features/presentation/widgets/common_textfield_widget.dart';
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/features/presentation/widgets/primary_button_widget.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:empire_job/shared/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignupPageApp extends ConsumerStatefulWidget {
  const SignupPageApp({super.key});

  @override
  ConsumerState<SignupPageApp> createState() => _SignupPageAppState();
}

class _SignupPageAppState extends ConsumerState<SignupPageApp> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _companyNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  Future<void> _onCreateAccount() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_passwordController.text != _confirmPasswordController.text) {
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
            .read(authControllerProvider.notifier)
            .signup(
              email: _emailController.text.trim(),
              password: _passwordController.text,
              companyName: _companyNameController.text.trim(),
            );
        if (mounted) {
          context.goNamed('dashboard');
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

  void _navigateToLogin() {
    context.goNamed('login');
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: ColorConsts.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: context.rSpacing(24),
              vertical: context.rSpacing(32),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title
                  CustomText(
                    text: 'Create Your Account',
                    fontSize: context.rFontSize(20),
                    fontWeight: FontWeight.bold,
                    color: ColorConsts.black,
                  ),
                  SizedBox(height: context.rSpacing(12)),

                  // Subtitle
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.rSpacing(14),
                    ),
                    child: CustomText(
                      text:
                          'Build your company profile and start posting jobs and managing applicants instantly.',
                      fontSize: context.rFontSize(12),
                      fontWeight: FontWeight.normal,
                      color: ColorConsts.black,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(height: context.rSpacing(40)),

                  // Company Name Field
                  _buildFieldLabel('Company Name'),
                  CommonTextfieldWidget(
                    controller: _companyNameController,
                    hintText: "Enter your name",
                    hintColor: ColorConsts.textColorBlack,
                    useFloatingLabel: true,
                    requiredField: true,
                    height: context.rHeight(46),
                  ),
                  SizedBox(height: context.rSpacing(24)),

                  // Email Field
                  _buildFieldLabel('Email Address'),
                  CommonTextfieldWidget(
                    controller: _emailController,
                    hintText: "Enter your company's official email address",
                    keyboardType: TextInputType.emailAddress,
                    useFloatingLabel: true,
                    requiredField: true,
                    height: context.rHeight(46),
                    hintColor: ColorConsts.textColorBlack,
                  ),
                  SizedBox(height: context.rSpacing(24)),

                  // Password Field
                  _buildFieldLabel('Password'),
                  CommonTextfieldWidget(
                    controller: _passwordController,
                    hintText: 'Create a strong password',
                    obscureText: _obscurePassword,
                    useFloatingLabel: true,
                    requiredField: true,
                    hintColor: ColorConsts.textColorBlack,
                    height: context.rHeight(46),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: ColorConsts.iconGrey,
                        size: context.rIconSize(16),
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                  ),
                  SizedBox(height: context.rSpacing(24)),

                  // Confirm Password Field
                  _buildFieldLabel('Confirm Password'),
                  CommonTextfieldWidget(
                    controller: _confirmPasswordController,
                    hintText: 'Re-enter the password',
                    obscureText: _obscureConfirmPassword,
                    useFloatingLabel: true,
                    requiredField: true,
                    hintColor: ColorConsts.textColorBlack,
                    height: context.rHeight(46),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: ColorConsts.iconGrey,
                        size: context.rIconSize(16),
                      ),
                      onPressed: _toggleConfirmPasswordVisibility,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: context.rSpacing(40)),

                  // Create Account Button
                  authState.isLoading
                      ? const CircularProgressIndicator(
                          color: ColorConsts.black,
                        )
                      : PrimaryButtonWidget(
                          text: 'Create Account',
                          onPressed: _onCreateAccount,
                          backgroundColor: ColorConsts.white,
                          textColor: ColorConsts.black,
                          showBorder: false,
                          showShadow: true,
                          fontSize: context.rFontSize(14),
                          height: context.rHeight(52),
                          borderRadius: 26,
                        ),
                  SizedBox(height: context.rSpacing(32)),
                  SizedBox(height: context.rSpacing(32)),

                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: 'Already have an account ? ',
                        fontSize: context.rFontSize(12),
                        color: ColorConsts.textColorBlack,
                      ),
                      GestureDetector(
                        onTap: _navigateToLogin,
                        child: CustomText(
                          text: 'Login',
                          fontSize: context.rFontSize(12),
                          fontWeight: FontWeight.w600,
                          color: ColorConsts.textColorRed,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: CustomText(
        text: label,
        fontSize: context.rFontSize(14),
        fontWeight: FontWeight.w500,
        color: ColorConsts.black,
      ),
    );
  }
}
