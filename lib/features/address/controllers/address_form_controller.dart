import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/root/parse_route.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:project_shop/data/response_models/address/address_model.dart';
import 'package:project_shop/features/address/controllers/address_controller.dart';
import 'package:project_shop/features/navigation/widget/enum_type.dart';

class AddressFormController extends GetxController {
  AddressFormController(this.address);

  final AddressModel? address;

  final formKey = GlobalKey<FormState>();

  late final TextEditingController recipientController;
  late final TextEditingController phoneController;
  late final TextEditingController detailController;

  final addressType = AddressType.home.obs;
  final province = RxnString();
  final ward = RxnString();
  final isDefault = false.obs;

  AddressController get addressController => Get.find<AddressController>();

  @override
  void onInit() {
    super.onInit();

    addressType.value = AddressType.values.firstWhereOrNull(
          (type) => type.label == address?.label,
        ) ??
        AddressType.other;

    recipientController = TextEditingController(
      text: address?.recipientName,
    );
    phoneController = TextEditingController(
      text: address?.phone,
    );
    detailController = TextEditingController(
      text: address?.addressLine,
    );

    province.value = address?.province;
    ward.value = address?.ward;
    isDefault.value = address?.isDefault ?? false;
  }

  @override
  void onClose() {
    recipientController.dispose();
    phoneController.dispose();
    detailController.dispose();
    super.onClose();
  }

  void changeAddressType(AddressType value) {
    addressType.value = value;
  }

  void changeProvince(String? value) {
    province.value = value;
    ward.value = null;
  }

  void changeWard(String? value) {
    ward.value = value;
  }

  void changeDefault(bool value) {
    isDefault.value = value;
  }

  String? requiredField(String? value, String message) {
    return value == null || value.trim().isEmpty ? message : null;
  }

  Future<void> save(BuildContext context) async {
    if (formKey.currentState?.validate() != true) return;

    final detail = detailController.text.trim();

    final addressLine = [
      detail,
      ward.value!,
      province.value!,
    ].where((part) => !detail.contains(part)).fold<String>(
          detail,
          (result, part) => '$result, $part',
        );

    final saved = await addressController.saveAddress(
      address: address,
      body: {
        'label': addressType.value.label,
        'recipient_name': recipientController.text.trim(),
        'phone': phoneController.text.trim(),
        'address_line': addressLine,
        'ward': ward.value,
        'province': province.value,
        'country': 'Vietnam',
        if (address == null) 'is_default': isDefault.value,
      },
    );

    if (saved) {
      Navigator.pop(context);
    }
  }
}
