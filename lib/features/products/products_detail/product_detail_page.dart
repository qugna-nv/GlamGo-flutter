import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_shop/features/products/products_detail/product_detail_controller.dart';
import 'package:project_shop/features/products/products_detail/widget/product_attribute_bottom_sheet.dart';
import 'package:project_shop/features/products/products_detail/widget/section_widget/product_gallary_section.dart';
import 'package:project_shop/features/products/products_detail/widget/section_widget/product_info_section.dart';
import 'package:project_shop/features/products/products_detail/widget/section_widget/rating_section.dart';
import 'package:project_shop/features/products/products_detail/widget/section_widget/similer_product_section.dart';
import 'package:project_shop/gen/assets.gen.dart';
import 'package:project_shop/routes/app_routes.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';
import 'package:project_shop/widgets/appbar_custom/custom_app_bar.dart';
import 'package:project_shop/widgets/button/normal_button.dart';
import 'package:project_shop/widgets/icon_widget/icon_widget.dart';
import 'package:project_shop/widgets/shimmer/shimmer_product_detail.dart';
import 'package:project_shop/widgets/styles_widget/styles_widget.dart';

class ProductDetailPage extends GetView<ProductDetailController> {
  const ProductDetailPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            appBar: CustomAppBar(
              label: 'Chi tiết sản phẩm',
              action: _cartAction(),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(6, 0, 6, 60),
              child: Obx(() {
                return controller.isLoading.value
                    ? ShimmerProductDetail()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProductGallerySection(
                            controller: controller,
                          ),
                          const SizedBox(height: 50),
                          ProductInfoSection(
                            product: controller.productDetail,
                          ),
                          SizedBox(height: 12),
                          SimilarProductsSection(
                            products:
                                controller.productDetail?.sameCategory ?? [],
                          ),
                          SizedBox(height: 12),
                          RatingSection(controller: controller),
                        ],
                      );
              }),
            ),
          ),
          Positioned(
            bottom: 6,
            right: 12,
            left: 12,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                  color: ColorName.grey1,
                  borderRadius: BorderRadius.circular(40)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: IButton(
                    iconFirst: Assets.icons.icAddToCart,
                    title: 'Mua ngay',
                    color: ColorName.white,
                    radius: 50,
                    textStyle: Styles.normalTextW500(color: ColorName.black),
                    textColor: ColorName.black,
                    onPress: () async {
                      await showProductAttributeBottomSheet(
                        context: context,
                        controller: controller,
                        title: 'Mua ngay',
                        onTap: () => controller.addToCart(goToCart: true),
                      );
                    },
                  )),
                  SizedBox(width: 24),
                  Expanded(
                    child: IButton(
                      title: 'Thêm vào giỏ hàng',
                      color: ColorName.black,
                      radius: 50,
                      textStyle: Styles.normalTextW500(color: ColorName.white),
                      onPress: () async {
                        await showProductAttributeBottomSheet(
                          context: context,
                          controller: controller,
                          title: 'Thêm vào giỏ',
                          onTap: () => controller.addToCart(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _cartAction() {
    return GestureDetector(
      onTap: () async {
        await Get.toNamed(Routes.cart);
        controller.cartController.getCart(
          redirectIfUnauthenticated: false,
          showErrors: false,
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Obx(() {
          final quantity = controller.cartController.totalQuantity;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              IconWidget.ic24(path: Assets.icons.icShoppingBag),
              if (quantity > 0)
                Positioned(
                  top: -8,
                  right: -8,
                  child: Container(
                    constraints:
                        const BoxConstraints(minWidth: 18, minHeight: 18),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: ColorName.red14,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      quantity > 99 ? '99+' : '$quantity',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}
