import 'package:empire_job/routes/router_consts.dart';
import 'package:empire_job/shared/consts/images.dart';
import 'package:flutter/material.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:empire_job/features/presentation/widgets/common_textfield_widget.dart';
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/features/presentation/widgets/primary_button_widget.dart';
import 'package:go_router/go_router.dart';

class SignupPageWeb extends StatefulWidget {
  const SignupPageWeb({super.key});

  @override
  State<SignupPageWeb> createState() => _SignupPageWebState();
}

class _SignupPageWebState extends State<SignupPageWeb> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _companyController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _companyController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState?.validate() ?? false) {}
  }

  void _handleLogin() {
    context.go(RouterConsts.loginPath);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width > 1100;

    return Scaffold(
      backgroundColor: context.themeScaffold,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: size.height,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 112,
                vertical: 16,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    constraints: const BoxConstraints(maxWidth: 450),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomText(
                            text: 'Create Your Account',
                            fontSize: 40,
                            fontWeight: FontWeight.w600,
                          ),
                          const SizedBox(height: 12),
                          CustomText(
                            text:
                                'Build your company profile and start posting jobs and managing applicants instantly.',
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 56),
                          CustomText(
                            text: 'Company Name',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          const SizedBox(height: 8),
                          CommonTextfieldWidget(
                            height: 48,
                            controller: _companyController,
                            hintText: 'Enter your companys official name.',
                            requiredField: true,
                            hintSize: 14,
                            keyboardType: TextInputType.text,
                            useFloatingLabel: true,
                            borderColor: context.themeIconGrey,
                            onChanged: (value) {},
                          ),
                          const SizedBox(height: 40),
                          CustomText(
                            text: 'Email Address',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          const SizedBox(height: 8),
                          CommonTextfieldWidget(
                            height: 48,
                            controller: _emailController,
                            hintText:
                                'Enter the email associated with your account.',
                            requiredField: true,
                            hintSize: 14,
                            keyboardType: TextInputType.emailAddress,
                            useFloatingLabel: true,
                            borderColor: context.themeIconGrey,
                            onChanged: (value) {},
                          ),
                          const SizedBox(height: 40),
                          CustomText(
                            text: 'Password',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          const SizedBox(height: 8),
                          CommonTextfieldWidget(
                            controller: _passwordController,
                            hintText: 'Enter your secure password.',
                            hintSize: 14,
                            obscureText: _obscurePassword,
                            requiredField: true,
                            useFloatingLabel: true,
                            borderRadius: 12,
                            height: 50,
                            borderColor: context.themeIconGrey,
                          ),
                          const SizedBox(height: 40),
                          CustomText(
                            text: 'Confirm Password',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          const SizedBox(height: 8),
                          CommonTextfieldWidget(
                            height: 50,
                            controller: _confirmPasswordController,
                            hintText: 'Re-enter the password for verification.',
                            requiredField: true,
                            hintSize: 14,
                            obscureText: _obscureConfirmPassword,
                            useFloatingLabel: true,
                            borderRadius: 12,
                            borderColor: context.themeIconGrey,
                            onChanged: (value) {},
                          ),
                          const SizedBox(height: 36),
                          PrimaryButtonWidget(
                            text: 'Create Account',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            showShadow: true,
                            showBorder: false,
                            offset: 4,
                            onPressed: _handleRegister,
                          ),
                          const SizedBox(height: 48),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: "Already have an account? ",
                                fontSize: 12,
                              ),
                              GestureDetector(
                                onTap: _handleLogin,
                                child: CustomText(
                                  text: 'Login',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: ColorConsts.textColorRed,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isLargeScreen) ...[
                    const SizedBox(width: 90),
                    Flexible(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: _buildImage(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Image.asset(ImageConsts.imgSignup, fit: BoxFit.contain);
  }
}