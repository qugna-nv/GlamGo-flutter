import 'package:flutter/material.dart';
import 'package:project_shop/data/response_models/products/product_rating_model.dart';
import 'package:project_shop/widgets/styles_widget/styles_widget.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';

class RatingItem extends StatelessWidget {
  const RatingItem({
    super.key,
    required this.item,
  });

  final ProductRatingModel item;

  @override
  Widget build(BuildContext context) {
    final dateText = _formatDate(item.createdAt);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RatingUserInfo(
            name: item.fullname ?? 'Khách hàng',
            dateText: dateText,
          ),
          const SizedBox(height: 4),
          _RatingStars(
            ratingValue: item.ratingValue,
          ),
          if ((item.comment ?? '').isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              item.comment ?? '',
              style: Styles.normalText(
                size: 13,
                color: ColorName.grey36,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime? createdAt) {
    if (createdAt == null) return '';

    final day = createdAt.day.toString().padLeft(2, '0');
    final month = createdAt.month.toString().padLeft(2, '0');
    final year = createdAt.year;

    return '$day/$month/$year';
  }
}

class _RatingUserInfo extends StatelessWidget {
  const _RatingUserInfo({
    required this.name,
    required this.dateText,
  });

  final String name;
  final String dateText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            name,
            style: Styles.normalTextW700(size: 14),
          ),
        ),
        Text(
          dateText,
          style: Styles.normalText(
            size: 12,
            color: ColorName.grey45,
          ),
        ),
      ],
    );
  }
}

class _RatingStars extends StatelessWidget {
  const _RatingStars({
    required this.ratingValue,
  });

  final int ratingValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        5,
        (index) {
          final isActive = index < ratingValue;

          return Icon(
            Icons.star,
            size: 16,
            color: isActive ? ColorName.yellow6 : ColorName.grey39,
          );
        },
      ),
    );
  }
}
