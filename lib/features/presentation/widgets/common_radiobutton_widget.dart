import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:flutter/material.dart';

class CustomRadioButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomRadioButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? ColorConsts.textColorRed : context.themeDivider,
                width: 2,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorConsts.textColorRed,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          CustomText(
            text: text,
            fontSize: 14,
          ),
        ],
      ),
    );
  }
}
