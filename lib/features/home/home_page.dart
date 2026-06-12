import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_shop/base/util/utils.dart';
import 'package:project_shop/data/response_models/article/article_model.dart';
import 'package:project_shop/data/response_models/products/products_model.dart';
import 'package:project_shop/features/article/widgets/item_article.dart';
import 'package:project_shop/features/home/home_controller.dart';
import 'package:project_shop/features/home/home_section_page.dart';
import 'package:project_shop/features/home/widget/infinite_carousel.dart';
import 'package:project_shop/features/notification/notification_controller.dart';
import 'package:project_shop/features/products/widget/products_item_view.dart';
import 'package:project_shop/gen/assets.gen.dart';
import 'package:project_shop/routes/app_routes.dart';
import 'package:project_shop/widgets/icon_widget/icon_widget.dart';
import 'package:project_shop/widgets/inkwell/default_ink_well.dart';
import 'package:project_shop/widgets/shimmer/shimmer_products.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';

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
              RefreshIndicator(
                onRefresh: controller.onRefresh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 50),
                        SizedBox(
                          height: Get.height * 0.31,
                          child: InfiniteCarousel(),
                        ),
                        const SizedBox(height: 12),
                        _productSection(
                          title: 'Sản phẩm nổi bật',
                          type: HomeSectionType.featured,
                          products: controller.featuredProducts,
                        ),
                        _productSection(
                          title: 'Sản phẩm đề xuất',
                          type: HomeSectionType.recommended,
                          products: controller.recommendedProducts,
                        ),
                        _articleSection(
                          title: 'Bài viết hot',
                          articles: controller.hotArticles,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(top: 0, left: 0, right: 0, child: userInformation()),
            ],
          );
        }),
      ),
    );
  }

  Widget _sectionHeader({
    required String title,
    required VoidCallback onViewAll,
    bool showViewAll = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (showViewAll)
            TextButton(
              onPressed: onViewAll,
              child: const Text('Xem tất cả'),
            ),
        ],
      ),
    );
  }

  Widget _productSection({
    required String title,
    required HomeSectionType type,
    required List<ProductsModel> products,
  }) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    final displayProducts = products.take(8).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          title: title,
          showViewAll: products.length > displayProducts.length,
          onViewAll: () {
            Get.toNamed(
              Routes.homeSection,
              arguments: HomeSectionArguments(
                title: title,
                type: type,
                products: products,
              ),
            );
          },
        ),
        SizedBox(
          height: 330,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: displayProducts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final product = displayProducts[index];
              return SizedBox(
                width: Get.width * 0.48,
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.productDetail, arguments: product.id);
                  },
                  child: Obx(
                    () => ProductsItemView(
                      name: product.name,
                      path: Utils.I.getImageFullPath(product.image ?? ''),
                      price: Utils.I.formatCurrency(product.price ?? 0.0),
                      priceSale:
                          Utils.I.formatCurrency(product.priceSale ?? 0.0),
                      onTap: () =>
                          controller.wishListController.toggleFavorite(product),
                      isWishList:
                          controller.wishListController.isFavorite(product),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _articleSection({
    required String title,
    required List<ArticleModel> articles,
  }) {
    if (articles.isEmpty) {
      return const SizedBox.shrink();
    }

    final displayArticles = articles.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          title: title,
          showViewAll: articles.length > displayArticles.length,
          onViewAll: () {
            Get.toNamed(
              Routes.homeSection,
              arguments: HomeSectionArguments(
                title: title,
                type: HomeSectionType.hotArticles,
                articles: articles,
              ),
            );
          },
        ),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: displayArticles.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final article = displayArticles[index];
            return ItemArticle(
              path: Utils.I.getImageFullPath(article.image ?? ''),
              titleNews: article.title ?? '',
              description: article.metaDescription ?? '',
              radius: 12,
              heightImg: 92,
              widthImg: 112,
              titleStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              descriptionStyle: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
              onTap: () {
                Get.toNamed(Routes.articleDetail, arguments: article);
              },
            );
          },
        ),
      ],
    );
  }

  Widget userInformation() {
    return Container(
      height: 50,
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
              onTap: () => Get.toNamed(Routes.notifications),
              child: _notificationIcon(),
            ),
          ),
          SizedBox(width: 8),
          _cartButton(),
        ],
      ),
    );
  }

  Widget _notificationIcon() {
    final notificationController = Get.find<NotificationController>();

    return Obx(() {
      final count = notificationController.unreadCount.value;
      return Stack(
        clipBehavior: Clip.none,
        children: [
          IconWidget.ic24(path: Assets.icons.icNotification),
          if (count > 0)
            Positioned(
              top: -8,
              right: -8,
              child: Container(
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: ColorName.red14,
                  borderRadius: BorderRadius.circular(999),
                ),
                alignment: Alignment.center,
                child: Text(
                  count > 99 ? '99+' : '$count',
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
    });
  }

  Widget _cartButton() {
    return GestureDetector(
      onTap: () async {
        await Get.toNamed(Routes.cart);
        controller.cartController.getCart(
          redirectIfUnauthenticated: false,
          showErrors: false,
        );
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: ColorName.grey53),
          borderRadius: BorderRadius.circular(40.r),
        ),
        child: Obx(() {
          final quantity = controller.cartController.totalQuantity;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              IconWidget.ic24(
                path: Assets.icons.icShoppingBag,
                color: ColorName.black,
              ),
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
