import 'package:empire_job/features/application/authentication/controller/auth_controller.dart';
import 'package:empire_job/features/data/storage/shared_preferences.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Wait a bit for splash screen to be visible
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final sharedPrefs = ref.read(sharedPrefsProvider);
    final isLoggedIn = sharedPrefs.isLoggedIn();
    
    // Check Supabase authentication
    final authState = ref.read(authControllerProvider);
    final isAuthenticated = authState.isAuthenticated;

    if (isLoggedIn && isAuthenticated) {
      // User is logged in, navigate to dashboard
      if (mounted) {
        context.goNamed('dashboard');
      }
    } else {
      // User is not logged in, navigate to login
      if (mounted) {
        context.goNamed('login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConsts.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo or Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: ColorConsts.primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.work_outline,
                size: 60,
                color: ColorConsts.white,
              ),
            ),
            const SizedBox(height: 24),
            // App Name
            const Text(
              'Empire Job',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: ColorConsts.black,
              ),
            ),
            const SizedBox(height: 48),
            // Loading Indicator
            const CircularProgressIndicator(
              color: ColorConsts.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

