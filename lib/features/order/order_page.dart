import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_shop/base/util/utils.dart';
import 'package:project_shop/data/response_models/orders/order_model.dart';
import 'package:project_shop/features/order/order_controller.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';
import 'package:project_shop/widgets/image_base/base_image_widget.dart';
import 'package:project_shop/widgets/styles_widget/styles_widget.dart';

class OrderPage extends GetView<OrderController> {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Don hang'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: controller.getOrders,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.orders.isEmpty) {
            return const Center(child: Text('Chua co don hang'));
          }

          return RefreshIndicator(
            onRefresh: controller.getOrders,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: controller.orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = controller.orders[index];
                return _OrderCard(
                  order: order,
                  statusText: controller.statusText(order.status),
                  paymentText:
                      controller.paymentStatusText(order.paymentStatus),
                  onTap: () => _showDetail(context, order.id),
                );
              },
            ),
          );
        }),
      ),
    );
  }

  void _showDetail(BuildContext context, int id) {
    controller.getOrderDetail(id);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return SafeArea(
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.8,
            minChildSize: 0.45,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Obx(() {
                if (controller.detailLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final order = controller.selectedOrder.value;
                if (order == null) {
                  return const Center(child: Text('Khong co du lieu'));
                }

                return ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(order.code ?? 'Don hang',
                            style: Styles.normalTextW800(size: 18)),
                        Text(controller.statusText(order.status),
                            style: Styles.normalTextW600(
                                color: order.status == 5
                                    ? ColorName.red14
                                    : ColorName.green19)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(order.createdAt ?? '',
                        style: Styles.normalText(color: ColorName.grey1)),
                    const Divider(height: 24),
                    Text('San pham', style: Styles.normalTextW700(size: 16)),
                    const SizedBox(height: 8),
                    ...order.items.map((item) => _OrderItem(item: item)),
                    const Divider(height: 24),
                    _InfoRow(
                        'Tam tinh', Utils.I.formatCurrency(order.subtotal)),
                    _InfoRow(
                        'Giam gia', Utils.I.formatCurrency(order.discount)),
                    _InfoRow(
                        'Thanh toan', Utils.I.formatCurrency(order.totalPrice),
                        isBold: true),
                    const SizedBox(height: 16),
                    Text('Giao hang', style: Styles.normalTextW700(size: 16)),
                    const SizedBox(height: 8),
                    Text(order.customer?.address ?? ''),
                    Text(order.customer?.phoneNumber ?? ''),
                    if ((order.customer?.note ?? '').isNotEmpty)
                      Text('Ghi chu: ${order.customer?.note}'),
                    if ([1, 2].contains(order.status)) ...[
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () => controller.cancelOrder(order.id),
                        child: const Text('Huy don hang'),
                      ),
                    ],
                  ],
                );
              });
            },
          ),
        );
      },
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.order,
    required this.statusText,
    required this.paymentText,
    required this.onTap,
  });

  final OrderSummaryModel order;
  final String statusText;
  final String paymentText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: ColorName.grey53,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(order.code ?? 'Don hang',
                      style: Styles.normalTextW700(size: 15)),
                ),
                Text(statusText, style: Styles.normalTextW600(size: 13)),
              ],
            ),
            const SizedBox(height: 8),
            Text('${order.itemsCount} san pham - $paymentText',
                style: Styles.normalText(size: 13)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(order.createdAt ?? '',
                    style: Styles.normalText(color: ColorName.grey1, size: 12)),
                Text(Utils.I.formatCurrency(order.totalPrice),
                    style: Styles.normalTextW700(color: ColorName.red14)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderItem extends StatelessWidget {
  const _OrderItem({required this.item});

  final OrderItemModel item;

  @override
  Widget build(BuildContext context) {
    final image = item.productImage == null || item.productImage!.isEmpty
        ? ''
        : Utils.I.getImageFullPath(item.productImage!);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
                Text(item.productName ?? 'San pham',
                    style: Styles.normalTextW600(size: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                Text('x${item.quantity}'),
                Text(Utils.I.formatCurrency(item.totalPrice),
                    style: Styles.normalTextW600(color: ColorName.red14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value, {this.isBold = false});

  final String label;
  final String value;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  isBold ? Styles.normalTextW700() : Styles.normalTextW500()),
          Text(value,
              style:
                  isBold ? Styles.normalTextW700() : Styles.normalTextW500()),
        ],
      ),
    );
  }
}
