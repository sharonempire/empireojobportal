import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const StatsCard({super.key, 
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.themeWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: context.themeIconGrey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color:context.themeDark),
          const SizedBox(height: 16),
          CustomText(
            text: title,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color:context.themeGrey600,
          ),
          const SizedBox(height: 8),
          CustomText(
            text: value,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }
}