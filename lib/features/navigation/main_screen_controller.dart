import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:project_shop/base/base_controller.dart';
import 'package:project_shop/features/account/account_controller.dart';
import 'package:project_shop/features/navigation/widget/enum_type.dart';

class MainScreenController extends BaseController {
  final RxInt initialIndex = 0.obs;
  final Rx<MainScreenEnum> currentPage = MainScreenEnum.home.obs;
  late final PageController pageController;

  final _isFloatingBar = false.obs;
  bool get isFloatingBar => _isFloatingBar.value;

  @override
  void onInit() {
    pageController = PageController(initialPage: currentPage.value.index);
    super.onInit();
  }

  void onTabChanged(int index) {
    if (index >= 0 && index < MainScreenEnum.values.length) {
      currentPage.value = MainScreenEnum.values[index];
      pageController.jumpToPage(index);
      if (currentPage.value == MainScreenEnum.account &&
          Get.isRegistered<AccountController>()) {
        Get.find<AccountController>().loadCurrentUser();
      }
    }
  }
}
