import 'package:flutter/material.dart';
import 'package:project_shop/base/util/utils.dart';
import 'package:project_shop/data/response_models/products/products_model.dart';
import 'package:project_shop/widgets/simple_rows/simple_row_content.dart';
import 'package:project_shop/widgets/styles_widget/styles_widget.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';
import 'package:readmore/readmore.dart';

class ProductInfoSection extends StatelessWidget {
  const ProductInfoSection({
    super.key,
    required this.product,
  });

  final ProductsModel? product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product?.name ?? 'N/A',
          style: Styles.normalTextW800(size: 18),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 8),
        SimpleRowContent(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          contentFirst: Utils.I.formatCurrency(product?.price ?? 0.0),
          firstStyle: Styles.normalTextBold(size: 24, color: ColorName.red14),
          widthSizeBox: 20,
          contentSecond: Utils.I.formatCurrency(product?.priceSale ?? 0.0),
          secondStyle: Styles.normalTextW600(color: ColorName.grey1, size: 20)
              .copyWith(
                  decoration: TextDecoration.lineThrough,
                  decorationColor: ColorName.grey1),
        ),
        SizedBox(height: 8),
        Text(
          'Mô tả sản phẩm',
          style: Styles.normalTextW600(),
        ),
        SizedBox(height: 8),
        ReadMoreText(
          product?.metaDescription ?? '',
          trimMode: TrimMode.Line,
          trimLines: 2,
          style: Styles.normalText(color: ColorName.blue31),
          colorClickableText: ColorName.blue31,
          trimCollapsedText: 'Xem thêm',
          trimExpandedText: ' Ẩn bớt',
          lessStyle: Styles.normalTextW700(color: ColorName.blue31),
          moreStyle: Styles.normalTextW700(color: ColorName.blue31),
        ),
      ],
    );
  }
}
