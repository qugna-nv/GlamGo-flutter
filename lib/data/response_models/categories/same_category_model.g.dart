// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'same_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SameCategoryModel _$SameCategoryModelFromJson(Map<String, dynamic> json) =>
    SameCategoryModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      image: json['image'] as String?,
      imageAlt: json['image_alt'] as String?,
      price: stringToDouble(json['price']),
      priceSale: stringToDouble(json['price_sale']),
      productImage: json['product_images2'] == null
          ? null
          : ProductImage.fromJson(
              json['product_images2'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SameCategoryModelToJson(SameCategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'image': instance.image,
      'image_alt': instance.imageAlt,
      'price': instance.price,
      'price_sale': instance.priceSale,
      'product_images2': instance.productImage,
    };
