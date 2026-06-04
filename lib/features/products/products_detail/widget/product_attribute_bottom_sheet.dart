import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_shop/base/util/utils.dart';
import 'package:project_shop/features/products/products_detail/product_detail_controller.dart';
import 'package:project_shop/features/products/products_detail/widget/item_detail.dart';
import 'package:project_shop/widgets/button/normal_button.dart';
import 'package:project_shop/widgets/image_base/base_image_widget.dart';
import 'package:project_shop/widgets/styles_widget/styles_widget.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';

Future<void> showProductAttributeBottomSheet({
  required BuildContext context,
  required ProductDetailController controller,
  required String title,
  required VoidCallback onTap,
}) {
  return showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (_) {
      return ProductAttributeBottomSheet(
        controller: controller,
        title: title,
        onTap: onTap,
      );
    },
  );
}

class ProductAttributeBottomSheet extends StatelessWidget {
  const ProductAttributeBottomSheet({
    super.key,
    required this.controller,
    required this.title,
    required this.onTap,
  });

  final ProductDetailController controller;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Styles.normalTextW700(size: 18)),
              const SizedBox(height: 12),
              _ProductSheetInfo(controller: controller),
              const SizedBox(height: 12),
              _ProductAttributeList(controller: controller),
              const SizedBox(height: 12),
              _QuantitySelector(controller: controller),
              const SizedBox(height: 12),
              Obx(
                () => IButton(
                  title: title,
                  color: ColorName.black,
                  textStyle: Styles.normalTextW600(color: ColorName.white),
                  isLoading: controller.cartLoading.value,
                  onPress: onTap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductSheetInfo extends StatelessWidget {
  const _ProductSheetInfo({
    required this.controller,
  });

  final ProductDetailController controller;

  @override
  Widget build(BuildContext context) {
    final product = controller.productDetail;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BaseImageWidget(
          path: Utils.I.getImageFullPath(product?.image ?? ''),
          heightImage: 150,
          widthImage: 120,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product?.name ?? '',
                  style: Styles.normalTextW700(size: 16),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  Utils.I.formatCurrency(
                    ((product?.priceSale ?? 0) > 0)
                        ? product?.priceSale ?? 0
                        : product?.price ?? 0,
                  ),
                  style: Styles.normalTextW700(color: ColorName.red14),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProductAttributeList extends StatelessWidget {
  const _ProductAttributeList({
    required this.controller,
  });

  final ProductDetailController controller;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.listAttribute.length,
      itemBuilder: (context, index) {
        final attribute = controller.listAttribute[index];

        return Obx(() {
          return ItemDetail(
            attribute: attribute,
            selected: controller.getSelectedValue(attribute.id ?? 0),
            onSelected: (value) {
              controller.selectAttribute(
                attributeId: attribute.id!,
                value: value,
              );
              controller.printSelected();
            },
          );
        });
      },
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  const _QuantitySelector({
    required this.controller,
  });

  final ProductDetailController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Số lượng', style: Styles.normalTextW600()),
        const Spacer(),
        IconButton(
          onPressed: controller.decreaseQuantity,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        Obx(
          () => Text(
            '${controller.quantity.value}',
            style: Styles.normalTextW700(size: 16),
          ),
        ),
        IconButton(
          onPressed: controller.increaseQuantity,
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}
