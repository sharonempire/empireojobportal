import 'package:empire_job/features/presentation/web/authentication/login_page_web.dart';
import 'package:empire_job/features/presentation/web/authentication/signup_page_web.dart';
import 'package:empire_job/features/presentation/web/dashboard/dashboard_page_web.dart';
import 'package:empire_job/features/presentation/web/job/create_job_page_web.dart';
import 'package:empire_job/features/presentation/web/job/manage_jobs_page_web.dart';
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
  static const String signupPagePath = '/signUp';
  static const String settingsPath = '/settings';
  static const String dashboardPath = '/dashBoard';
  static const String createJobPath = '/createJob';
  static const String manageJobsPath = '/manageJobs';

  static const String splashScreenPath = '/splash';

  // Route Names
  static const String loginName = 'login';
  static const String signupName = 'signup';
  static const String settingsName = 'settings';
  static const String dashboardName = 'dashBoard';
  static const String createJobName = 'createJob';
  static const String manageJobsName = 'manageJobs';

  static const String splashName = 'splash';

  static final List<RouteModel> routeModels = List.unmodifiable([
    RouteModel(
      path: loginPath,
      name: loginName,
      appBuilder: (context, state) => const LoginPageWeb(),
      webBuilder: (context, state) => const LoginPageWeb(),
    ),
    RouteModel(
      path: signupPagePath,
      name: signupName,
      appBuilder: (context, state) => const SignupPageWeb(),
      webBuilder: (context, state) => const SignupPageWeb(),
    ),
    RouteModel(
      path: settingsPath,
      name: settingsName,
      appBuilder: (context, state) => const SettingsPageWeb(),
      webBuilder: (context, state) => const SettingsPageWeb(),
    ),
    RouteModel(
      path: dashboardPath,
      name: dashboardName,
      appBuilder: (context, state) => const DashboardPageWeb(),
      webBuilder: (context, state) => const DashboardPageWeb(),
    ),
    RouteModel(
      path: createJobPath,
      name: createJobName,
      appBuilder: (context, state) => const CreateJobPageWeb(),
      webBuilder: (context, state) => const CreateJobPageWeb(),
    ),
    RouteModel(
      path: manageJobsPath,
      name: manageJobsName,
      appBuilder: (context, state) => const ManageJobsPageWeb(),
      webBuilder: (context, state) => const ManageJobsPageWeb(),
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
