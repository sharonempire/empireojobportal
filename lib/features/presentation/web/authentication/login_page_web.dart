import 'package:empire_job/shared/consts/images.dart';
import 'package:flutter/material.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:empire_job/features/presentation/widgets/common_textfield_widget.dart';
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/features/presentation/widgets/primary_button_widget.dart';

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
    if (_formKey.currentState?.validate() ?? false) {
      // Handle login logic
      _formKey.currentState?.save();
      print('Login successful');
    }
  }

  void _handleForgotPassword() {
    // Navigate to forgot password page

    print('Navigate to forgot password');
  }

  void _handleRegister() {
    // Navigate to register page
    print('Navigate to register');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width > 900;

    return Scaffold(
      backgroundColor: context.themeDark,
      body: Center(
        child: SingleChildScrollView(
          child: isLargeScreen
              ? _buildLargeScreenLayout()
              : _buildSmallScreenLayout(),
        ),
      ),
    );
  }

  Widget _buildLargeScreenLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 1,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450),
            child: _buildForm(),
          ),
        ),
        const SizedBox(width: 80),
        Flexible(
          flex: 1,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: _buildImage(),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallScreenLayout() {
    return Column(
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 450),
          child: _buildForm(),
        ),
        const SizedBox(height: 40),
        Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: _buildImage(),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            text: 'Welcome Back !',
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 12),
          CustomText(
            text:
                'Access your HR dashboard and continue managing\njobs and applicants.',
            fontSize: 14,
            fontWeight: FontWeight.normal,
            maxLines: 2,
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
            fillColor: context.themeDark,
            hintText: 'Email Address',
            requiredField: true,
            keyboardType: TextInputType.emailAddress,
            useFloatingLabel: true,
            borderColor: context.themeIconGrey,
            borderRadius: 8,
            onChanged: (value) {},
          ),
          const SizedBox(height: 24),

          // Password Field
          CustomText(
            text: 'Password',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 8),
          CommonTextfieldWidget(
            fillColor: context.themeDark,

            controller: _passwordController,
            hintText: 'Enter your secure password.',
            obscureText: _obscurePassword,
            requiredField: true,
            useBorderOnly: true,
            borderRadius: 12,
            height: 50,
            useFloatingLabel: true,
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                      activeColor: context.themeDark,
                      side: BorderSide(color: context.themeIconGrey),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CustomText(
                    text: 'Remember me',
                    fontSize: 13,
                    color: context.themeIconGrey,
                  ),
                ],
              ),
              GestureDetector(
                onTap: _handleForgotPassword,
                child: CustomText(
                  text: 'Forgot Password?',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Login Button
          PrimaryButtonWidget(
            text: 'Login',
            onPressed: _handleLogin,
            backgroundColor: context.themeDark,
            textColor: context.themeWhite,
            height: 50,
            borderRadius: 12,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 20),

          // Register Link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: "Don't have an account? ",
                fontSize: 14,
                color: context.themeIconGrey,
              ),
              GestureDetector(
                onTap: _handleRegister,
                child: CustomText(
                  text: 'Register',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Image.asset(ImageConsts.imgLogin, fit: BoxFit.contain);
  }
}
