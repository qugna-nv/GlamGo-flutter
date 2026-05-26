import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_shop/base/base_controller.dart';
import 'package:project_shop/data/secure_storage/share_preference_manager.dart';
import 'package:project_shop/routes/app_routes.dart';
import 'package:project_shop/utils/constant.dart';

class OnboardingController extends BaseController {
  final RxInt initialIndex = 0.obs;
  late final PageController pageController;

  RxBool get isLastPage => (initialIndex.value == 2).obs;

  final SharedPreferencesManager sharedPreferencesManager = Get.find();

  @override
  void onInit() {
    pageController = PageController(initialPage: initialIndex.value);
    super.onInit();
  }

  void onChangePage(int index) {
    initialIndex.value = index;
  }

  void nextPage() {
    if (initialIndex.value < 2) {
      initialIndex.value++;
      pageController.animateToPage(
        initialIndex.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void getStarted() {
    if (isLastPage.value) {
      sharedPreferencesManager.putBool(
          Constant.KEY_FIRST_SHOW_ONBOARDING, false);
      Get.offAllNamed(Routes.initPage);
    } else {
      nextPage();
    }
  }

  void skipPage() {
    if (initialIndex.value == 2) {
    } else {
      initialIndex.value = 2;
      pageController.animateToPage(
        2,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }
}
