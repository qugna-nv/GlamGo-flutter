import 'package:get/get.dart';
import 'package:project_shop/data/response_models/address/address_model.dart';
import 'package:project_shop/features/address/controllers/address_controller.dart';
import 'package:project_shop/features/address/controllers/address_form_controller.dart';

class AddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddressController());
    Get.lazyPut(() => AddressFormController(
          Get.arguments is AddressModel ? Get.arguments : null,
        ));
  }
}
