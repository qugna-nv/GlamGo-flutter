import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/root/parse_route.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:project_shop/data/response_models/address/address_model.dart';
import 'package:project_shop/features/address/controllers/address_controller.dart';
import 'package:project_shop/features/address/controllers/address_form_controller.dart';
import 'package:project_shop/features/navigation/widget/enum_type.dart';
import 'package:project_shop/utils/app_field_group.dart';
import 'package:project_shop/utils/app_text_field.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';

class AddressFormPage extends StatelessWidget {
  const AddressFormPage({
    super.key,
    this.address,
  });

  final AddressModel? address;

  @override
  Widget build(BuildContext context) {
    // final formController = Get.put(AddressFormController(address));
    final formController = Get.find<AddressFormController>();
    final controller = Get.find<AddressController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          address == null ? 'Thêm địa chỉ' : 'Sửa thông tin địa chỉ',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Form(
            key: formController.formKey,
            child: Obx(() {
              final selectedProvince = controller.provinces.firstWhereOrNull(
                (item) => item.name == formController.province.value,
              );
              final dropdownDecoration = AppTextField.buildDecoration(
                theme: Theme.of(context),
                fillColor: ColorName.white,
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppFieldGroup(
                    label: 'Loại địa chỉ',
                    child: DropdownButtonFormField<AddressType>(
                      initialValue: formController.addressType.value,
                      isExpanded: true,
                      decoration: dropdownDecoration,
                      items: AddressType.values.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type.label),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        formController.addressType.value = value;
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppFieldGroup(
                    label: 'Tên người nhận',
                    child: AppTextField.standard(
                      controller: formController.recipientController,
                      validator: (value) => formController.requiredField(
                        value,
                        'Vui lòng nhập tên người nhận',
                      ),
                      hintText: 'Tên người nhận',
                    ),
                  ),
                  AppFieldGroup(
                    label: 'Số điện thoại',
                    child: AppTextField.standard(
                      controller: formController.phoneController,
                      validator: (value) => formController.requiredField(
                        value,
                        'Vui lòng nhập số điện thoại',
                      ),
                      hintText: 'Số điện thoại',
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  AppFieldGroup(
                    label: 'Tỉnh / Thành phố',
                    child: DropdownButtonFormField<String>(
                      key: ValueKey(
                        'province-${formController.province.value}',
                      ),
                      initialValue: controller.provinces.any(
                        (item) => item.name == formController.province.value,
                      )
                          ? formController.province.value
                          : null,
                      isExpanded: true,
                      decoration: dropdownDecoration,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value == null
                          ? 'Vui lòng chọn tỉnh / thành phố'
                          : null,
                      items: controller.provinces.map((item) {
                        return DropdownMenuItem(
                          value: item.name,
                          child: Text(item.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        formController.province.value = value;
                        formController.ward.value = null;
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppFieldGroup(
                    label: 'Phường / Xã',
                    child: DropdownButtonFormField<String>(
                      key: ValueKey(
                        'ward-${formController.province.value}-${formController.ward.value}',
                      ),
                      initialValue: selectedProvince?.wards
                                  .contains(formController.ward.value) ==
                              true
                          ? formController.ward.value
                          : null,
                      isExpanded: true,
                      decoration: AppTextField.buildDecoration(
                        theme: Theme.of(context),
                        fillColor: ColorName.white,
                        enabled: selectedProvince != null,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) =>
                          value == null ? 'Vui lòng chọn phường xã' : null,
                      items: (selectedProvince?.wards ?? []).map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: selectedProvince == null
                          ? null
                          : (value) {
                              formController.ward.value = value;
                            },
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppFieldGroup(
                    label: 'Địa chỉ chi tiết',
                    child: AppTextField.standard(
                      controller: formController.detailController,
                      validator: (value) => formController.requiredField(
                        value,
                        'Vui lòng nhập địa chỉ',
                      ),
                      hintText: 'Tên đường, Toà nhà, Số nhà, ...',
                    ),
                  ),
                  if (address == null)
                    SwitchListTile(
                      value: formController.isDefault.value,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Đặt làm địa chỉ mặc định'),
                      onChanged: (value) {
                        formController.isDefault.value = value;
                      },
                    ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: Obx(
                      () => FilledButton(
                        onPressed: controller.isSaving.value
                            ? null
                            : () => formController.save(context),
                        child: controller.isSaving.value
                            ? const SizedBox.square(
                                dimension: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Hoàn thành'),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
