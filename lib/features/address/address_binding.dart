import 'package:get/get.dart';
import 'package:project_shop/features/address/address_controller.dart';

class AddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddressController());
  }
}
