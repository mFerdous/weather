import 'package:flutter/material.dart';

import '../../../../core/resources/color_res.dart';
import '../../../../core/utils/lang/app_localizations.dart';

class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final bool isDisabled;
  final Color? color;

  const AppButton({
    Key? key,
    required this.title,
    this.onTap,
    this.padding,
    this.isDisabled = false,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isDisabled ? null : onTap,
      child: Container(
        padding: padding ??
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        decoration: BoxDecoration(
            color: isDisabled
                ? color ?? ColorRes.kButtonBG.withOpacity(0.5)
                : color ?? ColorRes.kButtonBG,
            borderRadius: BorderRadius.circular(5.0)),
        child: Text(
          AppLocalizations.of(context).translate(title),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.white,
            fontFamily: 'Roboto',
          ),
        ),
      ),
    );
  }
}
