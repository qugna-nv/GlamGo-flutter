import 'package:json_annotation/json_annotation.dart';

part 'cart_model.g.dart';

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

List<int> attributeIdsFromJson(dynamic value) {
  if (value is List) {
    return value.map(stringToInt).where((id) => id > 0).toList();
  }
  return [];
}

@JsonSerializable()
class CartModel {
  @JsonKey(fromJson: stringToInt)
  final int id;

  final String? code;

  @JsonKey(name: 'user_id', fromJson: stringToInt)
  final int userId;

  @JsonKey(fromJson: stringToDouble)
  final double subtotal;

  @JsonKey(fromJson: stringToDouble)
  final double discount;

  @JsonKey(name: 'total_price', fromJson: stringToDouble)
  final double totalPrice;

  @JsonKey(name: 'total_quantity', fromJson: stringToInt)
  final int totalQuantity;

  @JsonKey(defaultValue: [])
  final List<CartItemModel> items;

  CartModel({
    required this.id,
    this.code,
    required this.userId,
    required this.subtotal,
    required this.discount,
    required this.totalPrice,
    required this.totalQuantity,
    required this.items,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) =>
      _$CartModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartModelToJson(this);
}

@JsonSerializable()
class CartItemModel {
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

  @JsonKey(name: 'attribute_name_id', fromJson: stringToIntNullable)
  final int? attributeNameId;

  @JsonKey(name: 'attribute_ids', fromJson: attributeIdsFromJson)
  final List<int> attributeIds;

  @JsonKey(defaultValue: [])
  final List<CartAttributeModel> attributes;

  @JsonKey(name: 'personalise_name')
  final String? personaliseName;

  @JsonKey(fromJson: stringToDouble)
  final double price;

  @JsonKey(name: 'stock_quantity', fromJson: stringToIntNullable)
  final int? stockQuantity;

  @JsonKey(fromJson: stringToInt)
  final int quantity;

  @JsonKey(name: 'total_price', fromJson: stringToDouble)
  final double totalPrice;

  CartItemModel({
    required this.id,
    required this.productId,
    this.productVariantId,
    this.productName,
    this.productCode,
    this.productImage,
    this.attributeNameId,
    required this.attributeIds,
    required this.attributes,
    this.personaliseName,
    required this.price,
    this.stockQuantity,
    required this.quantity,
    required this.totalPrice,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);
}

@JsonSerializable()
class CartAttributeModel {
  @JsonKey(name: 'attribute_name')
  final String? attributeName;

  @JsonKey(name: 'attribute_value')
  final String? attributeValue;

  CartAttributeModel({this.attributeName, this.attributeValue});

  factory CartAttributeModel.fromJson(Map<String, dynamic> json) =>
      _$CartAttributeModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartAttributeModelToJson(this);
}

int? stringToIntNullable(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}
