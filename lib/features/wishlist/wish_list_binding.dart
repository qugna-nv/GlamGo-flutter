import 'package:get/get.dart';
import 'package:project_shop/features/wishlist/wish_list_controller.dart';

class WishListBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<WishListController>()) {
      Get.lazyPut(() => WishListController());
    }
  }
}
