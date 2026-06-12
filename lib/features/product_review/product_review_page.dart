import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:project_shop/base/util/utils.dart';
import 'package:project_shop/data/response_models/orders/order_model.dart';
import 'package:project_shop/features/product_review/product_review_controller.dart';
import 'package:project_shop/widgets/button/normal_button.dart';
import 'package:project_shop/widgets/image_base/base_image_widget.dart';
import 'package:project_shop/widgets/styles_widget/styles_widget.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';

class ProductReviewPage extends GetView<ProductReviewController> {
  const ProductReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final item = controller.item;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Đánh giá sản phẩm'),
          centerTitle: true,
        ),
        body: item == null
            ? const Center(child: Text('Không có dữ liệu sản phẩm'))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ProductReviewHeader(item: item),
                    const SizedBox(height: 24),
                    Text('Đánh giá sản phẩm',
                        style: Styles.normalTextW700(size: 16)),
                    const SizedBox(height: 8),
                    Obx(
                      () => RatingBar.builder(
                        initialRating: controller.rating.value,
                        minRating: 1,
                        itemCount: 5,
                        itemSize: 36,
                        allowHalfRating: false,
                        unratedColor: ColorName.grey39,
                        itemBuilder: (_, __) =>
                            Icon(Icons.star, color: ColorName.yellow6),
                        onRatingUpdate: (value) {
                          controller.rating.value = value;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('Nội dung đánh giá',
                        style: Styles.normalTextW700(size: 16)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controller.commentController,
                      minLines: 5,
                      maxLines: 8,
                      decoration: InputDecoration(
                        hintText: 'Viết đánh giá, cảm nhận của bạn về sản phẩm',
                        hintStyle: Styles.normalText(
                            size: 13, color: ColorName.grey45),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: ColorName.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Obx(
                      () => IButton(
                        title: 'Gửi đánh giá',
                        color: ColorName.black,
                        isDisable: !item.canReview,
                        isLoading: controller.submitting.value,
                        textStyle:
                            Styles.normalTextW600(color: ColorName.white),
                        onPress: controller.submitReview,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _ProductReviewHeader extends StatelessWidget {
  const _ProductReviewHeader({required this.item});

  final OrderItemModel item;

  @override
  Widget build(BuildContext context) {
    final image = item.productImage == null || item.productImage!.isEmpty
        ? ''
        : Utils.I.getImageFullPath(item.productImage!);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorName.grey53,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseImageWidget(
            path: image,
            widthImage: 92,
            heightImage: 92,
            radius: 10,
            boxFit: BoxFit.cover,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName ?? 'Sản phẩm',
                  style: Styles.normalTextW700(size: 15),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if ((item.productCode ?? '').isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text('Mã: ${item.productCode}',
                      style: Styles.normalText(size: 12)),
                ],
                if (item.attributes.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.attributes
                        .map((attribute) =>
                            '${attribute.attributeName ?? 'Phân loại'}: ${attribute.attributeValue ?? ''}')
                        .join(', '),
                    style: Styles.normalText(size: 12, color: ColorName.grey1),
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  Utils.I.formatCurrency(item.price),
                  style: Styles.normalTextW700(color: ColorName.red14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
