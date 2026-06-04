// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartModel _$CartModelFromJson(Map<String, dynamic> json) => CartModel(
      id: stringToInt(json['id']),
      code: json['code'] as String?,
      userId: stringToInt(json['user_id']),
      subtotal: stringToDouble(json['subtotal']),
      discount: stringToDouble(json['discount']),
      totalPrice: stringToDouble(json['total_price']),
      totalQuantity: stringToInt(json['total_quantity']),
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$CartModelToJson(CartModel instance) => <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'user_id': instance.userId,
      'subtotal': instance.subtotal,
      'discount': instance.discount,
      'total_price': instance.totalPrice,
      'total_quantity': instance.totalQuantity,
      'items': instance.items,
    };

CartItemModel _$CartItemModelFromJson(Map<String, dynamic> json) =>
    CartItemModel(
      id: stringToInt(json['id']),
      productId: stringToInt(json['product_id']),
      productName: json['product_name'] as String?,
      productCode: json['product_code'] as String?,
      productImage: json['product_image'] as String?,
      attributeNameId: stringToIntNullable(json['attribute_name_id']),
      attributeIds: attributeIdsFromJson(json['attribute_ids']),
      attributes: (json['attributes'] as List<dynamic>?)
              ?.map(
                  (e) => CartAttributeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      personaliseName: json['personalise_name'] as String?,
      price: stringToDouble(json['price']),
      quantity: stringToInt(json['quantity']),
      totalPrice: stringToDouble(json['total_price']),
    );

Map<String, dynamic> _$CartItemModelToJson(CartItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'product_name': instance.productName,
      'product_code': instance.productCode,
      'product_image': instance.productImage,
      'attribute_name_id': instance.attributeNameId,
      'attribute_ids': instance.attributeIds,
      'attributes': instance.attributes,
      'personalise_name': instance.personaliseName,
      'price': instance.price,
      'quantity': instance.quantity,
      'total_price': instance.totalPrice,
    };

CartAttributeModel _$CartAttributeModelFromJson(Map<String, dynamic> json) =>
    CartAttributeModel(
      attributeName: json['attribute_name'] as String?,
      attributeValue: json['attribute_value'] as String?,
    );

Map<String, dynamic> _$CartAttributeModelToJson(CartAttributeModel instance) =>
    <String, dynamic>{
      'attribute_name': instance.attributeName,
      'attribute_value': instance.attributeValue,
    };
