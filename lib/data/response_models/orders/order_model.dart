import 'package:json_annotation/json_annotation.dart';

part 'order_model.g.dart';

double stringToDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0.0;
}

int stringToInt(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? 0;
}

int? stringToIntNullable(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

bool dynamicToBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    return value == '1' || value.toLowerCase() == 'true';
  }
  return false;
}

@JsonSerializable()
class OrderPaginationModel {
  @JsonKey(name: 'current_page', fromJson: stringToInt)
  final int currentPage;

  @JsonKey(fromJson: stringToInt)
  final int total;

  @JsonKey(name: 'last_page', fromJson: stringToInt)
  final int lastPage;

  @JsonKey(name: 'per_page', fromJson: stringToInt)
  final int perPage;

  @JsonKey(defaultValue: [])
  final List<OrderSummaryModel> data;

  OrderPaginationModel({
    required this.currentPage,
    required this.total,
    required this.lastPage,
    required this.perPage,
    required this.data,
  });

  factory OrderPaginationModel.fromJson(Map<String, dynamic> json) =>
      _$OrderPaginationModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderPaginationModelToJson(this);
}

@JsonSerializable()
class OrderSummaryModel {
  @JsonKey(fromJson: stringToInt)
  final int id;

  final String? code;

  @JsonKey(name: 'total_price', fromJson: stringToDouble)
  final double totalPrice;

  @JsonKey(name: 'payment_method', fromJson: stringToInt)
  final int paymentMethod;

  @JsonKey(name: 'payment_status', fromJson: stringToInt)
  final int paymentStatus;

  @JsonKey(fromJson: stringToInt)
  final int status;

  @JsonKey(name: 'items_count', fromJson: stringToInt)
  final int itemsCount;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  OrderSummaryModel({
    required this.id,
    this.code,
    required this.totalPrice,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.status,
    required this.itemsCount,
    this.createdAt,
  });

  factory OrderSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$OrderSummaryModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderSummaryModelToJson(this);
}

@JsonSerializable()
class OrderDetailModel {
  @JsonKey(fromJson: stringToInt)
  final int id;

  final String? code;

  @JsonKey(fromJson: stringToDouble)
  final double subtotal;

  @JsonKey(fromJson: stringToDouble)
  final double discount;

  @JsonKey(name: 'total_price', fromJson: stringToDouble)
  final double totalPrice;

  @JsonKey(name: 'payment_method', fromJson: stringToInt)
  final int paymentMethod;

  @JsonKey(name: 'payment_status', fromJson: stringToInt)
  final int paymentStatus;

  @JsonKey(fromJson: stringToInt)
  final int status;

  @JsonKey(name: 'coupon_code')
  final String? couponCode;

  final OrderCustomerModel? customer;

  @JsonKey(defaultValue: [])
  final List<OrderItemModel> items;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'payment_url')
  final String? paymentUrl;

  OrderDetailModel({
    required this.id,
    this.code,
    required this.subtotal,
    required this.discount,
    required this.totalPrice,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.status,
    this.couponCode,
    this.customer,
    required this.items,
    this.createdAt,
    this.paymentUrl,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailModelToJson(this);
}

@JsonSerializable()
class OrderCustomerModel {
  final String? email;

  @JsonKey(name: 'first_name')
  final String? firstName;

  @JsonKey(name: 'last_name')
  final String? lastName;

  @JsonKey(name: 'phone_number')
  final String? phoneNumber;

  final String? address;

  @JsonKey(name: 'postal_code')
  final String? postalCode;

  @JsonKey(name: 'country_id', fromJson: stringToInt)
  final int countryId;

  final String? note;

  OrderCustomerModel({
    this.email,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.address,
    this.postalCode,
    required this.countryId,
    this.note,
  });

  factory OrderCustomerModel.fromJson(Map<String, dynamic> json) =>
      _$OrderCustomerModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderCustomerModelToJson(this);
}

@JsonSerializable()
class OrderItemModel {
  @JsonKey(fromJson: stringToInt)
  final int id;

  @JsonKey(name: 'product_id', fromJson: stringToInt)
  final int productId;

  @JsonKey(name: 'product_variant_id', fromJson: stringToIntNullable)
  final int? productVariantId;

  @JsonKey(name: 'product_name')
  final String? productName;

  @JsonKey(name: 'product_code')
  final String? productCode;

  @JsonKey(name: 'product_image')
  final String? productImage;

  @JsonKey(fromJson: stringToDouble)
  final double price;

  @JsonKey(fromJson: stringToInt)
  final int quantity;

  @JsonKey(name: 'total_price', fromJson: stringToDouble)
  final double totalPrice;

  @JsonKey(name: 'attribute_name_id', fromJson: stringToIntNullable)
  final int? attributeNameId;

  @JsonKey(name: 'attribute_name')
  final String? attributeName;

  @JsonKey(defaultValue: [])
  final List<OrderAttributeModel> attributes;

  @JsonKey(name: 'personalise_name')
  final String? personaliseName;

  @JsonKey(name: 'has_reviewed', fromJson: dynamicToBool)
  final bool hasReviewed;

  @JsonKey(name: 'can_review', fromJson: dynamicToBool)
  final bool canReview;

  OrderItemModel({
    required this.id,
    required this.productId,
    this.productVariantId,
    this.productName,
    this.productCode,
    this.productImage,
    required this.price,
    required this.quantity,
    required this.totalPrice,
    this.attributeNameId,
    this.attributeName,
    required this.attributes,
    this.personaliseName,
    this.hasReviewed = false,
    this.canReview = false,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemModelToJson(this);
}

@JsonSerializable()
class OrderAttributeModel {
  @JsonKey(name: 'attribute_id', fromJson: stringToInt)
  final int attributeId;

  @JsonKey(name: 'attribute_name')
  final String? attributeName;

  @JsonKey(name: 'attribute_value_id', fromJson: stringToInt)
  final int attributeValueId;

  @JsonKey(name: 'attribute_value')
  final String? attributeValue;

  OrderAttributeModel({
    required this.attributeId,
    this.attributeName,
    required this.attributeValueId,
    this.attributeValue,
  });

  factory OrderAttributeModel.fromJson(Map<String, dynamic> json) =>
      _$OrderAttributeModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderAttributeModelToJson(this);
}
