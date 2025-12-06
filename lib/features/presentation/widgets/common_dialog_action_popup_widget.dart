
import 'package:empire_job/features/presentation/widgets/custom_text.dart';
import 'package:empire_job/features/presentation/widgets/primary_button_widget.dart';
import 'package:empire_job/shared/consts/color_consts.dart';
import 'package:flutter/material.dart';

class DialogAction {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final bool showBorder;

  const DialogAction({
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.showBorder = false,
  });
}

class CommonDialogWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<DialogAction> actions;
  final bool showCloseButton;
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool barrierDismissible;

  const CommonDialogWidget({
    super.key,
    required this.title,
    this.subtitle,
    required this.actions,
    this.showCloseButton = true,
    this.width = 350,
    this.height = 200,
    this.borderRadius = 12,
    this.padding,
    this.barrierDismissible = true,
  });

  static void show({
    required BuildContext context,
    required String title,
    String? subtitle,
    required List<DialogAction> actions,
    bool showCloseButton = true,
    double? width = 350,
    double? height = 200,
    double borderRadius = 12,
    EdgeInsetsGeometry? padding,
    bool barrierDismissible = true,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return CommonDialogWidget(
          title: title,
          subtitle: subtitle,
          actions: actions,
          showCloseButton: showCloseButton,
          width: width,
          height: height,
          borderRadius: borderRadius,
          padding: padding,
          barrierDismissible: barrierDismissible,
        );
      },
    );
  }

  Color _getThemeScaffold(BuildContext context) {
    return Theme.of(context).scaffoldBackgroundColor;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.themeWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            Padding(
              padding: padding ?? const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: title,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: context.themeDark,
                    textAlign: TextAlign.center,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 8),
                    CustomText(
                      text: subtitle!,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: context.themeDark.withOpacity(0.7),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: actions.asMap().entries.map((entry) {
                      final index = entry.key;
                      final action = entry.value;
                      return Row(
                        children: [
                          if (index > 0) const SizedBox(width: 8),
                          PrimaryButtonWidget(
                            width: _calculateButtonWidth(
                              actions.length,
                              action.text,
                            ),
                            elevation: 0,
                            height: 30,
                            borderRadius: 8,
                            backgroundColor:
                                action.backgroundColor ??
                                _getThemeScaffold(context),
                            textColor: action.textColor ?? context.themeDark,
                            fontSize: 9,
                            showBorder: action.showBorder,
                            text: action.text,
                            offset: 0,
                            onPressed: () {
                              action.onPressed();
                            },
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            if (showCloseButton)
              Positioned(
                top: 16,
                right: 20,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(Icons.close, size: 16, color: context.themeDark),
                ),
              ),
          ],
        ),
      ),
    );
  }

  double _calculateButtonWidth(int actionCount, String text) {
    final baseWidth = text.length > 10 ? 125.0 : 100.0;
    if (actionCount == 1) return baseWidth + 25;
    if (actionCount == 2) return baseWidth;
    return 80.0;
  }
}
