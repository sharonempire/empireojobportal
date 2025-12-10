import 'package:empire_job/features/presentation/widgets/common_textfield_widget.dart';
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/features/presentation/widgets/primary_button_widget.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignupPageApp extends StatefulWidget {
  const SignupPageApp({super.key});

  @override
  State<SignupPageApp> createState() => _SignupPageAppState();
}

class _SignupPageAppState extends State<SignupPageApp> {
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

  void _onCreateAccount() {
    if (_formKey.currentState?.validate() ?? false) {
      // Handle account creation
    }
  }

  void _navigateToLogin() {
    context.goNamed('login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConsts.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title
                  const CustomText(
                    text: 'Create Your Account',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: ColorConsts.black,
                  ),
                  const SizedBox(height: 12),

                  // Subtitle
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: CustomText(
                      text:
                          'Build your company profile and start posting jobs and managing applicants instantly.',
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: ColorConsts.textColor,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Company Name Field
                  _buildFieldLabel('Company Name'),
                  const SizedBox(height: 8),
                  CommonTextfieldWidget(
                    controller: _companyNameController,
                    hintText: "Enter your company's official name.",
                    useFloatingLabel: true,
                    requiredField: true,
                    height: 56,
                  ),
                  const SizedBox(height: 24),

                  // Email Field
                  _buildFieldLabel('Email Address'),
                  const SizedBox(height: 8),
                  CommonTextfieldWidget(
                    controller: _emailController,
                    hintText: "Enter your company's official email address.",
                    keyboardType: TextInputType.emailAddress,
                    useFloatingLabel: true,
                    requiredField: true,
                    height: 56,
                  ),
                  const SizedBox(height: 24),

                  // Password Field
                  _buildFieldLabel('Password'),
                  const SizedBox(height: 8),
                  CommonTextfieldWidget(
                    controller: _passwordController,
                    hintText:
                        'Create a strong password to secure your HR portal.',
                    obscureText: _obscurePassword,
                    useFloatingLabel: true,
                    requiredField: true,
                    height: 56,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: ColorConsts.iconGrey,
                        size: 20,
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Confirm Password Field
                  _buildFieldLabel('Confirm Password'),
                  const SizedBox(height: 8),
                  CommonTextfieldWidget(
                    controller: _confirmPasswordController,
                    hintText: 'Re-enter the password for verification.',
                    obscureText: _obscureConfirmPassword,
                    useFloatingLabel: true,
                    requiredField: true,
                    height: 56,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: ColorConsts.iconGrey,
                        size: 20,
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
                  const SizedBox(height: 40),

                  // Create Account Button
                  PrimaryButtonWidget(
                    text: 'Create Account',
                    onPressed: _onCreateAccount,
                    backgroundColor: ColorConsts.black,
                    textColor: ColorConsts.white,
                    showBorder: false,
                    showShadow: false,
                    height: 52,
                    borderRadius: 26,
                  ),
                  const SizedBox(height: 32),

                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CustomText(
                        text: 'Already have an account ? ',
                        fontSize: 14,
                        color: ColorConsts.textColor,
                      ),
                      GestureDetector(
                        onTap: _navigateToLogin,
                        child: const CustomText(
                          text: 'Login',
                          fontSize: 14,
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
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: ColorConsts.black,
      ),
    );
  }
}
