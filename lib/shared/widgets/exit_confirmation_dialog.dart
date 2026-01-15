import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/features/presentation/widgets/primary_button_widget.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:empire_job/shared/utils/responsive.dart';
import 'package:flutter/material.dart';

Future<bool> showExitConfirmationDialog(BuildContext context) async {
  final shouldExit = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: context.rSpacing(20)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.rSpacing(18)),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.rSpacing(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top Icon
            Container(
              padding: EdgeInsets.all(context.rSpacing(14)),
              decoration: BoxDecoration(
                color: ColorConsts.textColorRed.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.exit_to_app_rounded,
                color: ColorConsts.textColorRed,
                size: context.rFontSize(30),
              ),
            ),

            SizedBox(height: context.rSpacing(18)),

            // Title
            CustomText(
              text: 'Exit App',
              fontSize: context.rFontSize(20),
              fontWeight: FontWeight.w700,
              color: ColorConsts.black,
            ),

            SizedBox(height: context.rSpacing(10)),

            // Description
            CustomText(
              text: 'Are you sure you want to exit the application?',
              fontSize: context.rFontSize(14),
              color: ColorConsts.textColor,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: context.rSpacing(24)),

            // Buttons Row
            Row(
              children: [
                // Cancel
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: ColorConsts.textColor.withOpacity(0.4),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          context.rSpacing(10),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: context.rSpacing(12),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(false),
                    child: CustomText(
                      text: 'Cancel',
                      fontSize: context.rFontSize(14),
                      color: ColorConsts.textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                SizedBox(width: context.rSpacing(12)),

                // Exit Button
                Expanded(
                  child: PrimaryButtonWidget(
                    text: 'Exit',
                    onPressed: () => Navigator.of(context).pop(true),
                    backgroundColor: ColorConsts.black,
                    textColor: ColorConsts.white,
                    showBorder: false,
                    height: context.rHeight(45),
                    fontSize: context.rFontSize(14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );

  return shouldExit ?? false;
}
