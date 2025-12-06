import 'package:flutter/material.dart';

class ResponsiveHorizontalScroll extends StatelessWidget {
  const ResponsiveHorizontalScroll({
    super.key,
    required this.child,
    this.minWidth = 950,
    this.breakpoint = 950,
  });

  final Widget child;
  final double minWidth;
  final double breakpoint;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < breakpoint) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: minWidth,
              height: constraints.maxHeight,
              child: child,
            ),
          );
        }
        return child;
      },
    );
  }
}