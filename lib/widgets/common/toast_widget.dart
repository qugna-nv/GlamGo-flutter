import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';
import 'package:project_shop/widgets/appbar_custom/common_snackbar.dart';
import 'package:project_shop/widgets/common/common_image.dart';
import 'package:project_shop/widgets/inkwell/default_ink_well.dart';
import 'package:project_shop/widgets/styles_widget/styles_widget.dart';

import '../../gen/assets.gen.dart';

class ToastWidget {
  FToast fToast = FToast();
  Fluttertoast fluttertoast = Fluttertoast();
  bool showing = false;

  ToastWidget();

  registerContext() {
    fToast.init(Get.key.currentState!.context);
  }

  showToast(
    BuildContext context, {
    required ToastStatus toastStatus,
    String? title,
    required String description,
    ToastGravity? toastGravity,
    int? duration,
    double? margin,
    bool isUnfocusKeyboard = true,
    // Widget Function(BuildContext, Widget)? positionedToastBuilder,
    PositionedToastBuilder? positionedToastBuilder,
  }) {
    if (showing) return;
    showing = true;
    //remove duplicate Toast showing
    removeToast();

    final isKeyboardShow = MediaQuery.of(context).viewInsets.bottom > 0;

    final safePadding = MediaQuery.of(context).padding.top;

    int delayTime = 0;

    if (isKeyboardShow) {
      delayTime = 700;
    }

    if (isUnfocusKeyboard) {
      FocusScope.of(context).unfocus();
    }

    Future.delayed(
      delayTime == 0 ? Duration.zero : Duration(milliseconds: delayTime),
      () async {
        fToast.showToast(
            child: _buildToastFrame(
              context,
              toastStatus: toastStatus,
              title: title,
              description: description,
              margin: margin ?? safePadding,
            ),
            gravity: toastGravity ?? (ToastGravity.BOTTOM),
            toastDuration: Duration(seconds: duration ?? 3),
            positionedToastBuilder: positionedToastBuilder,
            isDismissible: true);
        await Future.delayed(Duration(seconds: duration ?? 3), () {
          showing = false;
        });
      },
    );
  }

  showToastHtml(
    BuildContext context, {
    required ToastStatus toastStatus,
    required String title,
    required String description,
    ToastGravity? toastGravity,
    int? duration,
    double? margin,
    bool isUnfocusKeyboard = true,
    // Widget Function(BuildContext, Widget)? positionedToastBuilder,
    PositionedToastBuilder? positionedToastBuilder,
  }) {
    if (showing) return;
    showing = true;
    //remove duplicate Toast showing
    removeToast();

    final isKeyboardShow = MediaQuery.of(context).viewInsets.bottom > 0;

    final safePadding = MediaQuery.of(context).padding.top;

    int delayTime = 0;

    if (isKeyboardShow) {
      delayTime = 700;
    }

    if (isUnfocusKeyboard) {
      FocusScope.of(context).unfocus();
    }

    Future.delayed(
      delayTime == 0 ? Duration.zero : Duration(milliseconds: delayTime),
      () async {
        fToast.showToast(
            child: _buildToastFrameHtml(
              context,
              toastStatus: toastStatus,
              title: title,
              description: description,
              margin: margin ?? safePadding,
            ),
            gravity: toastGravity ?? (ToastGravity.BOTTOM),
            toastDuration: Duration(seconds: duration ?? 3),
            positionedToastBuilder: positionedToastBuilder,
            isDismissible: true);
        await Future.delayed(Duration(seconds: duration ?? 3), () {
          showing = false;
        });
      },
    );
  }

  showMessageToast({
    required String message,
    required ToastStatus toastStatus,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: renderColorMessage(toastStatus),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Color renderColorMessage(ToastStatus toastStatus) {
    switch (toastStatus) {
      case ToastStatus.warning:
        return ColorName.orange14;
      case ToastStatus.success:
        return ColorName.green19;
      default:
        return ColorName.red14;
    }
  }

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
        return ColorName.orange14;
      case ToastStatus.success:
        return ColorName.green19;
      default:
        return ColorName.red2;
    }
  }

