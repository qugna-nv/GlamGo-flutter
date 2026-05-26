import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_shop/gen/assets.gen.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';
import 'package:project_shop/widgets/icon_widget/icon_widget.dart';
import 'package:project_shop/widgets/image_base/products_image_widget.dart';
import 'package:project_shop/widgets/inkwell/default_ink_well.dart';
import 'package:project_shop/widgets/quantity_selector_widget.dart';
import 'package:project_shop/widgets/simple_rows/simple_row_content.dart';
import 'package:project_shop/widgets/simple_rows/simple_row_widget.dart';
import 'package:project_shop/widgets/styles_widget/styles_widget.dart';

class ProductsItemWishlist extends StatelessWidget {
  const ProductsItemWishlist({
    super.key,
    this.isItemWishList = true,
    this.path,
    this.starCount,
    this.nameProduct,
    this.describe,
    this.onTap,
    this.onWishListProduct,
    this.isWishList = false,
    this.ratting,
  });

  final bool isItemWishList;
  final String? path;
  final String? starCount, nameProduct, describe;
  final VoidCallback? onTap;
  final VoidCallback? onWishListProduct;
  final bool isWishList;
  final double? ratting;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: ColorName.grey53,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ProductsImageWidget(
            isWishList: isWishList,
            onTap: onWishListProduct,
            iconSize: 34,
            heightImage: 120,
            widthImage: Get.width * 0.46,
            bgrColor: ColorName.white,
            boxFit: BoxFit.contain,
            path: path ??
                'https://img.freepik.com/premium-photo/cool-fashion-casual-men-outfit-wooden-table_93675-18917.jpg?semt=ais_hybri',
          ),
          SizedBox(width: 8),
          Flexible(
            flex: 1,
            child: isItemWishList
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SimpleRowWidget(
                        isWidthSizeBox: 0,
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                        // textAlign: TextAlign.start,
                        isShowWidget: true,
                        imageFirst: null,
                        contentFirst: nameProduct ?? 'Áo Hoodie uuuu',
                        styleContent: Styles.normalTextW700(size: 16),
                        isSpacer: false,
                        widget: IconWidget.ic12(
                          path: Assets.icons.icStar,
                          color: ColorName.yellow5,
                        ),
                        contentSecond: starCount ?? '3.5',
                      ),
                      SizedBox(height: 12),
                      // SimpleRowWidget(
                      //   isWidthSizeBox: 0,
                      //   padding:
                      //       EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                      //   // textAlign: TextAlign.start,
                      //   isShowWidget: true,
                      //   imageFirst: Assets.icons.icDelete,
                      //   contentFirst: '3.5',
                      //   color: ColorName.yellow5,
                      //   styleContent: Styles.normalTextW700(size: 16),
                      //   isSpacer: false,
                      //   // widget: IconWidget.ic12(
                      //   //   path: Assets.icons.icStar,
                      //   //   color: ColorName.yellow5,
                      //   // ),
                      // ),
                      Text(
                        describe ??
                            'Giúp tôi sửa đoạn văn trên, giữ nguyên nội dung nhé',
                        style: Styles.normalText(size: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 12),
                      SimpleRowContent(
                        widthSizeBox: 20,
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SimpleRowWidget(
                        disableOnclick: true,
                        isWidthSizeBox: 0,
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                        // textAlign: TextAlign.start,
                        isShowWidget: true,
                        imageFirst: null,
                        contentFirst: nameProduct ?? 'Áo Hoodie uuuu',
                        styleContent: Styles.normalTextW700(size: 16),
                        isSpacer: false,
                        widget: DefaultInkWell(
                          onTap: onTap,
                          child: IconWidget.ic24(
                            path: Assets.icons.icDelete,
                            color: ColorName.orange17,
                          ),
                        ),
                        contentSecond: '',
                      ),
                      SizedBox(height: 8),
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
                      Text(
                        describe ?? 'Size: M, Color: Black, Material: Cotton',
                        style: Styles.normalText(size: 10),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        describe ?? '500.000đ',
                        style: Styles.normalText(size: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      QuantitySelectorWidget(onAdd: () {}, onRemove: () {}),
                    ],
                  ),
          )
        ],
      ),
    );
  }
}
