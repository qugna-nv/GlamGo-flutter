// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String label;

//   const CustomAppBar({
//     super.key,
//     this.label = '',
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       bottom: false,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             InkWell(
//               onTap: () {
//                 Get.back();
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(''),
//               ),
//             ),
//             Text(
//               label,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 height: 1.44,
//               ),
//             ),
//             SizedBox(
//               width: 24,
//               height: 24,
//             )
//           ],
//         ),
//       ),
//     );
//   }
//     @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_shop/gen/assets.gen.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';
import 'package:project_shop/widgets/icon_widget/icon_widget.dart';
import 'package:project_shop/widgets/styles_widget/styles_widget.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String label;
  final bool showBackButton;
  final Widget? action;
  final bool centerTitle;
  final double height;
  final TextStyle? textStyle;

  const CustomAppBar({
    super.key,
    this.label = '',
    this.showBackButton = true,
    this.action,
    this.centerTitle = true,
    this.height = 56.0,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: ColorName.grey16,
      ),
      child: Row(
        children: [
          showBackButton
              ? GestureDetector(
                  onTap: () => Get.back(),
                  child: IconWidget.ic24(path: Assets.icons.icLeftArrow))
              : const SizedBox(width: 24),
          centerTitle
              ? Expanded(
                  child: Text(label,
                      textAlign: TextAlign.center,
                      style: textStyle ??
                          Styles.normalTextW600(
                              size: 16, color: ColorName.black)),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
          if (action != null) action!,
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
