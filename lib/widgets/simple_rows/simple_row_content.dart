import 'package:flutter/widgets.dart';
import 'package:project_shop/gen/colors.gen.dart';
import 'package:project_shop/widgets/styles_widget/styles_widget.dart';

class SimpleRowContent extends StatelessWidget {
  const SimpleRowContent({
    super.key,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.contentFirst,
    this.contentSecond,
    this.firstMaxLines,
    this.secondMaxLine,
    this.firstTextOverflow,
    this.secondTextOverflow,
    this.firstStyle,
    this.secondStyle,
    this.widthSizeBox,
    this.widget,
    this.isShowWidget = true,
    this.maxLines = 1,
  });

  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  final String? contentFirst, contentSecond;
  final int? firstMaxLines, secondMaxLine;
  final TextOverflow? firstTextOverflow, secondTextOverflow;
  final TextStyle? firstStyle, secondStyle;
  final double? widthSizeBox;
  final Widget? widget;
  final bool isShowWidget;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
          crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                contentFirst ?? '--',
                style: firstStyle ?? Styles.normalTextBold(size: 16),
                overflow: firstTextOverflow ?? TextOverflow.ellipsis,
                maxLines: maxLines,
              ),
            ),
            SizedBox(
              width: widthSizeBox ?? 0,
            ),
            isShowWidget
                ? Flexible(
                    child: widget ??
                        Text(
                          contentSecond ?? '--',
                          style: secondStyle ??
                              Styles.normalTextW500(
                                      color: ColorName.grey1, size: 16)
                                  .copyWith(
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: ColorName.orange17),
                          overflow: secondTextOverflow ?? TextOverflow.ellipsis,
                        ))
                : SizedBox(),
          ],
        ),
      ],
    );
  }
}
