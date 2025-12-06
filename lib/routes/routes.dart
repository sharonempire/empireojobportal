import 'package:empire_job/routes/router_consts.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouterConsts.loginPath,
  routes: RouterConsts.routes,
);
