import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:flutter/material.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final int currentStep;

  const ProgressIndicatorWidget({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(4, (index) {
        final stepNumber = index + 1;
        final isActive = stepNumber <= currentStep;

        return Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? context.themeDark
                    : context.themeBorderLightGrey,
              ),
              child: Center(
                child: CustomText(
                  text: stepNumber.toString(),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isActive ? context.themeWhite : context.themeIconGrey,
                ),
              ),
            ),
            if (stepNumber < 4)
              Container(
                width: 4,
                height: 110,
                color: isActive ? ColorConsts.black : context.themeBorderLightGrey,
              ),
          ],
        );
      }),
    );
  }
}

