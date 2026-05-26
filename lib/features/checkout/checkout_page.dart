import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_shop/base/util/utils.dart';
import 'package:project_shop/data/response_models/address/address_model.dart';
import 'package:project_shop/data/response_models/cart/cart_model.dart';
import 'package:project_shop/features/checkout/checkout_controller.dart';
import 'package:project_shop/widgets/button/normal_button.dart';
import 'package:project_shop/widgets/image_base/base_image_widget.dart';
import 'package:project_shop/widgets/styles_widget/styles_widget.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';

class CheckoutPage extends GetView<CheckoutController> {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xac nhan don hang'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final cart = controller.cart.value;
        if (cart == null || cart.items.isEmpty) {
          return const Center(child: Text('Gio hang dang trong.'));
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
          children: [
            _titleRow(
              title: 'Dia chi nhan hang',
              actionText: 'Quan ly',
              onTap: controller.manageAddresses,
            ),
            const SizedBox(height: 10),
            if (controller.addresses.isEmpty)
              _MissingAddress(onAdd: controller.manageAddresses)
            else
              ...controller.addresses.map(
                (address) => Obx(() => _SelectableAddress(
                      address: address,
                      selected:
                          controller.selectedAddress.value?.id == address.id,
                      onTap: () => controller.selectAddress(address),
                    )),
              ),
            const SizedBox(height: 20),
            Text('San pham', style: Styles.normalTextW700(size: 16)),
            const SizedBox(height: 10),
            ...cart.items.map((item) => _CheckoutItem(item: item)),
            const SizedBox(height: 12),
            TextField(
              controller: controller.couponController,
              decoration: const InputDecoration(
                labelText: 'Ma giam gia',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller.noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Ghi chu cho don hang',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 18),
            _PriceSummary(cart: cart),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        final cart = controller.cart.value;
        if (controller.isLoading.value || cart == null || cart.items.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: BoxDecoration(
            color: ColorName.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tong thanh toan'),
                    Text(
                      Utils.I.formatCurrency(cart.totalPrice),
                      style: Styles.normalTextW700(
                          size: 16, color: ColorName.red14),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 172,
                child: IButton.primaryNormal(
                  height: 46,
                  title: 'Dat hang',
                  backgroundColor: ColorName.black,
                  textStyle: Styles.normalTextW600(color: ColorName.white),
                  isLoading: controller.submitting.value,
                  onPress: controller.submitOrder,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _titleRow({
    required String title,
    required String actionText,
    required VoidCallback onTap,
  }) {
    return Row(
      children: [
        Expanded(child: Text(title, style: Styles.normalTextW700(size: 16))),
        TextButton(onPressed: onTap, child: Text(actionText)),
      ],
    );
  }
}

class _SelectableAddress extends StatelessWidget {
  const _SelectableAddress({
    required this.address,
    required this.selected,
    required this.onTap,
  });

  final AddressModel address;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12, top: 2),
                child: Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: selected ? ColorName.black : ColorName.grey1,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            address.recipientName ?? 'Nguoi nhan',
                            style: Styles.normalTextW700(size: 14),
                          ),
                        ),
                        if (address.isDefault)
                          const Text(
                            'Mac dinh',
                            style: TextStyle(color: Colors.green),
                          ),
                      ],
                    ),
                    Text(address.phone ?? ''),
                    Text(address.addressLine ?? ''),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MissingAddress extends StatelessWidget {
  const _MissingAddress({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: ColorName.grey1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          const Text('Ban chua co dia chi giao hang.'),
          TextButton(onPressed: onAdd, child: const Text('Them dia chi')),
        ],
      ),
    );
  }
}

class _CheckoutItem extends StatelessWidget {
  const _CheckoutItem({required this.item});

  final CartItemModel item;

  @override
  Widget build(BuildContext context) {
    final image = item.productImage == null || item.productImage!.isEmpty
        ? ''
        : Utils.I.getImageFullPath(item.productImage!);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          BaseImageWidget(
            path: image,
            widthImage: 64,
            heightImage: 64,
            radius: 8,
            boxFit: BoxFit.cover,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName ?? 'San pham',
                  style: Styles.normalTextW600(size: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text('x${item.quantity}'),
                Text(
                  Utils.I.formatCurrency(item.totalPrice),
                  style: Styles.normalTextW600(color: ColorName.red14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceSummary extends StatelessWidget {
  const _PriceSummary({required this.cart});

  final CartModel cart;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _row('Tam tinh', cart.subtotal),
        _row('Giam gia', cart.discount),
        const Divider(height: 18),
        _row('Thanh toan', cart.totalPrice, bold: true),
      ],
    );
  }

  Widget _row(String label, double amount, {bool bold = false}) {
    final style = bold ? Styles.normalTextW700() : Styles.normalTextW500();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(Utils.I.formatCurrency(amount), style: style),
        ],
      ),
    );
  }
}
