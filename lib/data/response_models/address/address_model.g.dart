// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressModel _$AddressModelFromJson(Map<String, dynamic> json) => AddressModel(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      label: json['label'] as String?,
      recipientName: json['recipient_name'] as String?,
      phone: json['phone'] as String?,
      addressLine: json['address_line'] as String?,
      ward: json['ward'] as String?,
      district: json['district'] as String?,
      province: json['province'] as String?,
      country: json['country'] as String?,
      isDefault: json['is_default'] as bool? ?? false,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$AddressModelToJson(AddressModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'label': instance.label,
      'recipient_name': instance.recipientName,
      'phone': instance.phone,
      'address_line': instance.addressLine,
      'ward': instance.ward,
      'district': instance.district,
      'province': instance.province,
      'country': instance.country,
      'is_default': instance.isDefault,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
