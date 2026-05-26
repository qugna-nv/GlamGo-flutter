import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:project_shop/gen/assets.gen.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';
import 'package:project_shop/utils/extension/getx_ex.dart';
import 'package:project_shop/widgets/common/toast_widget.dart';
import 'package:project_shop/widgets/icon_widget/icon_widget.dart';
import 'package:project_shop/widgets/styles_widget/styles_widget.dart';

const double appBarHeight = 44.0;

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({
    super.key,
    this.title,
    this.child,
    this.actions,
    this.onBack,
    this.leadingWidth,
    this.titleSpacing,
    this.centerTitle = true,
    this.leadingIcon,
    this.leading,
    this.titleStyle,
    this.isClose,
    this.onClose,
    this.automaticallyImplyLeading = true,
    this.flexibleSpace,
    this.elevation,
    this.backgroundColor,
    this.shadowColor,
    this.bottom,
  });

  final String? title;
  final Widget? child;
  final List<Widget>? actions;
  final VoidCallback? onBack;
  final double? leadingWidth;
  final double? titleSpacing;
  final bool centerTitle;
  final String? leadingIcon;
  final Widget? leading;
  final TextStyle? titleStyle;

  final bool? isClose;
  final VoidCallback? onClose;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final Widget? flexibleSpace;
  final double? elevation;
  final Color? shadowColor;
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize => const Size.fromHeight(appBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      bottom: bottom,
      backgroundColor: backgroundColor ?? Colors.white,
      centerTitle: centerTitle,
      leading: _buildLeadingWidget(context),
      elevation: elevation ?? 0,
      flexibleSpace: flexibleSpace,
      leadingWidth: leadingWidth,
      titleSpacing: titleSpacing,
      shadowColor: shadowColor ?? Colors.transparent,
      automaticallyImplyLeading: automaticallyImplyLeading,
      // systemOverlayStyle: const SystemUiOverlayStyle(
      //   statusBarIconBrightness: Brightness.light, // For Android (dark icons)
      //   statusBarBrightness: Brightness.light, // For iOS (dark icons)
      // ),
      title: child ??
          Text(
            title?.toUpperCase() ?? '',
            style: titleStyle ??
                Styles.mediumText18W700(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
      actions: actions,
    );
  }

  Widget? _buildLeadingWidget(BuildContext context) {
    if (!automaticallyImplyLeading) {
      return null;
    }
    if (leading != null) {
      return leading;
    }
    if (isClose == true) {
      return IconButton(
          icon: IconWidget.ic24(path: leadingIcon ?? Assets.icons.icClose),
          onPressed: () {
            onClose?.call();
          });
    }
    return IconButton(
        icon: IconWidget.ic24(path: leadingIcon ?? Assets.icons.icLeftArrow),
        onPressed: onBack != null
            ? onBack!
            : () {
                if (Get.safeFind<ToastWidget>()?.showing == true) {
                  Get.safeFind<ToastWidget>()?.removeAllQueuedToasts();
                  // Future.delayed(Duration(milliseconds: 50));
                }
                // if (Get.isSnackbarOpen) {
                //   Get.back(closeOverlays: true);
                // }
                Navigator.maybePop(context);
              });
  }
}

// class FlexibleAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final Key parentKey;
//   final Widget flexChild;
//   final String title;
//   final bool showBack;
//   final Function? onPressBack;

//   const FlexibleAppBar({
//     super.key,
//     required this.parentKey,
//     required this.flexChild,
//     this.title = "",
//     this.showBack = false,
//     this.onPressBack,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return PreferredSize(
//       preferredSize: Size.fromHeight(62.w),
//       child: Container(
//         padding: EdgeInsets.only(
//             top: ScreenUtil().statusBarHeight, left: 16.w, right: 16.w),
//         height: 62.w + ScreenUtil().statusBarHeight,
//         width: ScreenUtil().screenWidth,
//         color: ColorName.white,
//         child: Stack(
//           alignment: Alignment.centerLeft,
//           fit: StackFit.expand,
//           key: parentKey,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                     width: 40.w,
//                     height: 40.w,
//                     alignment: Alignment.centerLeft,
//                     child: FittedBox(
//                         fit: BoxFit.none,
//                         child: showBack
//                             ? IconButton(
//                                 onPressed: () {
//                                   Navigator.maybePop(context ?? Get.context!);
//                                   if (onPressBack != null) {
//                                     onPressBack!();
//                                   }
//                                 },
//                                 icon: SvgPicture.asset(
//                                   Assets.icons.icBackArrow,
//                                   color: ColorName.black,
//                                 ))
//                             : IconButton(
//                                 onPressed: () {
//                                   // showAccountInformationDialog();
//                                   // Get.toNamed(Routes.settingAccount);
//                                 },
//                                 icon: GlobalInfo()
//                                             .userInfo
//                                             ?.strCardNumber
//                                             ?.isNotEmpty ==
//                                         true
//                                     ? BaseAvatar(
//                                         src:
//                                             "${Get.safeFind<Network>()?.domain.apiUrl}/${Files.downloadStaffImage}/${GlobalInfo().userInfo?.strCardNumber}/${Constant.IMAGE_SIZE_ORIGIN}",
//                                         size: 32.w,
//                                       )
//                                     : Assets.icons.icAvatar2
//                                         .image(width: 32.w, height: 32.w)))),
//                 Text(
//                   title.toUpperCase(),
//                   style: Styles.bigTextW700(
//                       color: Theme.of(context).colorScheme.onPrimary),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(
//                   width: 40.w,
//                   height: 40.w,
//                 ),
//               ],
//             ),
//             flexChild,
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Size get preferredSize => Size.fromHeight(62.w);
// }