  Color renderContentColor(ToastStatus toastStatus) {
    switch (toastStatus) {
      case ToastStatus.warning:
        return ColorName.yellow12;
      case ToastStatus.success:
        return ColorName.green17;
      default:
        // return ColorName.red5;
        return ColorName.red33;
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

  Widget _buildCustomToast(
    BuildContext context, {
    required String icon,
    required Widget content,
    required Color backgroundColor,
    double? margin,
  }) {
    return Container(
      width: Get.width,
      margin: EdgeInsets.only(bottom: margin ?? 30),
      // height: 80.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: backgroundColor,
        // border: Border(
        //   left: BorderSide(
        //     color: renderLeftColor(toastStatus),
        //     width: 4,
        //   ),
        // ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonImage(
                  asset: icon,
                ),
                SizedBox(
                  width: 16.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [content],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 16.w,
          ),
          DefaultInkWell(
            onTap: () {
              fToast.removeCustomToast();
              showing = false;
            },
            child: CommonImage(
              asset: Assets.icons.icClose,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToastFrame(
    BuildContext context, {
    required ToastStatus toastStatus,
    String? title,
    required String description,
    double? margin,
  }) {
    return Container(
      width: Get.width,
      margin: EdgeInsets.only(bottom: margin ?? 30),
      // height: 80.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: renderColor(toastStatus),
        // border: Border(
        //   left: BorderSide(
        //     color: renderLeftColor(toastStatus),
        //     width: 4,
        //   ),
        // ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          CommonImage(
            asset: renderIcon(toastStatus),
          ),
          SizedBox(
            width: 16.w,
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      title != null
                          ? Text(
                              title,
                              style: Styles.mediumText18W600(
                                color: renderLeftColor(toastStatus),
                              ),
                            )
                          : const SizedBox(),
                      Flexible(
                        child: Text(
                          description,
                          style: Styles.normalText(
                              color: renderContentColor(toastStatus),
                              size: 14.sp),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                        ),
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
          DefaultInkWell(
            onTap: () {
              fToast.removeCustomToast();
              showing = false;
            },
            child: CommonImage(
              asset: Assets.icons.icClose,
              width: 24.w,
              height: 24.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToastFrameHtml(
    BuildContext context, {
    required ToastStatus toastStatus,
    required String title,
    required String description,
    double? margin,
  }) {
    return Container(
      width: Get.width,
      margin: EdgeInsets.only(bottom: margin ?? 30),
      // height: 80.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: renderColor(toastStatus),
        // border: Border(
        //   left: BorderSide(
        //     color: renderLeftColor(toastStatus),
        //     width: 4,
        //   ),
        // ),
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
                      Flexible(
                        child: HtmlWidget(
                          description,
                          textStyle: Styles.normalText(
                              color: renderContentColor(toastStatus),
                              size: 14.sp),
                        ),
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
          DefaultInkWell(
            onTap: () {
              fToast.removeCustomToast();
              showing = false;
            },
            child: CommonImage(
              asset: Assets.icons.icClose,
            ),
          ),
        ],
      ),
    );
  }

  showCustomToast(
    BuildContext context, {
    required String icon,
    required Widget content,
    ToastGravity? toastGravity,
    required Color backgroundColor,
    int? duration,
    double? margin,
    bool isUnfocusKeyboard = true,
    bool? isDismissible,
    // Widget Function(BuildContext, Widget)? positionedToastBuilder,
    PositionedToastBuilder? positionedToastBuilder,
  }) {
    if (showing) return;
    showing = true;
    //remove duplicate Toast showing
    removeToast();

    final isKeyboardShow = MediaQuery.of(context).viewInsets.bottom > 0;

    final safePadding = MediaQuery.of(context).padding.top;

    int delayTime = 0;

    if (isKeyboardShow) {
      delayTime = 700;
    }

    if (isUnfocusKeyboard) {
      FocusScope.of(context).unfocus();
    }

    Future.delayed(
      delayTime == 0 ? Duration.zero : Duration(milliseconds: delayTime),
      () async {
        fToast.showToast(
            child: _buildCustomToast(
              context,
              icon: icon,
              content: content,
              backgroundColor: backgroundColor,
              margin: margin ?? safePadding,
            ),
            gravity: toastGravity ?? ToastGravity.BOTTOM,
            toastDuration: Duration(seconds: duration ?? 3),
            positionedToastBuilder: positionedToastBuilder,
            isDismissible: isDismissible ?? true);
        await Future.delayed(Duration(seconds: duration ?? 3), () {
          showing = false;
        });
      },
    );
  }

  // To remove present shwoing toast
  removeToast() {
    fToast.removeCustomToast();
    showing = false;
  }

// To clear the queue

  removeAllQueuedToasts() {
    fToast.removeQueuedCustomToasts();
    showing = false;
  }
}
