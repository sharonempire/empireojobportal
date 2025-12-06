import 'package:empire_job/routes/router_consts.dart';
import 'package:empire_job/shared/consts/images.dart';
import 'package:flutter/material.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:empire_job/features/presentation/widgets/common_textfield_widget.dart';
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/features/presentation/widgets/primary_button_widget.dart';
import 'package:go_router/go_router.dart';

class LoginPageWeb extends StatefulWidget {
  const LoginPageWeb({super.key});

  @override
  State<LoginPageWeb> createState() => _LoginPageWebState();
}

class _LoginPageWebState extends State<LoginPageWeb> {
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

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {}
  }

  void _handleForgotPassword() {}


@override
Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final isLargeScreen = size.width > 900;

  return Scaffold(
    backgroundColor: context.themeScaffold,
    body: Center(
      child: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            minHeight: size.height,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 1, right: 16, top: 16, bottom: 16), // 100px from left
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center, // Vertical center
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
                          text: 'Login',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          showShadow: true,
                          showBorder: false,
                          offset: 4,
                          onPressed: _handleLogin,
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
                                context.go(RouterConsts.signupPagePath);
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
                const SizedBox(width: 90), 
                if (isLargeScreen)
                  Expanded(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: _buildImage(),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

  Widget _buildImage() {
    return Image.asset(ImageConsts.imgLogin, fit: BoxFit.contain);
  }
}
