// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'i_address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IAddress _$IAddressFromJson(Map<String, dynamic> json) => IAddress(
      country: json['country'] as String?,
      state: json['state'] as String?,
      ward: json['ward'] as String?,
      detail: json['detail'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$IAddressToJson(IAddress instance) => <String, dynamic>{
      'country': instance.country,
      'state': instance.state,
      'ward': instance.ward,
      'detail': instance.detail,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
