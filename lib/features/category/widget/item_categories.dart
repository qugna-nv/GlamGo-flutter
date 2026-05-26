import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';
import 'package:project_shop/widgets/styles_widget/styles_widget.dart';

class ItemCategories extends StatelessWidget {
  const ItemCategories({
    super.key,
    this.onTap,
    this.categoryName,
    this.selectedColor,
    this.unSelectedColor,
    this.marin,
    this.padding,
    this.radius,
    this.textSize,
    this.selectedIndex = 0,
    this.index = 0,
  });

  final VoidCallback? onTap;
  final String? categoryName;
  final Color? selectedColor, unSelectedColor;
  final int selectedIndex, index;
  final EdgeInsets? marin, padding;
  final double? radius, textSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? EdgeInsets.symmetric(horizontal: 12),
        margin: marin ?? EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: selectedIndex == index
              ? selectedColor ?? ColorName.black
              : unSelectedColor ?? ColorName.white,
          border: Border.all(color: ColorName.grey53),
          borderRadius: BorderRadius.circular(radius ?? 50),
        ),
        child: Center(
          child: Text(
            categoryName ?? 'N/A',
            style: Styles.normalTextW500(
              color: selectedIndex == index ? ColorName.white : ColorName.black,
              size: textSize ?? 14.sp,
            ),
          ),
        ),
      ),
    );
  }
}
