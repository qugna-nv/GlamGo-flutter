import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:project_shop/features/address/controllers/address_form_controller.dart';
import 'package:project_shop/features/navigation/widget/enum_type.dart';
import 'package:project_shop/utils/app_field_group.dart';

class AddressTypeDropdown extends StatelessWidget {
  const AddressTypeDropdown({
    super.key,
    required this.controller,
  });

  final AddressFormController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppFieldGroup(
        label: 'Loại địa chỉ',
        child: DropdownButtonFormField<AddressType>(
          initialValue: controller.addressType.value,
          isExpanded: true,
          items: AddressType.values.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(type.label),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              controller.changeAddressType(value);
            }
          },
        ),
      ),
    );
  }
}
