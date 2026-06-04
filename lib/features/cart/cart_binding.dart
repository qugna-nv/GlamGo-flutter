import 'package:get/get.dart';
import 'package:project_shop/features/cart/cart_controller.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CartController>()) {
      Get.lazyPut(() => CartController(), fenix: true);
    }
  }
}
