import 'package:json_annotation/json_annotation.dart';

part 'i_address_model.g.dart';

@JsonSerializable()
class IAddress {
  final String? country;
  final String? state; // Tỉnh/Thành phố
  final String? ward; // Phường/Xã
  final String? detail; // Địa chỉ chi tiết
  final double? latitude;
  final double? longitude;

  const IAddress({
    this.country,
    this.state,
    this.ward,
    this.detail,
    this.latitude,
    this.longitude,
  });

  factory IAddress.fromJson(Map<String, dynamic> json) =>
      _$IAddressFromJson(json);

  Map<String, dynamic> toJson() => _$IAddressToJson(this);

  String get fullAddress {
    return [
      detail,
      ward,
      state,
      country,
    ].where((e) => e != null && e.isNotEmpty).join(', ');
  }
}
