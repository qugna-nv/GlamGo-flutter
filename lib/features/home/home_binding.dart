import 'package:get/get.dart';
import 'package:project_shop/features/cart/cart_controller.dart';
import 'package:project_shop/features/home/home_controller.dart';
import 'package:project_shop/features/notification/notification_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CartController>()) {
      Get.lazyPut(() => CartController(), fenix: true);
    }
    if (!Get.isRegistered<NotificationController>()) {
      Get.lazyPut(() => NotificationController(), fenix: true);
    }
    Get.lazyPut(() => HomeController());
    // Get.lazyPut(()=>)
  }
}
