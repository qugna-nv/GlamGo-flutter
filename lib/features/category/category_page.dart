import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_shop/base/util/utils.dart';
import 'package:project_shop/features/category/category_controller.dart';
import 'package:project_shop/features/category/widget/item_categories.dart';
import 'package:project_shop/features/products/widget/products_item_view.dart';

class CategoryPage extends GetView<CategoryController> {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Obx(
          () {
            if (controller.isLoading.value || controller.isLoadingProduct) {
              return Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  Obx(
                    () {
                      if (controller.listDisplayedProducts.isEmpty) {
                        return Center(child: Text('Không có sản phẩm nào'));
                      }
                      return Expanded(
                        child: Obx(
                          () => GridView.builder(
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
                              return Obx(() {
                                return ProductsItemView(
                                  name: products.name,
                                  path: Utils.I
                                      .getImageFullPath(products.image ?? ''),
                                  price: products.price.toString(),
                                  priceSale: products.priceSale.toString(),
                                  onTap: () => controller.wishListController
                                      .toggleFavorite(products),
                                  isWishList: controller.wishListController
                                      .isFavorite(products),
                                );
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
