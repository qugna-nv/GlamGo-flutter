import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:project_shop/gen/assets.gen.dart';
import 'package:project_shop/gen/colors.gen.dart';
import 'package:project_shop/widgets/input/default_formater.dart';
import 'package:project_shop/widgets/input/required_label.dart';
import 'package:project_shop/widgets/styles_widget/styles_widget.dart';

class DefaultOutlineTextFieldAction {
  final String? Function(String value)? onValidator;

  DefaultOutlineTextFieldAction({this.onValidator});
}

class DefaultTextField extends StatelessWidget {
  const DefaultTextField({
    super.key,
    this.action,
    this.height = 40,
    this.sizeTextLabel = 18.8,
    this.labelText = "",
    this.hintText = "",
    this.requiredSymbol = "*",
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.inputDecoration,
    required this.controller,
    this.style,
    this.trailing,
    this.leading,
    this.trailingIcon,
    this.leadingIcon,
    this.trailingText,
    this.trailingStyle,
    this.trailingIconColor,
    this.leadingText,
    this.leadingStyle,
    this.leadingIconColor,
    this.obscureText = false,
    this.enableSuggestions = true,
    this.autocorrect = false,
    this.focusNode,
    this.decoration,
    this.hintStyle,
    this.onChanged,
    required this.needRequired,
    this.contentPadding,
    this.onTapOutside,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.textInputAction,
    this.onSubmit,
    this.isDense = false,
    this.errorBorder,
    this.maxLines,
    this.maxLength,
    this.readOnly,
    this.inputFormatters,
    this.expands = false,
    this.minLines = 1,
    this.border,
    this.suffixIcon,
    this.autofocus = false,
    this.enableColor,
    this.floatingLabelBehavior,
    this.errorStyle,
    this.onTap,
    this.labelStyle,
    this.counterText,
    this.boldContent,
    this.cursorColor,
    this.filled = false,
    this.focusBorder,
    this.requiredStyle,
    this.fillColor,
    this.backgroundColor,
    this.isFloatLabel = true,
    this.textAlign = TextAlign.start,
  });

  // final double height;
  final BoxDecoration? decoration;

  // Common in use
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String labelText;
  final String hintText;
  final Color? cursorColor;
  final TextStyle? hintStyle;
  final double sizeTextLabel;

  final bool? readOnly;

  final InputDecoration? inputDecoration;
  final TextStyle? style;
  final Function(PointerDownEvent)? onTapOutside;

  final String requiredSymbol;
  final TextInputType keyboardType;
  final bool enabled;
  final bool obscureText;
  final bool enableSuggestions;
  final bool autocorrect;
  final Function(String?)? onChanged;
  final Widget? trailing;
  final Widget? trailingIcon;
  final String? trailingText;
  final TextStyle? trailingStyle;
  final TextStyle? requiredStyle;
  final Color? trailingIconColor;

  final Widget? leading;
  final String? leadingText;
  final TextStyle? leadingStyle;
  final Widget? leadingIcon;
  final Color? leadingIconColor;

  final DefaultOutlineTextFieldAction? action;

  final bool needRequired;

  final EdgeInsetsGeometry? contentPadding;

  final double? height;
  final int? minLines;
  final int? maxLines;

  final Color? enableColor;

  Color get _backgroundColor =>
      enabled ? Colors.transparent : enableColor ?? ColorName.white;

  final FormFieldValidator<String>? validator;

  final AutovalidateMode autovalidateMode;

  final TextInputAction? textInputAction;

  final void Function(String)? onSubmit;

  final bool isDense;

  final InputBorder? errorBorder;

  final int? maxLength;

  final List<TextInputFormatter>? inputFormatters;

  final bool expands;

  final InputBorder? border;

  final InputBorder? focusBorder;

  final Widget? suffixIcon;

  final bool autofocus;

  final FloatingLabelBehavior? floatingLabelBehavior;

  final TextStyle? errorStyle;

  final Function()? onTap;

  final TextStyle? labelStyle;

  final String? counterText;

