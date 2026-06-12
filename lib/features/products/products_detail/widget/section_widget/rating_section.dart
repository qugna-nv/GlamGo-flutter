import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_shop/features/products/products_detail/product_detail_controller.dart';
import 'package:project_shop/features/products/products_detail/widget/rating_item.dart';
import 'package:project_shop/widgets/styles_widget/styles_widget.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';

class RatingSection extends StatelessWidget {
  const RatingSection({
    super.key,
    required this.controller,
  });

  final ProductDetailController controller;

  @override
  Widget build(BuildContext context) {
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
            _RatingHeader(
              averageRating: summary?.averageRating ?? 0,
              total: summary?.total ?? 0,
            ),
            const SizedBox(height: 12),
            if (controller.ratingLoading.value)
              const Center(child: CircularProgressIndicator())
            else if (ratings.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Hiện chưa có đánh giá nào.',
                  style: Styles.normalText(color: ColorName.grey45),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: ratings.length,
                separatorBuilder: (_, __) => Divider(color: ColorName.grey40),
                itemBuilder: (_, index) {
                  return RatingItem(
                    item: ratings[index],
                    canManage: controller.canManageRating(ratings[index]),
                    onEdit: () => controller.showEditRatingDialog(
                      ratings[index],
                    ),
                    onDelete: () => controller.confirmDeleteRating(
                      ratings[index],
                    ),
                  );
                },
              ),
          ],
        ),
      );
    });
  }
}

class _RatingHeader extends StatelessWidget {
  const _RatingHeader({
    required this.averageRating,
    required this.total,
  });

  final double averageRating;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Đánh giá',
          style: Styles.normalTextW700(size: 16),
        ),
        const Spacer(),
        Icon(Icons.star, color: ColorName.yellow6, size: 18),
        const SizedBox(width: 4),
        Text(
          '${averageRating.toStringAsFixed(1)} ($total)',
          style: Styles.normalTextW600(size: 13),
        ),
      ],
    );
  }
}
