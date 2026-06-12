// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductsModel _$ProductsModelFromJson(Map<String, dynamic> json) =>
    ProductsModel(
      id: (json['id'] as num?)?.toInt(),
      categoryId: (json['category_id'] as num?)?.toInt(),
      name: json['name'] as String?,
      code: json['code'] as String?,
      slug: json['slug'] as String?,
      price: stringToDouble(json['price']),
      priceSale: stringToDouble(json['price_sale']),
      importPrice: stringToDouble(json['import_price']),
      features: (json['features'] as num?)?.toInt(),
      metaTitle: json['meta_title'] as String?,
      metaDescription: json['meta_description'] as String?,
      attributeDescription: json['attribute_description'] as String?,
      hashtag: json['hashtag'] as String?,
      image: json['image'] as String?,
      imageAlt: json['image_alt'] as String?,
      status: (json['status'] as num?)?.toInt(),
      isRecommen: (json['is_recommen'] as num?)?.toInt(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      category: json['category'] == null
          ? null
          : CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
      productImages: (json['product_images'] as List<dynamic>?)
          ?.map((e) => ProductImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      attribute: (json['attribute'] as List<dynamic>?)
          ?.map(
              (e) => ProductAttributeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      sameCategory: (json['sameCategory'] as List<dynamic>?)
          ?.map((e) => SameCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      variants: (json['variants'] as List<dynamic>?)
              ?.map((e) =>
                  ProductVariantModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$ProductsModelToJson(ProductsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category_id': instance.categoryId,
      'name': instance.name,
      'code': instance.code,
      'slug': instance.slug,
      'price': instance.price,
      'price_sale': instance.priceSale,
      'import_price': instance.importPrice,
      'features': instance.features,
      'meta_title': instance.metaTitle,
      'meta_description': instance.metaDescription,
      'attribute_description': instance.attributeDescription,
      'hashtag': instance.hashtag,
      'image': instance.image,
      'image_alt': instance.imageAlt,
      'status': instance.status,
      'is_recommen': instance.isRecommen,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'category': instance.category,
      'product_images': instance.productImages,
      'attribute': instance.attribute,
      'sameCategory': instance.sameCategory,
      'variants': instance.variants,
    };

ProductVariantModel _$ProductVariantModelFromJson(Map<String, dynamic> json) =>
    ProductVariantModel(
      id: (json['id'] as num?)?.toInt(),
      productId: (json['product_id'] as num?)?.toInt(),
      sku: json['sku'] as String?,
      price: stringToDouble(json['price']),
      quantity: (json['quantity'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      attributeIds: (json['attribute_ids'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [],
      attributes: (json['attributes'] as List<dynamic>?)
              ?.map((e) => ProductVariantAttributeModel.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$ProductVariantModelToJson(
        ProductVariantModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'sku': instance.sku,
      'price': instance.price,
      'quantity': instance.quantity,
      'status': instance.status,
      'attribute_ids': instance.attributeIds,
      'attributes': instance.attributes,
    };

ProductVariantAttributeModel _$ProductVariantAttributeModelFromJson(
        Map<String, dynamic> json) =>
    ProductVariantAttributeModel(
      attributeId: (json['attribute_id'] as num?)?.toInt(),
      attributeName: json['attribute_name'] as String?,
      attributeValueId: (json['attribute_value_id'] as num?)?.toInt(),
      attributeValue: json['attribute_value'] as String?,
    );

Map<String, dynamic> _$ProductVariantAttributeModelToJson(
        ProductVariantAttributeModel instance) =>
    <String, dynamic>{
      'attribute_id': instance.attributeId,
      'attribute_name': instance.attributeName,
      'attribute_value_id': instance.attributeValueId,
      'attribute_value': instance.attributeValue,
    };

ProductImage _$ProductImageFromJson(Map<String, dynamic> json) => ProductImage(
      id: (json['id'] as num?)?.toInt(),
      productId: (json['product_id'] as num?)?.toInt(),
      image: json['image'] as String?,
      imageAlt: json['image_alt'] as String?,
    );

Map<String, dynamic> _$ProductImageToJson(ProductImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'image': instance.image,
      'image_alt': instance.imageAlt,
    };
