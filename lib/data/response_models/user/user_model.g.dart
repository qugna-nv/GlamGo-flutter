// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      code: json['code'] as String?,
      userName: json['user_name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      address: json['address'] as String?,
      contryId: (json['contry_id'] as num?)?.toInt(),
      statusId: (json['status_id'] as num?)?.toInt(),
      googleId: json['google_id'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      isAdmin: (json['is_admin'] as num?)?.toInt(),
      role: json['role'] as String?,
      addresses: (json['addresses'] as List<dynamic>?)
          ?.map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'user_name': instance.userName,
      'email': instance.email,
      'phone': instance.phone,
      'avatar': instance.avatar,
      'address': instance.address,
      'contry_id': instance.contryId,
      'status_id': instance.statusId,
      'google_id': instance.googleId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'is_admin': instance.isAdmin,
      'role': instance.role,
      'addresses': instance.addresses,
    };