  final bool? boldContent;
  final bool filled;
  final Color? fillColor;
  final Color? backgroundColor;
  final bool isFloatLabel;

  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isFloatLabel)
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: labelText,
                  style: Styles.normalTextW500(
                    size: 14.sp,
                    color: ColorName.neutralTablet,
                  ),
                ),
                if (needRequired)
                  TextSpan(
                    text: ' *',
                    style: Styles.normalTextW500(
                      color: ColorName.red32,
                      size: 16.sp,
                    ),
                  )
              ],
            ),
          ),
        if (!isFloatLabel) SizedBox(height: 8.w),
        Container(
          decoration: decoration ??
              Styles.boxDecoration1(radius: 10.r, color: _backgroundColor),
          height: height,
          child: TextFormField(
            onTap: onTap,
            cursorColor: cursorColor ?? ColorName.red5,
            onTapOutside: onTapOutside,
            focusNode: focusNode,
            obscureText: obscureText,
            // enableSuggestions: enableSuggestions,
            autocorrect: autocorrect,
            validator: validator,
            readOnly: readOnly ?? false,
            onChanged: onChanged,
            controller: controller,
            enabled: enabled,
            minLines: minLines,
            maxLines: maxLines,
            keyboardType: keyboardType,
            autovalidateMode: autovalidateMode,
            textAlign: textAlign,
            decoration: inputDecoration?.copyWith(
                    filled: filled,
                    fillColor: fillColor ?? Colors.white,
                    contentPadding: contentPadding,
                    hintText: hintText,
                    suffixIcon: trailingIcon,
                    suffix: trailing,
                    suffixStyle: trailingStyle,
                    suffixIconColor: trailingIconColor,
                    suffixText: trailingText,
                    prefix: leading,
                    hintStyle: hintStyle,
                    prefixIcon: leadingIcon,
                    prefixText: leadingText,
                    prefixIconColor: leadingIconColor,
                    prefixStyle: leadingStyle,
                    errorStyle: errorStyle,
                    counterText: "") ??
                Styles.inputDecoration1(
                  counterText: counterText,
                  label: (needRequired && isFloatLabel)
                      ? buildLabel(context)
                      : null,
                  hintText: hintText,
                  errorStyle: errorStyle,
                  suffixIcon: trailingIcon,
                  suffix: trailing,
                  suffixStyle: trailingStyle,
                  suffixIconColor: trailingIconColor,
                  suffixText: trailingText,
                  prefix: leading,
                  prefixIcon: leadingIcon,
                  prefixText: leadingText,
                  prefixIconColor: leadingIconColor,
                  prefixStyle: leadingStyle,
                  hintStyle: hintStyle,
                  contentPadding: contentPadding,
                  isDense: isDense,
                  errorBorder: errorBorder,
                  border: border,
                  enabledBorder: border,
                  focusedBorder: focusBorder,
                  floatingLabelBehavior: floatingLabelBehavior,
                ),
            style: boldContent == true
                ? Styles.normalTextW600(size: 16.sp, color: ColorName.black)
                : style ??
                    Styles.normalTextW600(
                            color: ColorName.primaryLightTextColor)
                        .copyWith(
                      fontWeight: FontWeight.w600,
                    ),
            onFieldSubmitted: onSubmit,
            maxLength: maxLength,
            inputFormatters: inputFormatters ??
                [
                  UpperCaseTextFormatter(),
                  LengthLimitingTextInputFormatter(2000),
                ],
            textCapitalization: TextCapitalization.sentences,
            expands: expands,
            textInputAction: textInputAction,
            autofocus: autofocus,
          ),
        ),
      ],
    );
  }

  Widget? buildClearBtn() {
    return IconButton(
      icon: SvgPicture.asset(Assets.icons.icClear),
      onPressed: () {
        controller.clear();
      },
    );
  }

  Widget buildLabel(BuildContext context) {
    return RequiredLabel(
      labelText: labelText,
      requiredSymbol: requiredSymbol,
      suffixIcon: suffixIcon,
      sizeText: sizeTextLabel,
      labelStyle: labelStyle,
      requiredStyle: requiredStyle,
    );
  }
}
