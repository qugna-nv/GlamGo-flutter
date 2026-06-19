import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_shop/features/products/products_detail/product_detail_controller.dart';
import 'package:project_shop/features/products/products_detail/widget/item_detail.dart';
import 'package:project_shop/widgets/styles_widget/styles_widget.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';

class ProductVariantSection extends StatelessWidget {
  const ProductVariantSection({
    super.key,
    required this.controller,
  });

  final ProductDetailController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.listAttribute.isEmpty) {
        return const SizedBox.shrink();
      }

      final stock = controller.selectedStockQuantity;
      final hasStock = (stock ?? 0) > 0;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Phân loại',
            style: Styles.normalTextW600(),
          ),
          const SizedBox(height: 8),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.listAttribute.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, index) {
              final attribute = controller.listAttribute[index];

              return ItemDetail(
                attribute: attribute,
                selected: controller.getSelectedValue(attribute.id ?? 0),
                onSelected: (value) {
                  controller.selectAttribute(
                    attributeId: attribute.id!,
                    value: value,
                  );
                },
              );
            },
          ),
          const SizedBox(height: 8),
          if (controller.hasSelectedAllAttributes)
            Text(
              'Tồn kho: ${stock ?? 0}',
              style: Styles.normalText(
                size: 12,
                color: hasStock ? ColorName.black : ColorName.red13,
              ),
            )
          else
            Text(
              'Vui lòng chọn đầy đủ phân loại',
              style: Styles.normalText(size: 12, color: ColorName.red13),
            ),
        ],
      );
    });
  }
}
