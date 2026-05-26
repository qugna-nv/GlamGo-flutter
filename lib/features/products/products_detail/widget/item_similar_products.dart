import 'package:flutter/material.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';
import 'package:project_shop/widgets/image_base/base_image_widget.dart';
import 'package:project_shop/widgets/styles_widget/styles_widget.dart';

class ItemSimilarProducts extends StatelessWidget {
  const ItemSimilarProducts({
    super.key,
    this.nameProducts,
    this.priceProducts,
    this.path,
    this.width,
    this.height,
    this.imageWidth,
    this.imageHeight,
    this.title,
    this.radius,
  });

  final String? nameProducts;
  final String? priceProducts;
  final String? path;
  final double? width, height;
  final double? imageWidth, imageHeight;
  final String? title;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      width: width,
      height: height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: ColorName.grey53),
      child: Column(
        children: [
          BaseImageWidget(
            path: path ?? 'https://picsum.photos/id/1015/600/400',
            heightImage: imageHeight ?? 140,
            widthImage: imageWidth,
            radius: radius,
          ),
          Text(
            nameProducts ?? 'Tên sản phẩmsadasdasdsad qưe32e32e32e32e323',
            style: Styles.normalTextW500(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            priceProducts ?? 'Giá tiền sản phẩm',
            style: Styles.normalTextW500(),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
