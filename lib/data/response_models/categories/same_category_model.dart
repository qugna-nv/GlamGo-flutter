import 'package:json_annotation/json_annotation.dart';
import 'package:project_shop/data/response_models/products/products_model.dart';

part 'same_category_model.g.dart';

@JsonSerializable()
class SameCategoryModel {
  final int? id;
  final String? name;
  final String? slug;
  final String? image;

  @JsonKey(name: 'image_alt')
  final String? imageAlt;

  @JsonKey(fromJson: stringToDouble)
  final double? price;

  @JsonKey(name: 'price_sale', fromJson: stringToDouble)
  final double? priceSale;

  @JsonKey(name: 'product_images2')
  final ProductImage? productImage;

  SameCategoryModel({
    this.id,
    this.name,
    this.slug,
    this.image,
    this.imageAlt,
    this.price,
    this.priceSale,
    this.productImage,
  });

  factory SameCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$SameCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$SameCategoryModelToJson(this);
}
