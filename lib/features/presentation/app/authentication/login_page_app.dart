import 'package:empire_job/features/presentation/widgets/common_textfield_widget.dart';
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/features/presentation/widgets/primary_button_widget.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
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
      // Handle login
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title
                  const CustomText(
                    text: 'Welcome Back !',
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
                          'Access your HR dashboard and continue managing jobs and applicants.',
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: ColorConsts.textColor,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Illustration
                  Container(
                    height: 180,
                    width: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Image.network(
                      'https://cdn3d.iconscout.com/3d/premium/thumb/businessman-celebrating-success-3d-illustration-download-in-png-blend-fbx-gltf-file-formats--happy-victory-business-activity-pack-illustrations-4627261.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            color: ColorConsts.lightGrey2,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.person_outline,
                            size: 80,
                            color: ColorConsts.iconGrey,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                            strokeWidth: 2,
                            color: ColorConsts.iconGrey,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Email Field
                  _buildFieldLabel('Email Address'),
                  const SizedBox(height: 8),
                  CommonTextfieldWidget(
                    controller: _emailController,
                    hintText: 'Enter the email associated with your account.',
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
                    hintText: 'Enter your secure password.',
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
                  const SizedBox(height: 16),

                  // Remember Me & Forgot Password Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Remember Me Checkbox
                      Row(
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
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
                          const SizedBox(width: 8),
                          const CustomText(
                            text: 'Remember me',
                            fontSize: 13,
                            color: ColorConsts.textColor,
                          ),
                        ],
                      ),

                      // Forgot Password Link
                      GestureDetector(
                        onTap: _onForgotPassword,
                        child: const CustomText(
                          text: 'Forgot Password',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: ColorConsts.textColorRed,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Login Button
                  PrimaryButtonWidget(
                    text: 'Login',
                    onPressed: _onLogin,
                    backgroundColor: ColorConsts.black,
                    textColor: ColorConsts.white,
                    showBorder: false,
                    showShadow: false,
                    height: 52,
                    borderRadius: 26,
                  ),
                  const SizedBox(height: 32),

                  // Register Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CustomText(
                        text: "Don't have an account ? ",
                        fontSize: 14,
                        color: ColorConsts.textColor,
                      ),
                      GestureDetector(
                        onTap: _navigateToRegister,
                        child: const CustomText(
                          text: 'Register',
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
