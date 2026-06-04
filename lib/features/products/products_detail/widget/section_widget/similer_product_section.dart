import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:project_shop/base/util/utils.dart';
import 'package:project_shop/data/response_models/categories/same_category_model.dart';
import 'package:project_shop/features/products/products_detail/widget/item_similar_products.dart';
import 'package:project_shop/widgets/styles_widget/styles_widget.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';

class SimilarProductsSection extends StatelessWidget {
  const SimilarProductsSection({
    super.key,
    required this.products,
  });

  final List<SameCategoryModel> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Một số sản phẩm có thể bạn sẽ thích',
          style: Styles.normalTextW700(color: ColorName.blue31),
        ),
        const SizedBox(width: 12),
        Container(
          height: 210,
          color: ColorName.white,
          padding: EdgeInsets.all(4),
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = products[index];
              return ItemSimilarProducts(
                width: Get.width * 0.3,
                imageHeight: 124,
                radius: 4,
                nameProducts: item.name ?? 'N/A',
                priceProducts: Utils.I.formatCurrency(item.price ?? 0.0),
                path: Utils.I.getImageFullPath(
                  item.image ?? '',
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
