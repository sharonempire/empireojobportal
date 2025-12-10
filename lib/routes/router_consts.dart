import 'package:empire_job/features/presentation/app/authentication/login_page_app.dart';
import 'package:empire_job/features/presentation/app/authentication/signup_page_app.dart';
import 'package:empire_job/features/presentation/web/authentication/login_page_web.dart';
import 'package:empire_job/features/presentation/web/authentication/signup_page_web.dart';
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
  static const String splashScreenPath = '/splash';

  // Route Names
  static const String loginName = 'login';
  static const String signupName = 'signup';
  static const String splashName = 'splash';

  static final List<RouteModel> routeModels = List.unmodifiable([
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
