import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_shop/base/util/utils.dart';
import 'package:project_shop/data/response_models/address/address_model.dart';
import 'package:project_shop/data/response_models/cart/cart_model.dart';
import 'package:project_shop/features/checkout/checkout_controller.dart';
import 'package:project_shop/gen/assets.gen.dart';
import 'package:project_shop/utils/app_field_group.dart';
import 'package:project_shop/utils/app_text_field.dart';
import 'package:project_shop/utils/payment_method.dart';
import 'package:project_shop/widgets/button/normal_button.dart';
import 'package:project_shop/widgets/icon_widget/icon_widget.dart';
import 'package:project_shop/widgets/image_base/base_image_widget.dart';
import 'package:project_shop/widgets/styles_widget/styles_widget.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';

class CheckoutPage extends GetView<CheckoutController> {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xác nhận đơn hàng'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.checkoutItems.isEmpty) {
          return const Center(child: Text('Chưa chọn sản phẩm nào.'));
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
          children: [
            if (controller.selectedAddress.value == null)
              _MissingAddress(
                onAdd: controller.manageAddresses,
                message: controller.addresses.isEmpty
                    ? 'Bạn chưa có địa chỉ giao hàng.'
                    : 'Bạn chưa có địa chỉ mặc định.',
              )
            else
              _DefaultAddress(
                address: controller.selectedAddress.value!,
                onTap: controller.manageAddresses,
              ),
            const SizedBox(height: 20),
            Text('Sản phẩm đã chọn', style: Styles.normalTextW700(size: 16)),
            const SizedBox(height: 10),
            ...controller.checkoutItems
                .map((item) => _CheckoutItem(item: item)),
            const SizedBox(height: 12),
            // TextField(
            //   controller: controller.couponController,
            //   decoration: const InputDecoration(
            //     labelText: 'Ma giam gia',
            //     border: OutlineInputBorder(),
            //   ),
            // ),
            const SizedBox(height: 10),
            AppFieldGroup(
              label: 'Ghi chú',
              child: AppTextField.standard(
                controller: controller.noteController,
                hintText: 'Nhập nội dung ghi chú',
                maxLines: 3,
              ),
            ),
            const SizedBox(height: 18),
            _PaymentMethodSelector(controller: controller),
            const SizedBox(height: 18),
            _PriceSummary(controller: controller),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        if (controller.isLoading.value || controller.checkoutItems.isEmpty) {
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
                    const Text('Tổng thanh toán'),
                    Text(
                      Utils.I.formatCurrency(controller.checkoutTotalPrice),
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
                  title: 'Đặt hàng',
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
}

class _DefaultAddress extends StatelessWidget {
  const _DefaultAddress({
    required this.address,
    required this.onTap,
  });

  final AddressModel address;
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          address.recipientName ?? 'Người nhận',
                          style: Styles.normalTextW700(size: 14),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(address.phone ?? ''),
                      ],
                    ),
                    Text(address.addressLine ?? ''),
                  ],
                ),
              ),
              IconWidget.ic24(path: Assets.icons.icArrowRightNew)
            ],
          ),
        ),
      ),
    );
  }
}

class _MissingAddress extends StatelessWidget {
  const _MissingAddress({
    required this.onAdd,
    required this.message,
  });

  final VoidCallback onAdd;
  final String message;

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
          Text(message),
          TextButton(onPressed: onAdd, child: const Text('Quản lý địa chỉ')),
        ],
      ),
    );
  }
}

class _PaymentMethodSelector extends StatelessWidget {
  const _PaymentMethodSelector({required this.controller});

  final CheckoutController controller;

  @override
  Widget build(BuildContext context) {
    return AppFieldGroup(
      label: 'Phương thức thanh toán',
      child: Obx(
        () => Column(
          children: PaymentMethod.values
              .map(
                (method) => _PaymentMethodItem(
                  method: method,
                  selected: controller.selectedPaymentMethod.value == method,
                  walletBalance: controller.walletBalance.value,
                  onTap: () => controller.selectPaymentMethod(method),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _PaymentMethodItem extends StatelessWidget {
  const _PaymentMethodItem({
    required this.method,
    required this.selected,
    required this.walletBalance,
    required this.onTap,
  });

  final PaymentMethod method;
  final bool selected;
  final double walletBalance;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected ? ColorName.black : ColorName.grey1,
              width: selected ? 1.2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: selected ? ColorName.black : ColorName.grey1,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method.title,
                      style: Styles.normalTextW600(size: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      method == PaymentMethod.wallet
                          ? '${method.description} Số dư: ${Utils.I.formatCurrency(walletBalance)}'
                          : method.description,
                      style: Styles.normalText(
                        size: 12,
                        color: ColorName.grey1,
                      ),
                    ),
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
                  item.productName ?? 'Sản phẩm',
                  style: Styles.normalTextW600(size: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.attributes.isNotEmpty)
                  Text(
                    item.attributes
                        .map((attribute) =>
                            '${attribute.attributeName ?? 'Phân loại'}: ${attribute.attributeValue ?? ''}')
                        .join(', '),
                    style: Styles.normalText(size: 12, color: ColorName.grey1),
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
  const _PriceSummary({required this.controller});

  final CheckoutController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _row('Tạm tính', controller.checkoutSubtotal),
        _row('Giảm giá', controller.cart.value?.discount ?? 0),
        const Divider(height: 18),
        _row('Thanh toán', controller.checkoutTotalPrice, bold: true),
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
