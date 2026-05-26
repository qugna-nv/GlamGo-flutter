// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderPaginationModel _$OrderPaginationModelFromJson(
        Map<String, dynamic> json) =>
    OrderPaginationModel(
      currentPage: stringToInt(json['current_page']),
      total: stringToInt(json['total']),
      lastPage: stringToInt(json['last_page']),
      perPage: stringToInt(json['per_page']),
      data: (json['data'] as List<dynamic>?)
              ?.map(
                  (e) => OrderSummaryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$OrderPaginationModelToJson(
        OrderPaginationModel instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'total': instance.total,
      'last_page': instance.lastPage,
      'per_page': instance.perPage,
      'data': instance.data,
    };

OrderSummaryModel _$OrderSummaryModelFromJson(Map<String, dynamic> json) =>
    OrderSummaryModel(
      id: stringToInt(json['id']),
      code: json['code'] as String?,
      totalPrice: stringToDouble(json['total_price']),
      paymentMethod: stringToInt(json['payment_method']),
      paymentStatus: stringToInt(json['payment_status']),
      status: stringToInt(json['status']),
      itemsCount: stringToInt(json['items_count']),
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$OrderSummaryModelToJson(OrderSummaryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'total_price': instance.totalPrice,
      'payment_method': instance.paymentMethod,
      'payment_status': instance.paymentStatus,
      'status': instance.status,
      'items_count': instance.itemsCount,
      'created_at': instance.createdAt,
    };

OrderDetailModel _$OrderDetailModelFromJson(Map<String, dynamic> json) =>
    OrderDetailModel(
      id: stringToInt(json['id']),
      code: json['code'] as String?,
      subtotal: stringToDouble(json['subtotal']),
      discount: stringToDouble(json['discount']),
      totalPrice: stringToDouble(json['total_price']),
      paymentMethod: stringToInt(json['payment_method']),
      paymentStatus: stringToInt(json['payment_status']),
      status: stringToInt(json['status']),
      couponCode: json['coupon_code'] as String?,
      customer: json['customer'] == null
          ? null
          : OrderCustomerModel.fromJson(
              json['customer'] as Map<String, dynamic>),
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$OrderDetailModelToJson(OrderDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'subtotal': instance.subtotal,
      'discount': instance.discount,
      'total_price': instance.totalPrice,
      'payment_method': instance.paymentMethod,
      'payment_status': instance.paymentStatus,
      'status': instance.status,
      'coupon_code': instance.couponCode,
      'customer': instance.customer,
      'items': instance.items,
      'created_at': instance.createdAt,
    };

OrderCustomerModel _$OrderCustomerModelFromJson(Map<String, dynamic> json) =>
    OrderCustomerModel(
      email: json['email'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      phoneNumber: json['phone_number'] as String?,
      address: json['address'] as String?,
      postalCode: json['postal_code'] as String?,
      countryId: stringToInt(json['country_id']),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$OrderCustomerModelToJson(OrderCustomerModel instance) =>
    <String, dynamic>{
      'email': instance.email,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'phone_number': instance.phoneNumber,
      'address': instance.address,
      'postal_code': instance.postalCode,
      'country_id': instance.countryId,
      'note': instance.note,
    };

OrderItemModel _$OrderItemModelFromJson(Map<String, dynamic> json) =>
    OrderItemModel(
      id: stringToInt(json['id']),
      productId: stringToInt(json['product_id']),
      productName: json['product_name'] as String?,
      productCode: json['product_code'] as String?,
      productImage: json['product_image'] as String?,
      price: stringToDouble(json['price']),
      quantity: stringToInt(json['quantity']),
      totalPrice: stringToDouble(json['total_price']),
      attributeNameId: stringToIntNullable(json['attribute_name_id']),
      attributeName: json['attribute_name'] as String?,
      attributes: (json['attributes'] as List<dynamic>?)
              ?.map((e) =>
                  OrderAttributeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      personaliseName: json['personalise_name'] as String?,
    );

Map<String, dynamic> _$OrderItemModelToJson(OrderItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'product_name': instance.productName,
      'product_code': instance.productCode,
      'product_image': instance.productImage,
      'price': instance.price,
      'quantity': instance.quantity,
      'total_price': instance.totalPrice,
      'attribute_name_id': instance.attributeNameId,
      'attribute_name': instance.attributeName,
      'attributes': instance.attributes,
      'personalise_name': instance.personaliseName,
    };

OrderAttributeModel _$OrderAttributeModelFromJson(Map<String, dynamic> json) =>
    OrderAttributeModel(
      attributeId: stringToInt(json['attribute_id']),
      attributeName: json['attribute_name'] as String?,
      attributeValueId: stringToInt(json['attribute_value_id']),
      attributeValue: json['attribute_value'] as String?,
    );

Map<String, dynamic> _$OrderAttributeModelToJson(
        OrderAttributeModel instance) =>
    <String, dynamic>{
      'attribute_id': instance.attributeId,
      'attribute_name': instance.attributeName,
      'attribute_value_id': instance.attributeValueId,
      'attribute_value': instance.attributeValue,
    };
