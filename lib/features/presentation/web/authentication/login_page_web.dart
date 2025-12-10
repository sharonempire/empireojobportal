import 'dart:developer';

import 'package:empire_job/features/application/authentication/controller/auth_controller.dart';
import 'package:empire_job/routes/router_consts.dart';
import 'package:empire_job/shared/consts/images.dart';
import 'package:flutter/material.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:empire_job/features/presentation/widgets/common_textfield_widget.dart';
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/features/presentation/widgets/primary_button_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPageWeb extends ConsumerStatefulWidget {
  const LoginPageWeb({super.key});

  @override
  ConsumerState<LoginPageWeb> createState() => _LoginPageWebState();
}

class _LoginPageWebState extends ConsumerState<LoginPageWeb> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoggingIn = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
      webPosition: "center",
      webBgColor: "linear-gradient(to right, #dc2626, #ef4444)",
    );
  }

  void _showSuccess(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
      webPosition: "center",
      webBgColor: "linear-gradient(to right, #16a34a, #22c55e)",
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_isLoggingIn) return;

    setState(() {
      _isLoggingIn = true;
    });

    final authController = ref.read(authControllerProvider.notifier);
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      log('Attempting login with email: $email');
      await authController.login(email: email, password: password);
      log('Login successful - no exception thrown');
      _showSuccess('Login successful!');
    } catch (e) {
      log('Login exception caught: $e');
      String errorMessage = e.toString();

      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring(11);
      }

      log('Displaying error: $errorMessage');
      _showError(errorMessage);
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingIn = false;
        });
      }
    }
  }

  void _handleForgotPassword() {}

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width > 1100;

    if (!authState.isCheckingAuth && authState.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.go(RouterConsts.dashboardPath);
        }
      });
    }

    if (authState.isCheckingAuth) {
      return Scaffold(
        backgroundColor: ColorConsts.white,
        body: Center(
          child: CircularProgressIndicator(color: ColorConsts.primaryColor),
        ),
      );
    }

    return Scaffold(
      backgroundColor: context.themeScaffold,
      body: Container(
        constraints: BoxConstraints(minHeight: size.height),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
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
                        text: 'Welcome Back !',
                        fontSize: 50,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 12),
                      CustomText(
                        text:
                            'Access your HR dashboard and continue managing jobs and applicants.',
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 76),
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
                        suffixIcon: SizedBox(),
                        keyboardType: TextInputType.emailAddress,
                        useFloatingLabel: true,
                        borderColor: context.themeIconGrey,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email is required';
                          }
                          if (!value.contains('@') || !value.contains('.')) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: context.themeIconGrey,
                            size: 16,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Transform.scale(
                                scale: 0.8,
                                child: Checkbox(
                                  value: _rememberMe,
                                  onChanged: (value) {
                                    setState(() {
                                      _rememberMe = value ?? false;
                                    });
                                  },
                                  activeColor: context.themeDark,
                                  side: BorderSide(
                                    color: context.themeIconGrey,
                                  ),
                                ),
                              ),
                              CustomText(
                                text: 'Remember me',
                                fontSize: 10,
                                color: context.themeIconGrey,
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: _handleForgotPassword,
                            child: CustomText(
                              text: 'Forgot Password?',
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.red,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 36),
                      PrimaryButtonWidget(
                        text: _isLoggingIn ? 'Logging in...' : 'Login',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        showShadow: true,
                        showBorder: false,
                        offset: 4,
                        onPressed: _isLoggingIn ? () {} : _handleLogin,
                      ),
                      const SizedBox(height: 48),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            text: "Don't have an account? ",
                            fontSize: 12,
                          ),
                          GestureDetector(
                            onTap: () {
                              context.go(RouterConsts.signupPath);
                            },
                            child: CustomText(
                              text: 'Register',
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
                const SizedBox(width: 250),
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
    );
  }

  Widget _buildImage() {
    return Image.asset(ImageConsts.imgLogin, fit: BoxFit.contain);
  }
}
