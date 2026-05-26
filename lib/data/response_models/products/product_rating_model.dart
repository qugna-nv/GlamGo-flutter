class ProductRatingResponse {
  final List<ProductRatingModel> items;
  final int total;
  final double averageRating;
  final Map<int, int> ratingCounts;
  final bool canReview;
  final String? reviewDeniedMessage;

  ProductRatingResponse({
    required this.items,
    required this.total,
    required this.averageRating,
    required this.ratingCounts,
    required this.canReview,
    this.reviewDeniedMessage,
  });

  factory ProductRatingResponse.fromJson(Map<String, dynamic> json) {
    final rawCounts = json['rating_counts'];
    final counts = <int, int>{};

    if (rawCounts is Map) {
      rawCounts.forEach((key, value) {
        final star = int.tryParse(key.toString());
        if (star != null) {
          counts[star] = _toInt(value);
        }
      });
    }

    return ProductRatingResponse(
      items: json['items'] is List
          ? (json['items'] as List)
              .whereType<Map<String, dynamic>>()
              .map(ProductRatingModel.fromJson)
              .toList()
          : <ProductRatingModel>[],
      total: _toInt(json['total']),
      averageRating: _toDouble(json['average_rating']),
      ratingCounts: counts,
      canReview: _toBool(json['can_review']),
      reviewDeniedMessage: json['review_denied_message']?.toString(),
    );
  }
}

class ProductRatingModel {
  final int? id;
  final int? productId;
  final String? fullname;
  final String? phone;
  final int? statusId;
  final bool isIntroduce;
  final String? comment;
  final List<String> imageReal;
  final int? countryId;
  final int? userId;
  final int ratingValue;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductRatingModel({
    this.id,
    this.productId,
    this.fullname,
    this.phone,
    this.statusId,
    this.isIntroduce = false,
    this.comment,
    this.imageReal = const [],
    this.countryId,
    this.userId,
    this.ratingValue = 5,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductRatingModel.fromJson(Map<String, dynamic> json) {
    return ProductRatingModel(
      id: _toNullableInt(json['id']),
      productId: _toNullableInt(json['product_id']),
      fullname: json['fullname']?.toString(),
      phone: json['phone']?.toString(),
      statusId: _toNullableInt(json['status_id']),
      isIntroduce: _toBool(json['is_introduce']),
      comment: json['comment']?.toString(),
      imageReal: _toStringList(json['image_real']),
      countryId: _toNullableInt(json['country_id']),
      userId: _toNullableInt(json['user_id']),
      ratingValue: _toInt(json['rating_value'], defaultValue: 5),
      createdAt: _toDateTime(json['created_at']),
      updatedAt: _toDateTime(json['updated_at']),
    );
  }
}

int _toInt(dynamic value, {int defaultValue = 0}) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? defaultValue;
}

int? _toNullableInt(dynamic value) {
  if (value == null) return null;
  return _toInt(value);
}

double _toDouble(dynamic value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

bool _toBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  return value?.toString() == '1' || value?.toString().toLowerCase() == 'true';
}

DateTime? _toDateTime(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}

List<String> _toStringList(dynamic value) {
  if (value is List) {
    return value.map((e) => e.toString()).toList();
  }

  return const [];
}
