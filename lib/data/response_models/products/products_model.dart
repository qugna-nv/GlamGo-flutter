import 'package:json_annotation/json_annotation.dart';
import 'package:project_shop/data/response_models/categories/category_model.dart';
import 'package:project_shop/data/response_models/categories/same_category_model.dart';
import 'package:project_shop/data/response_models/products/product_attribute_model.dart';

part 'products_model.g.dart';

double stringToDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0.0;
}

@JsonSerializable()
class ProductsModel {
  final int? id;

  @JsonKey(name: 'category_id')
  final int? categoryId;

  final String? name;

  final String? code;

  final String? slug;

  @JsonKey(fromJson: stringToDouble)
  final double? price;

  @JsonKey(name: 'price_sale', fromJson: stringToDouble)
  final double? priceSale;

  @JsonKey(name: 'import_price', fromJson: stringToDouble)
  final double? importPrice;

  final int? features;

  @JsonKey(name: 'meta_title')
  final String? metaTitle;

  @JsonKey(name: 'meta_description')
  final String? metaDescription;

  @JsonKey(name: 'attribute_description')
  final String? attributeDescription;

  final String? hashtag;

  final String? image;

  @JsonKey(name: 'image_alt')
  final String? imageAlt;

  final int? status;

  @JsonKey(name: 'is_recommen')
  final int? isRecommen;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  final CategoryModel? category;

  @JsonKey(name: 'product_images')
  final List<ProductImage>? productImages;

  final List<ProductAttributeModel>? attribute;

  @JsonKey(name: 'sameCategory')
  final List<SameCategoryModel>? sameCategory;

  ProductsModel({
    this.id,
    this.categoryId,
    this.name,
    this.code,
    this.slug,
    this.price,
    this.priceSale,
    this.importPrice,
    this.features,
    this.metaTitle,
    this.metaDescription,
    this.attributeDescription,
    this.hashtag,
    this.image,
    this.imageAlt,
    this.status,
    this.isRecommen,
    this.createdAt,
    this.updatedAt,
    this.category,
    this.productImages,
    this.attribute,
    this.sameCategory,
  });

  factory ProductsModel.fromJson(Map<String, dynamic> json) =>
      _$ProductsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductsModelToJson(this);
}

@JsonSerializable()
class ProductImage {
  final int? id;

  @JsonKey(name: 'product_id')
  final int? productId;

  final String? image;

  @JsonKey(name: 'image_alt')
  final String? imageAlt;

  ProductImage({
    this.id,
    this.productId,
    this.image,
    this.imageAlt,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) =>
      _$ProductImageFromJson(json);

  Map<String, dynamic> toJson() => _$ProductImageToJson(this);
}
