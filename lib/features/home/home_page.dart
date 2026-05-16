import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_shop/base/util/utils.dart';
import 'package:project_shop/features/category/widget/item_categories.dart';
import 'package:project_shop/features/home/home_controller.dart';
import 'package:project_shop/features/home/widget/infinite_carousel.dart';
import 'package:project_shop/features/products/widget/products_item_view.dart';
import 'package:project_shop/gen/assets.gen.dart';
import 'package:project_shop/gen/colors.gen.dart';
import 'package:project_shop/routes/app_routes.dart';
import 'package:project_shop/widgets/icon_widget/icon_widget.dart';
import 'package:project_shop/widgets/inkwell/default_ink_well.dart';
import 'package:project_shop/widgets/shimmer/shimmer_products.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Obx(() {
          if (controller.isLoading.value || controller.isLoadingProduct) {
            return ShimmerProducts();
          }
          return Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        height: Get.height * 0.31,
                        child: InfiniteCarousel(),
                      ),
                      Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(vertical: 6),
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.listCategories.length + 1,
                          itemBuilder: (context, index) {
                            return Obx(
                              () {
                                if (index == 0) {
                                  return ItemCategories(
                                    selectedIndex: controller.selectedIndex,
                                    index: index,
                                    categoryName: "Tất cả",
                                    onTap: () {
                                      controller.selectCategory(index: index);
                                    },
                                  );
                                } else {
                                  final category =
                                      controller.listCategories[index - 1];
                                  return ItemCategories(
                                    selectedIndex: controller.selectedIndex,
                                    index: index,
                                    categoryName: category.name,
                                    onTap: () {
                                      controller.selectCategory(
                                          index: index,
                                          categoryId: category.id ?? 0);
                                    },
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
                      Obx(() {
                        if (controller.listDisplayedProducts.isEmpty) {
                          return Center(child: Text('Không có sản phẩm nào'));
                        }
                        return GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.listDisplayedProducts.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            mainAxisExtent: 330,
                          ),
                          itemBuilder: (context, index) {
                            final products =
                                controller.listDisplayedProducts[index];
                            return GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.productDetail,
                                    arguments: products.id);
                              },
                              child: Obx(() {
                                return ProductsItemView(
                                  name: products.name,
                                  path: Utils.I
                                      .getImageFullPath(products.image ?? ''),
                                  price: Utils.I
                                      .formatCurrency(products.price ?? 0.0),
                                  priceSale: Utils.I.formatCurrency(
                                      products.priceSale ?? 0.0),
                                  onTap: () => controller.wishListController
                                      .toggleFavorite(products),
                                  isWishList: controller.wishListController
                                      .isFavorite(products),
                                );
                              }),
                            );
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),
              Positioned(top: 0, left: 0, right: 0, child: userInformation())
            ],
          );
        }),
      ),
    );
  }

  Widget userInformation() {
    return Container(
      height: 50,
      // margin: EdgeInsets.symmetric(horizontal: 18),
      padding: EdgeInsets.only(right: 18, left: 18),
      decoration: BoxDecoration(
        color: ColorName.grey16,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8.r),
          bottomRight: Radius.circular(8.r),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.images.avatar.path),
                fit: BoxFit.fill,
              ),
              color: Color(0xFFFFD88D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(48),
              ),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Hello Vanish',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.8),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Welcom ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        TextSpan(
                          text: 'to Sensei',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: ColorName.grey53),
              borderRadius: BorderRadius.circular(40.r),
            ),
            child: DefaultInkWell(
              onTap: () {},
              child: IconWidget.ic24(path: Assets.icons.icNotification),
            ),
          ),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: ColorName.grey53),
              borderRadius: BorderRadius.circular(40.r),
            ),
            child: GestureDetector(
              onTap: () {
                Get.toNamed(Routes.cart);
              },
              child: IconWidget.ic24(
                path: Assets.icons.icShoppingBag,
                color: ColorName.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
