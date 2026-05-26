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

  @JsonKey(name: 'personalise_name')
  final String? personaliseName;

  @JsonKey(fromJson: stringToDouble)
  final double price;

  @JsonKey(fromJson: stringToInt)
  final int quantity;

  @JsonKey(name: 'total_price', fromJson: stringToDouble)
  final double totalPrice;

  CartItemModel({
    required this.id,
    required this.productId,
    this.productName,
    this.productCode,
    this.productImage,
    this.attributeNameId,
    required this.attributeIds,
    this.personaliseName,
    required this.price,
    required this.quantity,
    required this.totalPrice,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);
}

int? stringToIntNullable(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}
