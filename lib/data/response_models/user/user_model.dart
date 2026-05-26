import 'package:json_annotation/json_annotation.dart';
import 'package:project_shop/data/response_models/address/address_model.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "code")
  final String? code;
  @JsonKey(name: "user_name")
  final String? userName;
  @JsonKey(name: "email")
  final String? email;
  @JsonKey(name: "phone")
  final String? phone;
  @JsonKey(name: "avatar")
  final String? avatar;
  @JsonKey(name: "address")
  final String? address;
  @JsonKey(name: "contry_id")
  final int? contryId;
  @JsonKey(name: "status_id")
  final int? statusId;
  @JsonKey(name: "google_id")
  final String? googleId;
  @JsonKey(name: "created_at")
  final String? createdAt;
  @JsonKey(name: "updated_at")
  final String? updatedAt;
  @JsonKey(name: "is_admin")
  final int? isAdmin;
  @JsonKey(name: "role")
  final String? role;
  @JsonKey(name: "addresses")
  final List<AddressModel>? addresses;

  UserModel({
    this.id,
    this.name,
    this.code,
    this.userName,
    this.email,
    this.phone,
    this.avatar,
    this.address,
    this.contryId,
    this.statusId,
    this.googleId,
    this.createdAt,
    this.updatedAt,
    this.isAdmin,
    this.role,
    this.addresses,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
