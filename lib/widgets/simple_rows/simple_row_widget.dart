import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_shop/gen/assets.gen.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';
import 'package:project_shop/utils/extension/extension.dart';
import 'package:project_shop/widgets/icon_widget/icon_widget.dart';
import 'package:project_shop/widgets/inkwell/default_ink_well.dart';
import 'package:project_shop/widgets/styles_widget/styles_widget.dart';
import 'package:velocity_x/velocity_x.dart';

class SimpleRowWidget extends StatelessWidget {
  const SimpleRowWidget({
    super.key,
    this.shape,
    this.imageFirst,
    this.imageSecond,
    this.contentFirst,
    this.onTap,
    this.styleContent,
    this.crossAxisAlignment,
    this.color,
    this.mainAxisAlignment,
    this.contentSecond,
    this.styleContentSecond,
    this.widget,
    this.isShowWidget = true,
    this.padding,
    this.disableOnclick = false,
    this.icText,
    this.textAlign,
    this.isWidthSizeBox,
    this.isUseSvg = true,
    this.pngPath = "",
    this.maxLine,
    this.textOverflow,
    this.spacer,
    this.isSpacer = true,
    this.iconSize,
  });

  final ShapeBorder? shape;
  final String? imageFirst, imageSecond;
  final String? contentFirst, contentSecond;
  final GestureTapCallback? onTap;
  final TextStyle? styleContent, styleContentSecond;
  final CrossAxisAlignment? crossAxisAlignment;
  final Color? color;
  final MainAxisAlignment? mainAxisAlignment;
  final Widget? widget;
  final bool isShowWidget;
  final double? spacer;
  final bool disableOnclick;
  final Widget? icText;
  final TextAlign? textAlign;
  final double? isWidthSizeBox;
  final bool isUseSvg;
  final String pngPath;
  final int? maxLine;
  final TextOverflow? textOverflow;
  final bool isSpacer;
  final EdgeInsets? padding;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return DefaultInkWell(
      onTap: onTap,
      enabled: !disableOnclick,
      child: Padding(
        padding:
            padding ?? EdgeInsets.symmetric(vertical: 12.w, horizontal: 4.w),
        child: Row(
          mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
          crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
          children: [
            isUseSvg
                ? imageFirst.isEmptyOrNull
                    ? const SizedBox()
                    : SvgPicture.asset(
                        imageFirst ?? Assets.icons.icUser,
                        color: color ?? ColorName.textLinkColor,
                        fit: BoxFit.scaleDown,
                        width: iconSize ?? 24,
                        height: iconSize ?? 24,
                      )
                : pngPath.isNullOrEmpty
                    ? const SizedBox()
                    : Image.asset(
                        pngPath,
                        fit: BoxFit.scaleDown,
                        width: iconSize ?? 24,
                        height: iconSize ?? 24,
                      ),
            SizedBox(
              width: isWidthSizeBox ?? 12.h,
            ),
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      contentFirst.orDash,
                      style: styleContent ??
                          Styles.normalText(
                            color: ColorName.blue17,
                          ),
                      overflow: textOverflow ?? TextOverflow.ellipsis,
                      maxLines: maxLine ?? 1,
                      textAlign: textAlign ?? TextAlign.justify,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  icText ?? const SizedBox(),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  contentSecond ?? '',
                  style: styleContentSecond ??
                      Styles.normalText(
                        color: ColorName.grey9,
                      ),
                ),
                SizedBox(
                  width: isSpacer
                      ? contentSecond == null
                          ? 0
                          : 8.w
                      : spacer ?? 0,
                ),
                isShowWidget
                    ? widget ??
                        IconWidget.ic24(
                            path: Assets.icons.icArrowRightNew, color: color)
                    : const SizedBox(),
                // imageSecond.isEmptyOrNull
                //     ? const SizedBox()
                //     : IconWidget.ic16(
                //         path: Assets.icons.icArrowRightNew, color: color),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
