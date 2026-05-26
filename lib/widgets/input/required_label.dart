import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';
import 'package:project_shop/widgets/styles_widget/styles_widget.dart';

class RequiredLabel extends StatelessWidget {
  final String labelText;
  final String requiredSymbol;
  final Widget? suffixIcon;
  final double? sizeText;
  final bool? disable;
  final TextStyle? labelStyle;
  final TextStyle? requiredStyle;

  const RequiredLabel(
      {super.key,
      required this.labelText,
      this.requiredSymbol = "",
      this.suffixIcon,
      this.disable = false,
      this.sizeText,
      this.labelStyle,
      this.requiredStyle});

  @override
  Widget build(BuildContext context) {
    final labelStyle = this.labelStyle ??
        Styles.normalText().copyWith(
          fontWeight: FontWeight.w400,
          color: (disable ?? false)
              ? ColorName.hintColor
              : ColorName.primaryLightTextColor,
          fontSize: sizeText != null ? sizeText!.w : 18.8.sp,
        );
    return Wrap(
      direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          labelText,
          style: labelStyle,
        ),
        const Text(" "),
        Text(requiredSymbol,
            style: requiredStyle ??
                Styles.normalText(size: 18.sp).copyWith(color: ColorName.red5)),
        const Text(" "),
        if (suffixIcon != null) suffixIcon!,
      ],
    );
  }
}
