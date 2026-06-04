import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:project_shop/base/util/utils.dart';
import 'package:project_shop/features/products/products_detail/product_detail_controller.dart';
import 'package:project_shop/widgets/button/favorite_button_widget.dart';
import 'package:project_shop/widgets/image_base/base_image_widget.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';

class ProductGallerySection extends GetView<ProductDetailController> {
  const ProductGallerySection({
    super.key,
    required this.controller,
  });

  @override
  final ProductDetailController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          height: Get.height * 0.5,
          child: Obx(() {
            return Opacity(
              opacity: controller.isJumping.value ? 0 : 1,
              child: IgnorePointer(
                ignoring: controller.isJumping.value,
                child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: (index) {
                    controller.scrollThumbnailToIndex(index);
                  },
                  itemCount:
                      controller.productDetail?.productImages?.length ?? 1,
                  itemBuilder: (context, index) {
                    return BaseImageWidget(
                      boxFit: BoxFit.cover,
                      path: Utils.I.getImageFullPath(
                        controller.productDetail?.productImages?[index].image ??
                            '',
                      ),
                    );
                  },
                ),
              ),
            );
          }),
        ),
        Obx(() {
          return controller.isJumping.value
              ? Container(
                  height: Get.height * 0.5,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black87,
                  ),
                )
              : const SizedBox.shrink();
        }),
        Positioned(
          bottom: -40,
          left: 4,
          right: 4,
          child: SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: controller.productDetail?.productImages?.length ?? 1,
              controller: controller.thumbnailScrollController,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                return Obx(
                  () {
                    return GestureDetector(
                      onTap: () {
                        controller.jumpToPageFromThumbnail(index);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: controller.selectedIndex.value == index &&
                                    !controller.isJumping.value
                                ? ColorName.blue31
                                : ColorName.grey55,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: BaseImageWidget(
                          boxFit: BoxFit.cover,
                          path: Utils.I.getImageFullPath(
                            controller.productDetail?.productImages?[index]
                                    .image ??
                                '',
                          ),
                          heightImage: 70,
                          widthImage: 70,
                          radius: 6,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Obx(() {
            final product = controller.productDetail;

            if (product == null) {
              return const SizedBox.shrink();
            }

            final isFavorite =
                controller.wishListController.isFavorite(product);

            return FavoriteButton(
              isFavorite: isFavorite,
              onTap: () {
                controller.wishListController.toggleFavorite(product);
              },
            );
          }),
        ),
      ],
    );
  }
}
