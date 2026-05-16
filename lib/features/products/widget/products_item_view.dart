// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:project_shop/gen/assets.gen.dart';
// import 'package:project_shop/gen/colors.gen.dart';
// import 'package:project_shop/widgets/icon_widget/icon_widget.dart';
// import 'package:project_shop/widgets/image_base/products_image_widget.dart';
// import 'package:project_shop/widgets/simple_rows/simple_row_content.dart';
// import 'package:project_shop/widgets/simple_rows/simple_row_widget.dart';
// import 'package:project_shop/widgets/styles_widget/styles_widget.dart';

// class ProductsItemView extends StatelessWidget {
//   const ProductsItemView({
//     super.key,
//     this.name,
//     this.path,
//     this.widthImage,
//     this.heightImage,
//     this.iconSize,
//     this.onTap,
//     this.icon,
//     this.cacheKey,
//     this.errorWidget,
//     this.boxFit,
//     this.bgrColor,
//     this.price,
//     this.priceSale,
//     this.starCount,
//     this.isWishList = true,
//     this.iconColor,
//   });

//   final String? name;
//   final String? path;
//   final double? widthImage, heightImage, iconSize;
//   final VoidCallback? onTap;
//   final String? icon;
//   final String? cacheKey;
//   final Widget? errorWidget;
//   final BoxFit? boxFit;
//   final Color? bgrColor, iconColor;
//   final String? price, priceSale, starCount;
//   final bool isWishList;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: Get.width * 0.48,
//       padding: EdgeInsets.all(8),
//       decoration: BoxDecoration(
//           color: ColorName.grey53, borderRadius: BorderRadius.circular(12)),
//       child: Column(
//         children: [
//           ProductsImageWidget(
//             path: path ?? '',
//             heightImage: heightImage ?? 180,
//             widthImage: widthImage ?? Get.width,
//             iconSize: iconSize,
//             onTap: onTap,
//             cacheKey: cacheKey,
//             errorWidget: errorWidget,
//             boxFit: boxFit,
//             bgrColor: bgrColor,
//             isWishList: isWishList,
//             colorIcon: iconColor,
//           ),
//           SizedBox(height: 8),
//           SimpleRowWidget(
//             padding: EdgeInsets.symmetric(horizontal: 4),
//             textAlign: TextAlign.start,
//             isShowWidget: true,
//             contentFirst: name ?? 'Áo Hoodie uuuu',
//             styleContent: Styles.normalTextW700(),
//             isSpacer: false,
//             widget: IconWidget.ic12(
//               path: Assets.icons.icStar,
//               color: ColorName.yellow5,
//             ),
//             contentSecond: starCount ?? '3.5',
//           ),
//           SimpleRowContent(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             isShowWidget: true,
//             contentFirst: priceSale ?? '\$150',
//             contentSecond: price ?? '\$300',
//             firstStyle: Styles.normalTextW500(size: 14),
//             secondStyle: Styles.normalTextW500(
//               color: ColorName.grey1,
//             ).copyWith(
//                 decoration: TextDecoration.lineThrough,
//                 decorationColor: ColorName.orange17),
//             firstTextOverflow: TextOverflow.ellipsis,
//           )
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_shop/gen/assets.gen.dart';
import 'package:project_shop/gen/colors.gen.dart';
import 'package:project_shop/widgets/icon_widget/icon_widget.dart';
import 'package:project_shop/widgets/image_base/products_image_widget.dart';
import 'package:project_shop/widgets/simple_rows/simple_row_content.dart';
import 'package:project_shop/widgets/styles_widget/styles_widget.dart';

class ProductsItemView extends StatelessWidget {
  const ProductsItemView({
    super.key,
    this.name,
    this.path,
    this.widthImage,
    this.heightImage,
    this.iconSize,
    this.onTap,
    this.price,
    this.priceSale,
    this.starCount,
    this.isWishList = true,
    this.ratting,
  });

  final String? name;
  final String? path;
  final double? widthImage, heightImage, iconSize;
  final VoidCallback? onTap;
  final String? price, priceSale, starCount;
  final bool isWishList;
  final double? ratting;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: Get.width * 0.48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: ProductsImageWidget(
                  path: path ?? '',
                  heightImage: heightImage ?? 180,
                  widthImage: widthImage ?? Get.width,
                  onTap: onTap,
                  isWishList: isWishList,
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: const BoxDecoration(
                    color: Color(0xFF4A4A4A),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'NEW',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name ?? 'Áo thun Graphic Dora Don (Limited)',
                  style: Styles.normalTextW700(size: 16.sp),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                // const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      RatingBarIndicator(
                        rating: ratting ?? 4.5,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 20.0,
                        direction: Axis.horizontal,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        starCount ?? '4.6',
                        style: Styles.normalTextW500(size: 14),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      price ?? '1.200.000 đ',
                      style: Styles.normalTextW400(size: 14, color: Colors.grey)
                          .copyWith(
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    Text(
                      priceSale ?? '900.000 đ',
                      style: Styles.normalTextW700(
                          size: 18, color: const Color(0xFF631919)),
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
