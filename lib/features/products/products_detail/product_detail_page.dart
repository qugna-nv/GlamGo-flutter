import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:project_shop/base/util/utils.dart';
import 'package:project_shop/data/response_models/products/product_rating_model.dart';
import 'package:project_shop/features/products/products_detail/product_detail_controller.dart';
import 'package:project_shop/features/products/products_detail/widget/item_detail.dart';
import 'package:project_shop/features/products/products_detail/widget/item_similar_products.dart';
import 'package:project_shop/gen/assets.gen.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';
import 'package:project_shop/widgets/appbar_custom/custom_app_bar.dart';
import 'package:project_shop/widgets/button/favorite_button_widget.dart';
import 'package:project_shop/widgets/button/normal_button.dart';
import 'package:project_shop/widgets/icon_widget/icon_widget.dart';
import 'package:project_shop/widgets/image_base/base_image_widget.dart';
import 'package:project_shop/widgets/shimmer/shimmer_product_detail.dart';
import 'package:project_shop/widgets/simple_rows/simple_row_content.dart';
import 'package:project_shop/widgets/styles_widget/styles_widget.dart';
import 'package:readmore/readmore.dart';

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
              action: Row(
                children: [
                  IconWidget.ic24(path: Assets.icons.icShoppingBag),
                  // SizedBox(width: 8),
                  // IconWidget.ic24(path: Assets.icons.icArrowRightNew)
                ],
              ),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(6, 0, 6, 60),
              child: Obx(() {
                return controller.isLoading.value
                    ? ShimmerProductDetail()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
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
                                          controller
                                              .scrollThumbnailToIndex(index);
                                        },
                                        itemCount: controller.productDetail
                                                ?.productImages?.length ??
                                            1,
                                        itemBuilder: (context, index) {
                                          return BaseImageWidget(
                                            boxFit: BoxFit.cover,
                                            path: Utils.I.getImageFullPath(
                                              controller
                                                      .productDetail
                                                      ?.productImages?[index]
                                                      .image ??
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
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                                    itemCount: controller.productDetail
                                            ?.productImages?.length ??
                                        1,
                                    controller:
                                        controller.thumbnailScrollController,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(width: 8),
                                    itemBuilder: (context, index) {
                                      return Obx(
                                        () {
                                          return GestureDetector(
                                            onTap: () {
                                              controller
                                                  .jumpToPageFromThumbnail(
                                                      index);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: controller
                                                                  .selectedIndex
                                                                  .value ==
                                                              index &&
                                                          !controller
                                                              .isJumping.value
                                                      ? ColorName.blue31
                                                      : ColorName.grey55,
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: BaseImageWidget(
                                                boxFit: BoxFit.cover,
                                                path: Utils.I.getImageFullPath(
                                                  controller
                                                          .productDetail
                                                          ?.productImages?[
                                                              index]
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
                                child: FavoriteButton(
                                  isFavorite: controller.wishListController
                                      .isFavorite(controller.productDetail),
                                  onTap: () => controller.wishListController
                                      .toggleFavorite(
                                          controller.productDetail!),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 50),
                          Text(
                            controller.productDetail?.name ?? 'N/A',
                            style: Styles.normalTextW800(size: 18),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          SimpleRowContent(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            contentFirst: Utils.I.formatCurrency(
                                controller.productDetail?.price ?? 0.0),
                            firstStyle: Styles.normalTextBold(
                                size: 24, color: ColorName.red14),
                            widthSizeBox: 20,
                            contentSecond: Utils.I.formatCurrency(
                                controller.productDetail?.priceSale ?? 0.0),
                            secondStyle: Styles.normalTextW600(
                                    color: ColorName.grey1, size: 20)
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
                            controller.productDetail?.metaDescription ?? '',
                            trimMode: TrimMode.Line,
                            trimLines: 2,
                            style: Styles.normalText(color: ColorName.blue31),
                            colorClickableText: ColorName.blue31,
                            trimCollapsedText: 'Xem thêm',
                            trimExpandedText: ' Ẩn bớt',
                            lessStyle:
                                Styles.normalTextW700(color: ColorName.blue31),
                            moreStyle:
                                Styles.normalTextW700(color: ColorName.blue31),
                          ),
                          SizedBox(height: 12),
                          _buildRatingSection(),
                          SizedBox(height: 12),
                          Container(
                            height: 210,
                            color: ColorName.white,
                            padding: EdgeInsets.all(4),
                            child: ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: controller
                                      .productDetail?.sameCategory?.length ??
                                  0,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (context, index) {
                                final item = controller
                                    .productDetail?.sameCategory?[index];
                                return ItemSimilarProducts(
                                  width: Get.width * 0.3,
                                  imageHeight: 124,
                                  radius: 4,
                                  nameProducts: item?.name ?? 'N/A',
                                  priceProducts: Utils.I
                                      .formatCurrency(item?.price ?? 0.0),
                                  path: Utils.I.getImageFullPath(
                                    item?.image ?? '',
                                  ),
                                );
                              },
                            ),
                          ),
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
              // margin: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                  color: ColorName.grey1,
                  borderRadius: BorderRadius.circular(40)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: IButton(
                    iconFirst: Assets.icons.icAddToCart,
                    title: 'Buy Now',
                    color: ColorName.white,
                    radius: 50,
                    textStyle: Styles.normalTextW500(color: ColorName.black),
                    textColor: ColorName.black,
                    onPress: () async {
                      await showModal(
                        context,
                        'Mua ngay',
                        () => controller.addToCart(goToCart: true),
                      );
                    },
                  )),
                  SizedBox(width: 24),
                  Expanded(
                    child: IButton(
                      title: 'Add to Cart',
                      color: ColorName.black,
                      radius: 50,
                      textStyle: Styles.normalTextW500(color: ColorName.white),
                      onPress: () async {
                        await showModal(
                          context,
                          'Them vao gio',
                          () => controller.addToCart(),
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

  Widget _buildRatingSection() {
    return Obx(() {
      final summary = controller.ratingSummary;
      final ratings = controller.ratings;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ColorName.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: ColorName.grey40),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Danh gia san pham',
                  style: Styles.normalTextW700(size: 16),
                ),
                const Spacer(),
                Icon(Icons.star, color: ColorName.yellow6, size: 18),
                const SizedBox(width: 4),
                Text(
                  '${summary?.averageRating.toStringAsFixed(1) ?? '0.0'} (${summary?.total ?? 0})',
                  style: Styles.normalTextW600(size: 13),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (summary?.canReview == true)
              _buildRatingForm()
            else
              _buildReviewLockedMessage(
                summary?.reviewDeniedMessage ?? controller.reviewDeniedMessage,
              ),
            const SizedBox(height: 12),
            if (controller.ratingLoading.value)
              const Center(child: CircularProgressIndicator())
            else if (ratings.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Chua co danh gia nao.',
                  style: Styles.normalText(color: ColorName.grey45),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: ratings.length,
                separatorBuilder: (_, __) => Divider(color: ColorName.grey40),
                itemBuilder: (_, index) => _buildRatingItem(ratings[index]),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildRatingForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => RatingBar.builder(
            initialRating: controller.selectedRating.value,
            minRating: 1,
            itemCount: 5,
            itemSize: 28,
            allowHalfRating: false,
            unratedColor: ColorName.grey39,
            itemBuilder: (_, __) => Icon(Icons.star, color: ColorName.yellow6),
            onRatingUpdate: (value) {
              controller.selectedRating.value = value;
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildInput(
                controller: controller.ratingNameController,
                hintText: 'Ho ten',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildInput(
                controller: controller.ratingPhoneController,
                hintText: 'So dien thoai',
                keyboardType: TextInputType.phone,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildInput(
          controller: controller.ratingCommentController,
          hintText: 'Noi dung binh luan',
          minLines: 3,
          maxLines: 4,
        ),
        const SizedBox(height: 10),
        Obx(
          () => IButton(
            title: 'Gui danh gia',
            color: ColorName.black,
            radius: 8,
            isLoading: controller.ratingSubmitting.value,
            textStyle: Styles.normalTextW600(color: ColorName.white),
            onPress: controller.submitRating,
          ),
        ),
      ],
    );
  }

  Widget _buildReviewLockedMessage(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ColorName.grey38,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ColorName.grey40),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 18, color: ColorName.grey45),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: Styles.normalText(size: 13, color: ColorName.grey36),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    int minLines = 1,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: Styles.normalText(size: 13, color: ColorName.grey45),
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: ColorName.grey39),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: ColorName.black),
        ),
      ),
    );
  }

  Widget _buildRatingItem(ProductRatingModel item) {
    final createdAt = item.createdAt;
    final dateText = createdAt == null
        ? ''
        : '${createdAt.day.toString().padLeft(2, '0')}/${createdAt.month.toString().padLeft(2, '0')}/${createdAt.year}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.fullname ?? 'Khach hang',
                  style: Styles.normalTextW700(size: 14),
                ),
              ),
              Text(
                dateText,
                style: Styles.normalText(size: 12, color: ColorName.grey45),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                Icons.star,
                size: 16,
                color: index < item.ratingValue
                    ? ColorName.yellow6
                    : ColorName.grey39,
              ),
            ),
          ),
          if ((item.comment ?? '').isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              item.comment ?? '',
              style: Styles.normalText(size: 13, color: ColorName.grey36),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> showModal(
      BuildContext context, String? title, VoidCallback? onTap) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? '',
                      style: Styles.normalTextW700(size: 18),
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BaseImageWidget(
                          path: Utils.I.getImageFullPath(
                              controller.productDetail?.image ?? ''),
                          heightImage: 150,
                          widthImage: 120,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.productDetail?.name ?? '',
                                  style: Styles.normalTextW700(size: 16),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  Utils.I.formatCurrency(
                                    (controller
                                                    .productDetail?.priceSale ??
                                                0) >
                                            0
                                        ? controller.productDetail?.priceSale ??
                                            0
                                        : controller.productDetail?.price ?? 0,
                                  ),
                                  style: Styles.normalTextW700(
                                      color: ColorName.red14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: controller.listAttribute.length,
                        itemBuilder: (context, index) {
                          final attributes = controller.listAttribute[index];
                          return Obx(() {
                            return ItemDetail(
                              attribute: attributes,
                              selected: controller
                                  .getSelectedValue(attributes.id ?? 0),
                              onSelected: (value) {
                                controller.selectAttribute(
                                  attributeId: attributes.id!,
                                  value: value,
                                );
                                controller.printSelected();
                              },
                            );
                          });
                        }),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Text('So luong', style: Styles.normalTextW600()),
                        Spacer(),
                        IconButton(
                          onPressed: controller.decreaseQuantity,
                          icon: Icon(Icons.remove_circle_outline),
                        ),
                        Obx(() => Text(
                              '${controller.quantity.value}',
                              style: Styles.normalTextW700(size: 16),
                            )),
                        IconButton(
                          onPressed: controller.increaseQuantity,
                          icon: Icon(Icons.add_circle_outline),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Obx(
                      () => IButton(
                        title: title ?? 'Them vao gio',
                        color: ColorName.black,
                        textStyle:
                            Styles.normalTextW600(color: ColorName.white),
                        isLoading: controller.cartLoading.value,
                        onPress: onTap,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
