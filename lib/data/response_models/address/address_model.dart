import 'package:json_annotation/json_annotation.dart';

part 'address_model.g.dart';

@JsonSerializable()
class AddressModel {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "user_id")
  final int? userId;
  @JsonKey(name: "label")
  final String? label;
  @JsonKey(name: "recipient_name")
  final String? recipientName;
  @JsonKey(name: "phone")
  final String? phone;
  @JsonKey(name: "address_line")
  final String? addressLine;
  @JsonKey(name: "ward")
  final String? ward;
  @JsonKey(name: "district")
  final String? district;
  @JsonKey(name: "province")
  final String? province;
  @JsonKey(name: "country")
  final String? country;
  @JsonKey(name: "is_default", defaultValue: false)
  final bool isDefault;
  @JsonKey(name: "created_at")
  final String? createdAt;
  @JsonKey(name: "updated_at")
  final String? updatedAt;

  AddressModel({
    this.id,
    this.userId,
    this.label,
    this.recipientName,
    this.phone,
    this.addressLine,
    this.ward,
    this.district,
    this.province,
    this.country,
    this.isDefault = false,
    this.createdAt,
    this.updatedAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressModelToJson(this);
}
