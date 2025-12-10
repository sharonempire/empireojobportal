import 'package:empire_job/routes/router_consts.dart';
import 'package:go_router/go_router.dart';

class RouteModel {
  const RouteModel({
    required this.path,
    required this.name,
    required this.appBuilder,
    this.webBuilder,
    this.children = const [],
  });

  final String path;
  final String name;
  final RouteScreenBuilder appBuilder;
  final RouteScreenBuilder? webBuilder;
  final List<RouteModel> children;

  GoRoute toRoute({String parentPath = ''}) {
    final String normalizedPath = _normalizeAbsolutePath(path);
    final String normalizedParent = parentPath.isEmpty
        ? ''
        : _normalizeAbsolutePath(parentPath);
    final bool isRoot = normalizedParent.isEmpty;
    final String goRouterPath = isRoot
        ? normalizedPath
        : _relativePath(normalizedPath, normalizedParent);

    return GoRoute(
      path: goRouterPath,
      name: name,
      builder: (context, state) => ResponsiveRouteLayout(
        state: state,
        appBuilder: appBuilder,
        webBuilder: webBuilder,
        breakpoint: RouterConsts.webBreakpoint,
      ),
      routes: children
          .map((child) => child.toRoute(parentPath: normalizedPath))
          .toList(),
    );
  }

  static String _normalizeAbsolutePath(String rawPath) {
    if (rawPath.isEmpty) {
      throw ArgumentError('Route path cannot be empty');
    }
    final String leading = rawPath.startsWith('/') ? rawPath : '/$rawPath';
    return leading.replaceAll(RegExp(r'//+'), '/');
  }

  static String _relativePath(String fullPath, String parentPath) {
    if (parentPath.isEmpty) {
      return fullPath;
    }
    if (!fullPath.startsWith(parentPath)) {
      throw ArgumentError(
        'Child path "$fullPath" must start with parent path "$parentPath".',
      );
    }
    final remainder = fullPath.substring(parentPath.length);
    if (remainder.isEmpty) {
      return '';
    }
    return remainder.replaceFirst(RegExp(r'^/+'), '');
  }
}

