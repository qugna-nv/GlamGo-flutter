import 'package:get/get.dart';
import 'package:project_shop/features/checkout/checkout_controller.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CheckoutController());
  }
}
