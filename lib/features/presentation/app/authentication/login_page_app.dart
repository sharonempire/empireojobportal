import 'package:empire_job/features/presentation/widgets/common_textfield_widget.dart';
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/features/presentation/widgets/primary_button_widget.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:empire_job/shared/consts/images.dart';
import 'package:empire_job/shared/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPageApp extends StatefulWidget {
  const LoginPageApp({super.key});

  @override
  State<LoginPageApp> createState() => _LoginPageAppState();
}

class _LoginPageAppState extends State<LoginPageApp> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      // Navigate to dashboard after successful login
      context.goNamed('dashboard');
    }
  }

  void _navigateToRegister() {
    context.goNamed('signup');
  }

  void _onForgotPassword() {
    // Handle forgot password
  }

  @override
  Widget build(BuildContext context) {
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
                    text: 'Welcome Back !',
                    fontSize: context.rFontSize(20),
                    fontWeight: FontWeight.bold,
                    color: ColorConsts.black,
                  ),
                  SizedBox(height: context.rSpacing(12)),

                  // Subtitle
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.rSpacing(16),
                    ),
                    child: CustomText(
                      text:
                          'Access your HR dashboard and continue managing jobs and applicants.',
                      fontSize: context.rFontSize(14),
                      fontWeight: FontWeight.w500,
                      color: ColorConsts.textColorBlack,
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // Illustration
                  Container(
                    height: context.rImageSize(258),
                    width: context.rImageSize(220),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Image.asset(
                      ImageConsts.imgSignup,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            color: ColorConsts.lightGrey2,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.person_outline,
                            size: context.rIconSize(80),
                            color: ColorConsts.iconGrey,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: context.rSpacing(22)),

                  // Email Field
                  _buildFieldLabel('Email Address'),
                  SizedBox(height: context.rSpacing(1)),
                  CommonTextfieldWidget(
                    controller: _emailController,
                    hintText: 'Enter the email associated with your account.',
                    keyboardType: TextInputType.emailAddress,
                    hintColor: ColorConsts.textColorBlack,
                    useFloatingLabel: true,
                    requiredField: true,
                    height: context.rHeight(56),
                  ),
                  SizedBox(height: context.rSpacing(24)),

                  // Password Field
                  _buildFieldLabel('Password'),
                  SizedBox(height: context.rSpacing(8)),
                  CommonTextfieldWidget(
                    controller: _passwordController,
                    hintText: 'Enter your secure password.',
                    obscureText: _obscurePassword,
                    useFloatingLabel: true,
                    hintColor: ColorConsts.textColorBlack,
                    requiredField: true,
                    height: context.rHeight(56),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: ColorConsts.iconGrey,
                        size: context.rIconSize(20),
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                  ),
                  SizedBox(height: context.rSpacing(16)),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: context.rSpacing(24),
                            width: context.rSpacing(24),
                            child: Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              side: const BorderSide(
                                color: ColorConsts.iconGrey,
                                width: 1.5,
                              ),
                              activeColor: ColorConsts.black,
                            ),
                          ),
                          SizedBox(width: context.rSpacing(8)),
                          CustomText(
                            text: 'Remember me',
                            fontSize: context.rFontSize(10),
                            color: ColorConsts.textColor,
                          ),
                        ],
                      ),

                      GestureDetector(
                        onTap: _onForgotPassword,
                        child: CustomText(
                          text: 'Forgot Password',
                          fontSize: context.rFontSize(10),
                          color: ColorConsts.textColorRed,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.rSpacing(32)),

                  // Login Button
                  PrimaryButtonWidget(
                    text: 'Login',
                    onPressed: _onLogin,
                    backgroundColor: ColorConsts.white,
                    textColor: ColorConsts.black,
                    showBorder: false,
                    showShadow: true,
                    height: context.rHeight(42),
                    borderRadius: 26,
                    fontSize: context.rFontSize(14),
                  ),
                  SizedBox(height: context.rSpacing(52)),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: "Don't have an account ? ",
                        fontSize: context.rFontSize(12),
                        color: ColorConsts.textColor,
                      ),
                      GestureDetector(
                        onTap: _navigateToRegister,
                        child: CustomText(
                          text: 'Register',
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
