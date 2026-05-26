import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_shop/data/response_models/address/address_model.dart';
import 'package:project_shop/features/address/address_controller.dart';

class AddressPage extends GetView<AddressController> {
  const AddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dia chi giao hang'),
        actions: [
          IconButton(
            onPressed: controller.loadData,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.add),
        label: const Text('Them dia chi'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.addresses.isEmpty) {
          return const Center(
            child: Text('Ban chua co dia chi giao hang.'),
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
              return _AddressCard(
                address: address,
                onEdit: () => _openForm(context, address: address),
                onSetDefault: () => controller.setDefault(address),
                onDelete: () => _confirmDelete(context, address),
              );
            },
          ),
        );
      }),
    );
  }

  Future<void> _openForm(BuildContext context, {AddressModel? address}) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => AddressFormSheet(
        controller: controller,
        address: address,
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, AddressModel address) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xoa dia chi?'),
        content: const Text('Dia chi nay se bi xoa khoi tai khoan cua ban.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Huy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xoa'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await controller.deleteAddress(address);
    }
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.address,
    required this.onEdit,
    required this.onSetDefault,
    required this.onDelete,
  });

  final AddressModel address;
  final VoidCallback onEdit;
  final VoidCallback onSetDefault;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    address.label?.isNotEmpty == true
                        ? address.label!
                        : 'Dia chi',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                if (address.isDefault) const Chip(label: Text('Mac dinh')),
              ],
            ),
            Text(address.recipientName ?? ''),
            Text(address.phone ?? ''),
            const SizedBox(height: 4),
            Text(address.addressLine ?? ''),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!address.isDefault)
                  TextButton(
                    onPressed: onSetDefault,
                    child: const Text('Dat mac dinh'),
                  ),
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AddressFormSheet extends StatefulWidget {
  const AddressFormSheet({
    super.key,
    required this.controller,
    this.address,
  });

  final AddressController controller;
  final AddressModel? address;

  @override
  State<AddressFormSheet> createState() => _AddressFormSheetState();
}

class _AddressFormSheetState extends State<AddressFormSheet> {
  late final TextEditingController labelController;
  late final TextEditingController recipientController;
  late final TextEditingController phoneController;
  late final TextEditingController detailController;
  String? province;
  String? ward;
  bool isDefault = false;

  @override
  void initState() {
    super.initState();
    final address = widget.address;
    labelController = TextEditingController(text: address?.label);
    recipientController = TextEditingController(text: address?.recipientName);
    phoneController = TextEditingController(text: address?.phone);
    detailController = TextEditingController(text: address?.addressLine);
    province = address?.province;
    ward = address?.ward;
    isDefault = address?.isDefault ?? false;
  }

  @override
  void dispose() {
    labelController.dispose();
    recipientController.dispose();
    phoneController.dispose();
    detailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedProvince = widget.controller.provinces
        .firstWhereOrNull((item) => item.name == province);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.address == null ? 'Them dia chi' : 'Sua dia chi',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _input(labelController, 'Nhan dia chi (Nha, Cong ty)'),
            _input(recipientController, 'Ten nguoi nhan'),
            _input(phoneController, 'So dien thoai',
                keyboardType: TextInputType.phone),
            DropdownButtonFormField<String>(
              key: ValueKey('province-$province'),
              initialValue: widget.controller.provinces
                      .any((item) => item.name == province)
                  ? province
                  : null,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Tinh / Thanh pho'),
              items: widget.controller.provinces
                  .map((item) => DropdownMenuItem(
                        value: item.name,
                        child: Text(item.name),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  province = value;
                  ward = null;
                });
              },
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              key: ValueKey('ward-$province-$ward'),
              initialValue:
                  selectedProvince?.wards.contains(ward) == true ? ward : null,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Phuong / Xa'),
              items: (selectedProvince?.wards ?? [])
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      ))
                  .toList(),
              onChanged: selectedProvince == null
                  ? null
                  : (value) => setState(() => ward = value),
            ),
            const SizedBox(height: 8),
            _input(detailController, 'So nha, ten duong / dia chi chi tiet'),
            if (widget.address == null)
              SwitchListTile(
                value: isDefault,
                contentPadding: EdgeInsets.zero,
                title: const Text('Dat lam dia chi mac dinh'),
                onChanged: (value) => setState(() => isDefault = value),
              ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: Obx(() => FilledButton(
                    onPressed: widget.controller.isSaving.value ? null : _save,
                    child: widget.controller.isSaving.value
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Luu dia chi'),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _input(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  Future<void> _save() async {
    final recipient = recipientController.text.trim();
    final phone = phoneController.text.trim();
    final detail = detailController.text.trim();

    if (recipient.isEmpty ||
        phone.isEmpty ||
        detail.isEmpty ||
        province == null ||
        ward == null) {
      Get.snackbar('Dia chi', 'Vui long nhap day du thong tin dia chi.');
      return;
    }

    final addressLine = [detail, ward!, province!]
        .where((part) => !detail.contains(part))
        .fold<String>(detail, (result, part) => '$result, $part');

    final saved = await widget.controller.saveAddress(
      address: widget.address,
      body: {
        'label': labelController.text.trim(),
        'recipient_name': recipient,
        'phone': phone,
        'address_line': addressLine,
        'ward': ward,
        'province': province,
        'country': 'Vietnam',
        if (widget.address == null) 'is_default': isDefault,
      },
    );

    if (saved && mounted) {
      Navigator.pop(context);
    }
  }
}
