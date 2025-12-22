import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:empire_job/shared/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerLoading({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? ColorConsts.lightGrey.withOpacity(0.3),
      highlightColor: highlightColor ?? ColorConsts.lightGrey.withOpacity(0.1),
      child: child,
    );
  }
}

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double? borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: ColorConsts.white,
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
        ),
      ),
    );
  }
}

class ShimmerCircle extends StatelessWidget {
  final double size;

  const ShimmerCircle({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: ColorConsts.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

// Dashboard Shimmer
class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.rSpacing(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Create Job Card Shimmer
          ShimmerBox(
            width: double.infinity,
            height: context.rSpacing(120),
            borderRadius: context.rSpacing(12),
          ),
          SizedBox(height: context.rSpacing(24)),
          // Stats Row Shimmer
          Row(
            children: [
              Expanded(
                child: ShimmerBox(
                  width: double.infinity,
                  height: context.rSpacing(100),
                  borderRadius: context.rSpacing(12),
                ),
              ),
              SizedBox(width: context.rSpacing(12)),
              Expanded(
                child: ShimmerBox(
                  width: double.infinity,
                  height: context.rSpacing(100),
                  borderRadius: context.rSpacing(12),
                ),
              ),
            ],
          ),
          SizedBox(height: context.rSpacing(24)),
          // Recent Applications Shimmer
          ShimmerBox(
            width: double.infinity,
            height: context.rSpacing(300),
            borderRadius: context.rSpacing(8),
          ),
          SizedBox(height: context.rSpacing(24)),
          // Job Posting Status Shimmer
          ShimmerBox(
            width: double.infinity,
            height: context.rSpacing(200),
            borderRadius: context.rSpacing(8),
          ),
        ],
      ),
    );
  }
}

// View Job Page Shimmer
class ViewJobPageShimmer extends StatelessWidget {
  const ViewJobPageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(context.rSpacing(16)),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: context.rSpacing(16)),
          child: ShimmerBox(
            width: double.infinity,
            height: context.rSpacing(150),
            borderRadius: context.rSpacing(12),
          ),
        );
      },
    );
  }
}

// Notification Page Shimmer
class NotificationPageShimmer extends StatelessWidget {
  const NotificationPageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(context.rSpacing(16)),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: context.rSpacing(12)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerCircle(size: context.rSpacing(48)),
              SizedBox(width: context.rSpacing(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(
                      width: double.infinity,
                      height: context.rSpacing(16),
                      borderRadius: 4,
                    ),
                    SizedBox(height: context.rSpacing(8)),
                    ShimmerBox(
                      width: double.infinity,
                      height: context.rSpacing(12),
                      borderRadius: 4,
                    ),
                    SizedBox(height: context.rSpacing(4)),
                    ShimmerBox(
                      width: context.rSpacing(100),
                      height: context.rSpacing(10),
                      borderRadius: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Settings Page Shimmer
class SettingsPageShimmer extends StatelessWidget {
  const SettingsPageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.rSpacing(16)),
      child: Column(
        children: [
          // Company Card Shimmer
          ShimmerBox(
            width: double.infinity,
            height: context.rSpacing(80),
            borderRadius: context.rSpacing(25),
          ),
          SizedBox(height: context.rSpacing(24)),
          // Account Section Shimmer
          ShimmerBox(
            width: double.infinity,
            height: context.rSpacing(200),
            borderRadius: context.rSpacing(20),
          ),
          SizedBox(height: context.rSpacing(24)),
          // Logout Section Shimmer
          ShimmerBox(
            width: double.infinity,
            height: context.rSpacing(80),
            borderRadius: context.rSpacing(20),
          ),
        ],
      ),
    );
  }
}

