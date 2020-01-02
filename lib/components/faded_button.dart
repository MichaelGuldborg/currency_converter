import 'package:currency_converter/app_colors.dart';
import 'package:currency_converter/app_styles.dart';
import 'package:flutter/material.dart';

class FadedButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const FadedButton({
    Key key,
    this.onTap,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      highlightColor: AppColors.blackActive,
      splashColor: AppColors.blackActive,
      child: Container(
        padding: AppStyles.boxPadding,
        color: AppColors.blackInActive,
        alignment: Alignment.center,
        child: Text(text, style: AppStyles.textMediumWhite),
      ),
    );
  }
}
