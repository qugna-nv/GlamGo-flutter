import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_shop/base/util/utils.dart';
import 'package:project_shop/data/response_models/cart/cart_model.dart';
import 'package:project_shop/features/cart/cart_controller.dart';
import 'package:project_shop/features/cart/widgets/emty_cart_screen.dart';
import 'package:project_shop/routes/app_routes.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';
import 'package:project_shop/widgets/button/normal_button.dart';
import 'package:project_shop/widgets/image_base/base_image_widget.dart';
import 'package:project_shop/widgets/styles_widget/styles_widget.dart';

class CartPage extends GetView<CartController> {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gio hang'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: controller.getCart,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.isEmpty) {
            return EmptyCartScreen();
          }

          return RefreshIndicator(
            onRefresh: controller.getCart,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
              itemCount: controller.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _CartItem(
                  item: controller.items[index],
                  onMinus: () => controller.updateQuantity(
                    controller.items[index],
                    controller.items[index].quantity - 1,
                  ),
                  onPlus: () => controller.updateQuantity(
                    controller.items[index],
                    controller.items[index].quantity + 1,
                  ),
                  onRemove: () =>
                      controller.removeItem(controller.items[index].id),
                );
              },
            ),
          );
        }),
        bottomNavigationBar: Obx(() {
          final cart = controller.cart.value;
          if (cart == null || controller.isEmpty) {
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _TotalRow(
                  label: 'Tam tinh',
                  value: Utils.I.formatCurrency(cart.subtotal),
                ),
                const SizedBox(height: 6),
                _TotalRow(
                  label: 'Giam gia',
                  value: Utils.I.formatCurrency(cart.discount),
                ),
                const Divider(height: 18),
                _TotalRow(
                  label: 'Thanh toan',
                  value: Utils.I.formatCurrency(cart.totalPrice),
                  isBold: true,
                ),
                const SizedBox(height: 12),
                IButton.primaryNormal(
                  height: 46,
                  title: 'Dat hang',
                  backgroundColor: ColorName.black,
                  textStyle: Styles.normalTextW600(color: ColorName.white),
                  isLoading: false,
                  onPress: () => Get.toNamed(Routes.checkout),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _CartItem extends StatelessWidget {
  const _CartItem({
    required this.item,
    required this.onMinus,
    required this.onPlus,
    required this.onRemove,
  });

  final CartItemModel item;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final image = item.productImage == null || item.productImage!.isEmpty
        ? ''
        : Utils.I.getImageFullPath(item.productImage!);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ColorName.grey53,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseImageWidget(
            path: image,
            widthImage: 84,
            heightImage: 84,
            radius: 8,
            boxFit: BoxFit.cover,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName ?? 'San pham',
                  style: Styles.normalTextW700(size: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(Utils.I.formatCurrency(item.price),
                    style: Styles.normalTextW600(color: ColorName.red14)),
                if ((item.personaliseName ?? '').isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text('Ghi chu: ${item.personaliseName}',
                      style: Styles.normalText(size: 12)),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    _QtyButton(icon: Icons.remove, onTap: onMinus),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('${item.quantity}',
                          style: Styles.normalTextW700(size: 14)),
                    ),
                    _QtyButton(icon: Icons.add, onTap: onPlus),
                    const Spacer(),
                    IconButton(
                      onPressed: onRemove,
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          border: Border.all(color: ColorName.grey1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  final String label;
  final String value;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: isBold ? Styles.normalTextW700() : Styles.normalTextW500()),
        Text(value,
            style: isBold ? Styles.normalTextW700() : Styles.normalTextW500()),
      ],
    );
  }
}
