import 'package:empire_job/features/presentation/app/authentication/login_page_app.dart';
import 'package:empire_job/features/presentation/app/authentication/signup_page_app.dart';
import 'package:empire_job/features/presentation/app/dashborad/dashbord.dart';
import 'package:empire_job/features/presentation/app/job/job_page_app.dart';
import 'package:empire_job/features/presentation/app/job/view_job_page_app.dart';
import 'package:empire_job/features/presentation/app/notification/notification.dart';
import 'package:empire_job/features/presentation/app/settings/change_password.dart';
import 'package:empire_job/features/presentation/app/settings/company_settings.dart';
import 'package:empire_job/features/presentation/app/settings/settings_page_app.dart';
import 'package:empire_job/features/presentation/app/splash/splash_screen.dart';
import 'package:empire_job/features/presentation/web/authentication/login_page_web.dart';
import 'package:empire_job/features/presentation/web/authentication/signup_page_web.dart';
import 'package:empire_job/features/presentation/web/dashboard/dashboard_page_web.dart';
import 'package:empire_job/features/presentation/web/job/create_job_page_web.dart';
import 'package:empire_job/features/presentation/web/job/manage_jobs_page_web.dart';
import 'package:empire_job/features/presentation/web/notifications/notifications_page_web.dart';
import 'package:empire_job/features/presentation/web/settings/settings_page_web.dart';
import 'package:empire_job/routes/route_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

typedef RouteScreenBuilder =
    Widget Function(BuildContext context, GoRouterState state);

class RouterConsts {
  RouterConsts._();

  static const double webBreakpoint = 700;

  // Route Paths
  static const String loginPath = '/login';
  static const String signupPath = '/signup';
  static const String dashboardPath = '/dashboard';
  static const String addJobPath = '/add-job';
  static const String viewJobPath = '/view-job';
  static const String settingsPath = '/settings';
  static const String companySettingsPath = '/company-settings';
  static const String changePasswordPath = '/change-password';
  static const String notificationsPath = '/notifications';
  static const String splashScreenPath = '/splash';

  // Route Names
  static const String loginName = 'login';
  static const String signupName = 'signup';
  static const String dashboardName = 'dashboard';
  static const String addJobName = 'addJob';
  static const String viewJobName = 'viewJob';
  static const String settingsName = 'settings';
  static const String companySettingsName = 'companySettings';
  static const String changePasswordName = 'changePassword';
  static const String notificationsName = 'notifications';
  static const String splashName = 'splash';

  static final List<RouteModel> routeModels = List.unmodifiable([
    // Splash Screen Route
    RouteModel(
      path: splashScreenPath,
      name: splashName,
      appBuilder: (context, state) => const SplashScreen(),
      webBuilder: (context, state) => const SplashScreen(),
    ),
    // Authentication Routes
    RouteModel(
      path: loginPath,
      name: loginName,
      appBuilder: (context, state) => const LoginPageApp(),
      webBuilder: (context, state) => const LoginPageWeb(),
    ),
    RouteModel(
      path: signupPath,
      name: signupName,
      appBuilder: (context, state) => const SignupPageApp(),
      webBuilder: (context, state) => const SignupPageWeb(),
    ),

    // Dashboard Route
    RouteModel(
      path: dashboardPath,
      name: dashboardName,
      appBuilder: (context, state) => const Dashbord(),
      webBuilder: (context, state) => const DashboardPageWeb(),
    ),

    // Job Routes
    RouteModel(
      path: addJobPath,
      name: addJobName,
      appBuilder: (context, state) => const JobPageApp(),
      webBuilder: (context, state) => const CreateJobPageWeb(),
    ),
    RouteModel(
      path: viewJobPath,
      name: viewJobName,
      appBuilder: (context, state) => const ViewJobPageApp(),
      webBuilder: (context, state) => const ManageJobsPageWeb(),
    ),

    // Settings Routes
    RouteModel(
      path: settingsPath,
      name: settingsName,
      appBuilder: (context, state) => const SettingsPageApp(),
      webBuilder: (context, state) => const SettingsPageWeb(),
    ),
    RouteModel(
      path: companySettingsPath,
      name: companySettingsName,
      appBuilder: (context, state) => const CompanySettings(),
      webBuilder: (context, state) => const CompanySettings(),
    ),
    RouteModel(
      path: changePasswordPath,
      name: changePasswordName,
      appBuilder: (context, state) => const ChangePassword(),
      webBuilder: (context, state) => const ChangePassword(),
    ),

    // Notifications Route
    RouteModel(
      path: notificationsPath,
      name: notificationsName,
      appBuilder: (context, state) => const NotificationPageApp(),
      webBuilder: (context, state) => const NotificationsPageWeb(),
    ),
  ]);

  static final List<GoRoute> routes = List.unmodifiable(
    routeModels.map((route) => route.toRoute()),
  );
}

class ResponsiveRouteLayout extends StatelessWidget {
  const ResponsiveRouteLayout({
    super.key,
    required this.state,
    required this.appBuilder,
    this.webBuilder,
    required this.breakpoint,
  });

  final GoRouterState state;
  final RouteScreenBuilder appBuilder;
  final RouteScreenBuilder? webBuilder;
  final double breakpoint;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool preferWebLayout =
        screenWidth >= breakpoint && webBuilder != null;
    final RouteScreenBuilder builder =
        (preferWebLayout ? webBuilder : null) ?? appBuilder;
    return builder(context, state);
  }
}
