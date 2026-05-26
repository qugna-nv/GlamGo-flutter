import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';
import 'package:project_shop/gen/fonts.gen.dart';

class Styles {
  static TextStyle getTextStyle({
    required Color color,
    required double fontSize,
    required FontWeight fontWeight,
    String fontFamily = FontFamily.inter,
  }) =>
      Theme.of(Get.context!).textTheme.bodySmall?.copyWith(
            color: color,
            fontSize: fontSize,
            fontWeight: fontWeight,
            fontFamily: fontFamily,
          ) ??
      TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
      );

  // Small text styles
  static TextStyle smallText({
    Color? color,
    String fontFamily = FontFamily.inter,
  }) =>
      getTextStyle(
        color: color ?? Colors.black,
        fontSize: 12,
        fontWeight: FontWeight.normal,
        fontFamily: fontFamily,
      );

  static TextStyle smallTextW500({
    Color? color,
    String fontFamily = FontFamily.inter,
  }) =>
      getTextStyle(
        color: color ?? Colors.black,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        fontFamily: fontFamily,
      );

  static TextStyle smallTextW700({
    Color? color,
    double? fontSize,
    String fontFamily = FontFamily.inter,
  }) =>
      getTextStyle(
        color: color ?? Colors.black,
        fontSize: fontSize ?? 12,
        fontWeight: FontWeight.w700,
        fontFamily: fontFamily,
      );

  static TextStyle smallTextW900({
    Color? color,
    String fontFamily = FontFamily.inter,
  }) =>
      getTextStyle(
        color: color ?? Colors.black,
        fontSize: 12,
        fontWeight: FontWeight.w900,
        fontFamily: fontFamily,
      );
  static TextStyle getNormalStyle(color, double font, fontWeight,
          {TextDecoration? decoration}) =>
      Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(
          color: color,
          fontSize: font,
          fontWeight: fontWeight,
          decoration: decoration,
          fontFamily: FontFamily.inter) ??
      TextStyle(
          color: color,
          fontSize: font,
          fontWeight: fontWeight,
          decoration: decoration,
          fontFamily: FontFamily.inter);

  static TextStyle normalText(
          {Color? color,
          double? size,
          FontWeight? fontWeight,
          TextDecoration? decoration}) =>
      getNormalStyle(
        color,
        size ?? 14.sp,
        fontWeight ?? FontWeight.w500,
        decoration: decoration,
      );

  static TextStyle normalTextW400({Color? color, double? size}) =>
      getNormalStyle(color, size ?? 14.sp, FontWeight.w400);

  static TextStyle normalTextW500({Color? color, double? size}) =>
      getNormalStyle(color, size ?? 14.sp, FontWeight.w500);

  static TextStyle normalTextW600({Color? color, double? size}) =>
      getNormalStyle(color, size ?? 14.sp, FontWeight.w600);

  static TextStyle normalTextW700({Color? color, double? size}) =>
      getNormalStyle(color, size ?? 14.sp, FontWeight.w700);

  static TextStyle normalTextW800({Color? color, double? size}) =>
      getNormalStyle(color, size ?? 14.sp, FontWeight.w800);

  static TextStyle normalTextW900({Color? color, double? size}) =>
      getNormalStyle(color, size ?? 14.sp, FontWeight.w900);

  static TextStyle normalTextBold({Color? color, double? size}) =>
      getNormalStyle(color, size ?? 14.sp, FontWeight.bold);

  //Medium.
  static TextStyle getMediumStyle(color, double font, fontWeight) =>
      Theme.of(Get.context!).textTheme.titleMedium?.copyWith(
          color: color,
          fontSize: font,
          fontWeight: fontWeight,
          fontFamily: FontFamily.inter) ??
      TextStyle(
          color: color,
          fontSize: font,
          fontWeight: fontWeight,
          fontFamily: FontFamily.inter);

  static TextStyle mediumText({Color? color}) =>
      getMediumStyle(color, 16.sp, FontWeight.normal);

  static TextStyle mediumTextW500({Color? color}) =>
      getMediumStyle(color, 16.sp, FontWeight.w500);

  static TextStyle mediumTextW600({Color? color}) =>
      getMediumStyle(color, 16.sp, FontWeight.w600);

  static TextStyle mediumTextW700({Color? color}) =>
      getMediumStyle(color, 16.sp, FontWeight.w700);

  static TextStyle mediumTextW800({Color? color}) =>
      getMediumStyle(color, 16.sp, FontWeight.w800);

  static TextStyle mediumTextW900({Color? color}) =>
      getMediumStyle(color, 16.sp, FontWeight.w900);

  static TextStyle mediumText18({Color? color}) =>
      getMediumStyle(color, 18.sp, FontWeight.normal);

  static TextStyle mediumText18W500({Color? color}) =>
      getMediumStyle(color, 18.sp, FontWeight.w500);

  static TextStyle mediumText18W600({Color? color}) =>
      getMediumStyle(color, 18.sp, FontWeight.w600);

  static TextStyle mediumText18W700({Color? color}) =>
      getMediumStyle(color, 18.sp, FontWeight.w700);

  static TextStyle mediumText18W800({Color? color}) =>
      getMediumStyle(color, 18.sp, FontWeight.w800);

  static TextStyle mediumText18W900({Color? color}) =>
      getMediumStyle(color, 18.sp, FontWeight.w900);

  static TextStyle buttonTextStyle({Color? color = Colors.white}) =>
      getMediumStyle(color, 14.sp, FontWeight.normal);

  static TextStyle disableButtonTextStyle({Color? color = Colors.grey}) =>
      getMediumStyle(color, 14.sp, FontWeight.normal);

  //Big.
  static TextStyle getBigStyle(color, double font, fontWeight) =>
      Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
          color: color,
          fontSize: font,
          fontWeight: fontWeight,
          fontFamily: FontFamily.inter) ??
      TextStyle(
          color: color,
          fontSize: font,
          fontWeight: fontWeight,
          fontFamily: FontFamily.inter);

  static TextStyle bigText({Color? color}) =>
      getBigStyle(color, 20.sp, FontWeight.normal);

  static TextStyle bigTextW500({Color? color}) =>
      getBigStyle(color, 20.sp, FontWeight.w500);

  static TextStyle bigTextW600({Color? color}) =>
      getBigStyle(color, 20.sp, FontWeight.w600);

  static TextStyle bigTextW700({Color? color}) =>
      getBigStyle(color, 20.sp, FontWeight.w700);

  static TextStyle bigTextW800({Color? color}) =>
      getBigStyle(color, 20.sp, FontWeight.w800);

  static TextStyle bigTextW900({Color? color}) =>
      getBigStyle(color, 20.sp, FontWeight.w900);

  static TextStyle getHugeStyle(color, double font, fontWeight) =>
      Theme.of(Get.context!).textTheme.headlineSmall?.copyWith(
          color: color,
          fontSize: font,
          fontWeight: fontWeight,
          fontFamily: FontFamily.inter) ??
      TextStyle(
          color: color,
          fontSize: font,
          fontWeight: fontWeight,
          fontFamily: FontFamily.inter);

  static TextStyle hugeText({Color? color}) =>
      getHugeStyle(color, 24.sp, FontWeight.normal);

  static TextStyle hugeTextW500({Color? color}) =>
      getHugeStyle(color, 24.sp, FontWeight.w500);

  static TextStyle hugeTextW600({Color? color}) =>
      getHugeStyle(color, 24.sp, FontWeight.w600);

  static TextStyle hugeTextW700({Color? color}) =>
      getHugeStyle(color, 24.sp, FontWeight.w700);

  static TextStyle hugeTextW800({Color? color}) =>
      getHugeStyle(color, 24.sp, FontWeight.w800);

  static TextStyle hugeTextW900({Color? color}) =>
      getHugeStyle(color, 24.sp, FontWeight.w900);

  static TextStyle hugeTextBold({Color? color}) =>
      getHugeStyle(color, 24.sp, FontWeight.bold);

  static TextStyle textError() =>
      TextStyle(fontSize: 12.sp, color: ColorName.red5);

  static TextStyle textMassive({double? fontSize}) => TextStyle(
        fontSize: fontSize ?? 30.sp,
        color: ColorName.white,
      );

  static TextStyle textMassiveW600({double? fontSize}) => TextStyle(
        fontSize: fontSize ?? 30.sp,
        color: ColorName.white,
        fontWeight: FontWeight.w600,
      );

  static TextStyle textUnderline({
    Color? color,
    double? size,
    FontWeight fWeight = FontWeight.w500,
  }) =>
      TextStyle(
          color: color,
          fontSize: size ?? 14.sp,
          fontWeight: fWeight,
          decoration: TextDecoration.underline,
          fontFamily: FontFamily.inter);

  ///italic text
  static TextStyle italicText(
          {Color? color,
          double? size,
          FontWeight fWeight = FontWeight.w500,
          TextDecoration decoration = TextDecoration.underline}) =>
      TextStyle(
          color: color,
          fontSize: size ?? 14.sp,
          fontWeight: fWeight,
          fontStyle: FontStyle.italic,
          decoration: decoration,
          fontFamily: FontFamily.inter);

  static TextStyle italicTextW500({
    Color? color,
    double? size,
    FontWeight fWeight = FontWeight.w500,
  }) =>
      TextStyle(
          color: color,
          fontSize: size ?? 14.sp,
          fontWeight: fWeight,
          fontStyle: FontStyle.italic,
          fontFamily: FontFamily.inter);

  ///Border TextField.
  static OutlineInputBorder inputBorder4(
      {Color color = ColorName.white4,
      double width = 1,
      double radius = 10,
      double gapPadding = 8}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      gapPadding: gapPadding,
      borderSide: BorderSide(color: color, width: width),
    );
  }

  static InputDecoration inputDecoration1(
      {String? labelText,
      String? hintText = "",
      TextStyle? hintStyle,
      Widget? label,
      Widget? prefix,
      Widget? prefixIcon,
      Color? prefixIconColor,
      String? prefixText,
      TextStyle? prefixStyle,
      Widget? suffix,
      Widget? suffixIcon,
      Color? suffixIconColor,
      String? suffixText,
      TextStyle? suffixStyle,
      bool isDense = false,
      EdgeInsetsGeometry? contentPadding,
      InputBorder? border,
      InputBorder? focusedBorder,
      InputBorder? enabledBorder,
      InputBorder? errorBorder,
      TextStyle? errorStyle,
      FloatingLabelBehavior? floatingLabelBehavior,
      String? counterText = ""}) {
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      errorStyle: errorStyle,
      label: label,
      alignLabelWithHint: true,
      border: border ?? Styles.inputBorder4(),
      focusedBorder: focusedBorder ?? Styles.inputBorder4(),
      enabledBorder: enabledBorder ?? Styles.inputBorder4(),
      errorBorder: errorBorder ?? Styles.inputBorder4(color: ColorName.error),
      hintStyle: hintStyle ?? Styles.smallText(color: ColorName.onSurface),
      labelStyle: Styles.smallText(color: ColorName.onPrimary),
      suffix: suffix,
      suffixIconColor: suffixIconColor,
      suffixText: suffixText,
      suffixStyle: suffixStyle,
      prefix: prefix,
      prefixText: prefixText,
      prefixStyle: prefixStyle,
      prefixIcon: prefixIcon,
      prefixIconColor: prefixIconColor,
      floatingLabelBehavior:
          floatingLabelBehavior ?? FloatingLabelBehavior.always,
      suffixIcon: suffixIcon,
      isDense: isDense,
      contentPadding: contentPadding,
      fillColor: Colors.white,
      counterText: counterText,
    );
  }

  static InputDecoration inputDecoration2({
    String? labelText,
    String? hintText = "",
    Widget? label,
    Widget? prefix,
    Widget? prefixIcon,
    Color? prefixIconColor,
    String? prefixText,
    TextStyle? prefixStyle,
    Widget? suffix,
    Widget? suffixIcon,
    Color? suffixIconColor,
    String? suffixText,
    TextStyle? suffixStyle,
  }) {
    return InputDecoration(
        hintText: hintText,
        fillColor: ColorName.frameColor(),
        labelText: labelText,
        filled: true,
        label: label,
        alignLabelWithHint: true,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        hintStyle: Styles.smallText(color: ColorName.onSurface),
        labelStyle: Styles.smallText(color: ColorName.onPrimary),
        suffix: suffix,
        suffixIconColor: suffixIconColor,
        suffixText: suffixText,
        suffixStyle: suffixStyle,
        prefix: prefix,
        prefixText: prefixText,
        prefixStyle: prefixStyle,
        prefixIcon: prefixIcon,
        prefixIconColor: prefixIconColor,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: suffixIcon);
  }

  ///Border Dialog.
  static OutlinedBorder borderDialog({double radius = 8}) {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));
  }

  ///Box shadow.
  //0px 4px 8px rgba(0, 0, 0, 0.15);
  static List<BoxShadow> boxShadow1() {
    return [
      const BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.15),
        blurRadius: 8,
        offset: Offset(0, 4),
      ),
    ];
  }

  static List<BoxShadow> boxShadow2() {
    return [
      BoxShadow(
        color: Colors.grey.withOpacity(0.2),
        blurRadius: 4,
        spreadRadius: 1,
        offset: const Offset(0, 0),
      ),
    ];
  }

  static List<BoxShadow> boxShadow3() {
    return [
      BoxShadow(
        color: Colors.grey.withOpacity(0.2),
        blurRadius: 4,
        spreadRadius: 1,
        offset: const Offset(0, 2),
      ),
    ];
  }

  ///BoxDecoration.
  static BoxDecoration boxDecoration1(
      {double radius = 8, Color color = Colors.white}) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
    );
  }

  static BoxDecoration boxDecoration2(
      {double radius = 8, double border = 1, Color? color}) {
    return BoxDecoration(
      color: Colors.white,
      border: Border.all(width: border, color: color ?? ColorName.neutral8()),
      borderRadius: BorderRadius.circular(radius),
    );
  }

  static BoxDecoration boxDecoration3(
      {double? radius, double border = 1, Color? color}) {
    return BoxDecoration(
      color: Colors.transparent,
      border: Border.all(width: border, color: color ?? ColorName.neutral8()),
      borderRadius: BorderRadius.circular(radius ?? 8.w),
    );
  }

  static InputBorder focusBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r), // Same as container
      borderSide: const BorderSide(
        color: ColorName.blue23,
        width: 3.0,
      ),
    );
  }
}
