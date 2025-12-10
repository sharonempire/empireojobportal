import 'package:empire_job/features/application/authentication/controller/auth_controller.dart';
import 'package:empire_job/routes/router_consts.dart';
import 'package:empire_job/shared/consts/images.dart';
import 'package:empire_job/shared/utils/snackbar_helper.dart';
import 'package:empire_job/features/data/network/network_calls.dart';
import 'package:flutter/material.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:empire_job/features/presentation/widgets/common_textfield_widget.dart';
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/features/presentation/widgets/primary_button_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignupPageWeb extends ConsumerStatefulWidget {
  const SignupPageWeb({super.key});

  @override
  ConsumerState<SignupPageWeb> createState() => _SignupPageWebState();
}

class _SignupPageWebState extends ConsumerState<SignupPageWeb> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _companyController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isProcessing = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _companyController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

Future<void> _handleRegister() async {
  if (_formKey.currentState?.validate() ?? false) {
    if (_isProcessing) return;
    
    setState(() {
      _isProcessing = true;
    });
    
    try {
      await ref.read(authControllerProvider.notifier).signup(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            companyName: _companyController.text.trim(),
          );

      debugPrint('Signup successful!');
      
      if (mounted) {
        context.showSuccessSnackbar('Account created successfully! Please login to continue.');
        
        await Future.delayed(const Duration(milliseconds: 500));
        try {
          final authController = ref.read(authControllerProvider.notifier);
          await authController.logout();
        } catch (logoutError) {
          try {
            final networkService = ref.read(networkServiceProvider);
            await networkService.auth.signOut();
          } catch (e) {
            debugPrint('Direct logout also failed: $e');
          }
        }
        
        await Future.delayed(const Duration(milliseconds: 500));
        
        if (mounted) {
          context.go(RouterConsts.loginPath);
        }
      }
    } catch (e) {

      if (mounted) {
        String errorMessage = e.toString();
                if (errorMessage.startsWith('Exception: ')) {
          errorMessage = errorMessage.substring(11);
        }
        if (errorMessage.startsWith('Error: ')) {
          errorMessage = errorMessage.substring(7);
        }
        if (errorMessage.contains('General error during signup: ')) {
          errorMessage = errorMessage.split('General error during signup: ').last;
        }
        errorMessage = errorMessage.trim();
                context.showErrorSnackbar(errorMessage);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }
}

  void _handleLogin() {
    if (!_isProcessing) {
      context.go(RouterConsts.loginPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
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
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Company name is required';
                              }
                              if (value.trim().length < 2) {
                                return 'Company name must be at least 2 characters';
                              }
                              return null;
                            },
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                            suffixIcon: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: context.themeIconGrey,
                                size: 16,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                            ),
                            onChanged: (value) {},
                          ),
                          const SizedBox(height: 36),
                          PrimaryButtonWidget(
                            text: _isProcessing || authState.isLoading
                                ? 'Creating Account...'
                                : 'Create Account',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            showShadow: true,
                            showBorder: false,
                            offset: 4,
                            onPressed: (_isProcessing || authState.isLoading)
                                ? (){}
                                : () {
                                    _handleRegister();
                                  },
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