import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:flutter/material.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorConsts.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.grid_view_rounded,
                label: 'Dashboard',
              ),

              _buildNavItem(index: 1, icon: Icons.work_outline, label: 'Jobs'),

              _buildNavItem(
                index: 2,
                icon: Icons.settings_outlined,
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 2,
            width: 40,
            decoration: BoxDecoration(
              color: isSelected ? ColorConsts.textColorRed : Colors.transparent,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          SizedBox(height: 5),
          Icon(
            icon,
            size: 17,
            color: isSelected ? ColorConsts.black : ColorConsts.iconGrey,
          ),
          const SizedBox(height: 4),
          CustomText(
            text: label,
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? ColorConsts.black : ColorConsts.iconGrey,
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
