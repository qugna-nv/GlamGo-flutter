import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_shop/base/app_exception.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';
import 'package:project_shop/widgets/styles_widget/styles_widget.dart';

class BaseController extends GetxController {
  final RxBool isLoading = false.obs;
  final Rx<AppException?> appException = Rx<AppException?>(null);

  @override
  void onInit() {
    ever(appException, (AppException? exception) {
      // Get.snackbar('Error', exception?.message ?? '');
      if (exception != null) {
        Get.snackbar(
          'Error',
          '',
          messageText: Text(exception.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Styles.normalTextW500(color: ColorName.black)),
          colorText: ColorName.black,
          duration: Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
        );
      }
    });
    super.onInit();
  }
}
