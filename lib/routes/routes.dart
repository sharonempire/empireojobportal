import 'package:empire_job/features/application/authentication/controller/auth_controller.dart';
import 'package:empire_job/routes/router_consts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerAuthProvider = StreamProvider<bool>((ref) {
  return Stream.value(
    ref.watch(authControllerProvider.select((state) => state.isAuthenticated)),
  );
});

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouterConsts.loginPath,
    routes: RouterConsts.routes,
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);

      if (authState.isCheckingAuth) {
        return null;
      }

      final isAuthenticated = authState.isAuthenticated;
      final isLoginPage = state.matchedLocation == RouterConsts.loginPath;
      final isSignupPage = state.matchedLocation == RouterConsts.signupPath;
      if (isAuthenticated && (isLoginPage || isSignupPage)) {
        return RouterConsts.dashboardPath;
      }
      if (!isAuthenticated && !isLoginPage && !isSignupPage) {
        return RouterConsts.loginPath;
      }
    },
    debugLogDiagnostics: true,
  );
});
