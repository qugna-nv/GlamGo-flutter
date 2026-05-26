import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';
import 'package:project_shop/widgets/icon_widget/icon_widget.dart';
import 'package:project_shop/widgets/inkwell/default_ink_well.dart';
import 'package:project_shop/widgets/styles_widget/styles_widget.dart';

class IButton extends StatefulWidget {
  factory IButton.primaryNormal({
    required String title,
    VoidCallback? onPress,
    double? fontSize,
    Color? backgroundColor,
    Color? borderColor,
    bool isDisable = false,
    double? radius = 8,
    Color? textColor,
    TextStyle? textStyle,
    bool isLoading = false,
    EdgeInsets? contentPadding,
    double? height,
    double? minWidth,
    String? iconFirst,
    String? iconSecond,
    Color? iconFirstColor,
    Color? iconSecondColor,
    double? width,
  }) =>
      IButton(
        title: title,
        color: backgroundColor ?? ColorName.primary,
        onPress: onPress,
        borderColor: borderColor,
        radius: radius,
        textColor: textColor,
        fontSize: fontSize,
        isDisable: isDisable,
        isLoading: isLoading,
        contentPadding: contentPadding,
        textStyle: Styles.mediumTextW600(),
        height: height,
        minWidth: minWidth,
        iconFirst: iconFirst,
        iconSecond: iconSecond,
        iconFirstColor: iconFirstColor,
        iconSecondColor: iconSecondColor,
        width: width,
      );

  factory IButton.primaryLarge(
          {required String title,
          Color? backgroundColor,
          Color? textColor,
          VoidCallback? onPress,
          bool isLoading = false,
          bool isNormal = false,
          bool isDisable = false,
          double? height,
          String? iconFirst,
          String? iconSecond}) =>
      IButton(
        title: title,
        color: backgroundColor ?? ColorName.primary,
        isNormal: isNormal,
        textColor: textColor,
        onPress: onPress,
        isDisable: isDisable,
        isLoading: isLoading,
        height: height,
        iconFirst: iconFirst,
        iconSecond: iconSecond,
      );

  factory IButton.secondary({
    required String title,
    VoidCallback? onPress,
    bool isLoading = false,
    bool outline = true,
    double? radius = 8,
    Color? textColor,
    Color? borderColor,
    Color backgroundColor = ColorName.white,
    bool isDisable = false,
    TextStyle? textStyle,
    EdgeInsets? contentPadding,
    double? height,
    double? minWidth,
    String? iconFirst,
    String? iconSecond,
    Color? iconFirstColor,
    Color? iconSecondColor,
  }) =>
      IButton(
        title: title,
        color: backgroundColor,
        onPress: onPress,
        radius: radius,
        textColor: textColor,
        outline: outline,
        isDisable: isDisable,
        isLoading: isLoading,
        textStyle: Styles.mediumTextW600(),
        contentPadding: contentPadding,
        borderColor: borderColor,
        height: height,
        minWidth: minWidth,
        iconFirst: iconFirst,
        iconSecond: iconSecond,
        iconFirstColor: iconFirstColor,
        iconSecondColor: iconSecondColor,
      );

  final String title;
  final Color? color;
  final bool isNormal;
  final Color? textColor;
  final bool isDisable;
  final VoidCallback? onPress;
  final bool isLoading;
  final double? fontSize;
  final EdgeInsetsGeometry? contentPadding;
  final double? height;
  final double? minWidth;
  final double? width;
  final double? radius;
  final TextStyle? textStyle;
  final Color? borderColor;
  final bool? outline;
  final String? iconFirst;
  final String? iconSecond;
  final Color? iconFirstColor;
  final Color? iconSecondColor;

  const IButton(
      {super.key,
      required this.title,
      required this.color,
      this.isNormal = true,
      this.isDisable = false,
      this.isLoading = false,
      this.fontSize,
      this.onPress,
      this.textColor,
      this.contentPadding,
      this.height,
      this.minWidth,
      this.width,
      this.radius = 8,
      this.textStyle,
      this.borderColor,
      this.outline,
      this.iconFirst,
      this.iconSecond,
      this.iconFirstColor,
      this.iconSecondColor});

  @override
  State<IButton> createState() => _IButtonState();
}

class _IButtonState extends State<IButton> {
  Widget _loading() {
    return SizedBox(
      height: widget.isNormal ? 24 : 30.0,
      width: widget.isNormal ? 24 : 30.0,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: ColorName.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final double height = widget.height ?? (widget.isNormal ? 38 : 48);
    // final textColor =
    //     widget.outline == true ? ColorName.textLinkColor : ColorName.white;
    return Material(
      borderRadius: BorderRadius.circular(widget.radius ?? 24),
      color: widget.color,
      child: DefaultInkWell(
        background: widget.isDisable
            ? ColorName.grey52
            : widget.color ?? ColorName.primary,
        onTap: () {
          if (!(widget.isDisable || widget.isLoading) &&
              widget.onPress != null) {
            widget.onPress!();
          }
        },
        radius: widget.radius ?? 24.r,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: widget.minWidth ?? 88,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 0.w),
            decoration: BoxDecoration(
                // color: widget.color,
                borderRadius: BorderRadius.circular(widget.radius ?? 24.r),
                border: widget.outline == true
                    ? Border.all(color: widget.borderColor ?? ColorName.grey39)
                    : null),
            height: widget.height ?? (38.w),
            width: widget.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.iconFirst != null
                    ? IconWidget.ic20(
                        color: widget.iconFirstColor,
                        path: widget.iconFirst ?? '',
                      )
                    : const SizedBox(),
                SizedBox(
                  width: widget.iconFirst != null ? 8.w : 0.w,
                ),
                Center(
                    child: widget.isLoading
                        ? _loading()
                        : Text(
                            widget.title,
                            textAlign: TextAlign.center,
                            style: widget.textStyle?.copyWith(
                              color: widget.isDisable
                                  ? ColorName.grey50
                                  : widget.textColor ??
                                      (widget.outline == true
                                          ? ColorName.textLinkColor
                                          : ColorName.white),
                              fontSize: widget.fontSize,
                            ),
                          )),
                SizedBox(
                  width: widget.iconSecond != null ? 8.w : 0.w,
                ),
                widget.iconSecond != null
                    ? IconWidget.ic20(
                        color: widget.iconSecondColor,
                        path: widget.iconSecond ?? '',
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
