import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_shop/base/util/utils.dart';
import 'package:project_shop/features/category/category_controller.dart';
import 'package:project_shop/features/category/widget/item_categories.dart';
import 'package:project_shop/features/products/widget/products_item_view.dart';
import 'package:project_shop/routes/app_routes.dart';
import 'package:project_shop/utils/app_text_field.dart';

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
                      physics: const AlwaysScrollableScrollPhysics(),
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
                  AppTextField.standard(
                    controller: controller.searchController,
                    onChanged: controller.onSearchChanged,
                    hintText: 'Tìm kiếm theo mã hoặc tên sản phẩm',
                    prefixIcon: Icons.search,
                    suffixIcon: controller.searchQuery.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: controller.clearSearch,
                          ),
                  ),
                  const SizedBox(height: 12),
                  Obx(
                    () {
                      if (controller.listDisplayedProducts.isEmpty) {
                        return Center(child: Text('Không có sản phẩm nào'));
                      }
                      return Expanded(
                        child: Obx(
                          () => RefreshIndicator(
                            onRefresh: () async {
                              await controller.onRefresh();
                            },
                            child: GridView.builder(
                              controller: controller.scrollController,
                              itemCount:
                                  controller.listDisplayedProducts.length +
                                      (controller.isLoadingMore ? 1 : 0),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                mainAxisExtent: 330,
                              ),
                              itemBuilder: (context, index) {
                                if (index >=
                                    controller.listDisplayedProducts.length) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

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
                                      path: Utils.I.getImageFullPath(
                                          products.image ?? ''),
                                      price: Utils.I.formatCurrency(
                                          products.price ?? 0.0),
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
                            ),
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
