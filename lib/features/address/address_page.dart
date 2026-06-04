import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_shop/features/address/address_page_args.dart';
import 'package:project_shop/data/response_models/address/address_model.dart';
import 'package:project_shop/features/address/controllers/address_controller.dart';
import 'package:project_shop/features/address/widgets/address_card_item.dart';
import 'package:project_shop/routes/app_routes.dart';

class AddressPage extends GetView<AddressController> {
  const AddressPage({super.key});

  bool get _returnOnDefaultSelected {
    final arguments = Get.arguments;
    return arguments is AddressPageArgs && arguments.returnOnDefaultSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Địa chỉ giao hàng'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Thêm địa chỉ'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.addresses.isEmpty) {
          return const Center(
            child: Text('Ban chưa có địa chỉ giao hàng.'),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadData,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
            itemCount: controller.addresses.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, index) {
              final address = controller.addresses[index];
              return AddressCardItem(
                address: address,
                onEdit: () => _openForm(address: address),
                onSetDefault: () => _setDefault(address),
                onDelete: () => _confirmDelete(context, address),
              );
            },
          ),
        );
      }),
    );
  }

  Future<void> _openForm({AddressModel? address}) async {
    await Get.toNamed(Routes.addressForm, arguments: address);
  }

  Future<void> _setDefault(AddressModel address) async {
    final saved = await controller.setDefault(address);
    if (saved && _returnOnDefaultSelected) {
      Get.back(result: address);
    }
  }

  Future<void> _confirmDelete(
      BuildContext context, AddressModel address) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xoá địa chỉ?'),
        content: const Text('Địa chỉ này sẽ bị xoá khỏi tài khoản của bạn.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Huỷ'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xoá'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await controller.deleteAddress(address);
    }
  }
}
