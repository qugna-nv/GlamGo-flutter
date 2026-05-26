import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:project_shop/gen/assets.gen.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';
import 'package:project_shop/utils/constant.dart';
import 'package:project_shop/widgets/common/common_image.dart';
import 'package:project_shop/widgets/styles_widget/styles_widget.dart';

class CommonSnackbar {
  CommonSnackbar._();

  static final I = CommonSnackbar._();

  static GlobalKey<ScaffoldMessengerState> snackBarKey =
      GlobalKey<ScaffoldMessengerState>();

  Color renderColor(ToastStatus toastStatus) {
    switch (toastStatus) {
      case ToastStatus.warning:
        return ColorName.yellow13;
      case ToastStatus.success:
        return ColorName.green16;
      default:
        return ColorName.red16;
    }
  }

  Color renderLeftColor(ToastStatus toastStatus) {
    switch (toastStatus) {
      case ToastStatus.warning:
        return ColorName.orange12;
      case ToastStatus.success:
        return ColorName.green5;
      default:
        return ColorName.red5;
    }
  }

  String renderIcon(ToastStatus toastStatus) {
    switch (toastStatus) {
      case ToastStatus.warning:
        return Assets.icons.icWarningToast;
      case ToastStatus.success:
        return Assets.icons.icSuccessToast;
      default:
        return Assets.icons.icFailToast;
    }
  }

  Color renderContentColor(ToastStatus toastStatus) {
    switch (toastStatus) {
      case ToastStatus.warning:
        return ColorName.yellow12;
      case ToastStatus.success:
        return ColorName.green17;
      default:
        return ColorName.red33;
    }
  }

  Widget _buildToastFrame(
    BuildContext context, {
    required ToastStatus toastStatus,
    required String title,
    required String description,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width,

      //height: 80.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: renderColor(toastStatus),
        border: Border(
          left: BorderSide(
            color: renderLeftColor(toastStatus),
            width: 4,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: ColorName.black.withOpacity(0.1),
            offset: Offset(-4.w, 4.w),
            blurRadius: 4.r,
          )
        ],
      ),
      padding:
          EdgeInsets.only(top: 10.w, bottom: 10.w, left: 10.w, right: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Row(
              children: [
                CommonImage(
                  asset: renderIcon(toastStatus),
                ),
                SizedBox(
                  width: 16.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: Styles.mediumText18W600(
                          color: renderLeftColor(toastStatus),
                        ),
                      ),
                      Text(
                        description,
                        style: Styles.normalText(
                            color: renderContentColor(toastStatus),
                            size: 14.sp),
                        // overflow: TextOverflow.ellipsis,
                        // //maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 16.w,
          ),
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
            child: CommonImage(
              asset: Assets.icons.icClose,
            ),
          ),
        ],
      ),
    );
  }

  void show(
    BuildContext context, {
    required ToastStatus toastStatus,
    required String title,
    required String description,
    int lines = 2,
    double? margin,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    snackBarKey.currentState?.showSnackBar(
      SnackBar(
        content: _buildToastFrame(
          context,
          toastStatus: toastStatus,
          title: title,
          description: description,
        ),
        margin: EdgeInsets.symmetric(vertical: margin ?? 0),
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: Constant.SHOW_SNACK_BAR_DURATION),
        elevation: 0,
      ),
    );
  }

  void showHtml(
    BuildContext context, {
    required ToastStatus toastStatus,
    required String title,
    required String description,
    int lines = 2,
    double? margin,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    snackBarKey.currentState?.showSnackBar(
      SnackBar(
        content: _buildToastFrameHtml(
          context,
          toastStatus: toastStatus,
          title: title,
          description: description,
        ),
        margin: EdgeInsets.symmetric(vertical: margin ?? 0),
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: Constant.SHOW_SNACK_BAR_DURATION),
        elevation: 0,
      ),
    );
  }

  Widget _buildToastFrameHtml(
    BuildContext context, {
    required ToastStatus toastStatus,
    required String title,
    required String description,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width,

      //height: 80.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: renderColor(toastStatus),
        border: Border(
          left: BorderSide(
            color: renderLeftColor(toastStatus),
            width: 4,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: ColorName.black.withOpacity(0.1),
            offset: Offset(-4.w, 4.w),
            blurRadius: 4.r,
          )
        ],
      ),
      padding:
          EdgeInsets.only(top: 10.w, bottom: 10.w, left: 10.w, right: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Row(
              children: [
                CommonImage(
                  asset: renderIcon(toastStatus),
                ),
                SizedBox(
                  width: 16.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: Styles.mediumText18W600(
                          color: renderLeftColor(toastStatus),
                        ),
                      ),
                      HtmlWidget(
                        description,
                        textStyle: Styles.normalText(
                            color: ColorName.primaryLightTextColor,
                            size: 14.sp),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 16.w,
          ),
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
            child: CommonImage(
              asset: Assets.icons.icClose,
            ),
          ),
        ],
      ),
    );
  }
}

enum ToastStatus { success, fail, warning }
