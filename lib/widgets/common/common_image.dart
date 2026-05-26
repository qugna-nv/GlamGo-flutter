import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:project_shop/data/secure_storage/share_preference_manager.dart';
import 'package:project_shop/gen/assets.gen.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';
import 'package:project_shop/utils/constant.dart';
import 'package:project_shop/utils/extension/getx_ex.dart';

class CommonImage extends StatelessWidget {
  const CommonImage({
    super.key,
    this.onTap,
    this.asset,
    this.url,
    this.file,
    this.bytes,
    this.height,
    this.width,
    this.borderRadius = BorderRadius.zero,
    this.border,
    this.boxShadow,
    this.margin,
    this.color,
    this.backgroundColor,
    this.fit = BoxFit.cover,
    this.isCircle = false,
    this.isNeedAccessToken = false,
  }) : assert(
          asset == null || asset is AssetGenImage || asset is String,
        );

  final VoidCallback? onTap;

  final dynamic asset;
  final String? url;
  final File? file;
  final List<int>? bytes;

  final double? height;
  final double? width;
  final BorderRadiusGeometry borderRadius;
  final BoxBorder? border;
  final BoxShadow? boxShadow;
  final EdgeInsets? margin;

  final Color? color;
  final Color? backgroundColor;
  final BoxFit fit;
  final bool isCircle;
  final bool isNeedAccessToken;

  @override
  Widget build(BuildContext context) {
    final accessToken = Get.safeFind<SharedPreferencesManager>()
        ?.getString(Constant.KEY_ACCESS_TOKEN);

    Widget image = Assets.images.introImage.image(
      color: color,
      fit: fit,
    );
    final Widget noImage = Assets.images.introImage.image();

    final Widget emptyImage = Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: ColorName.uiElementLightColor,
        borderRadius: borderRadius,
      ),
    );

    if (url != null) {
      image = CachedNetworkImage(
        imageUrl: url!,
        color: color,
        fit: fit,
        placeholder: (_, __) {
          return Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
            ),
          );
        },
        errorWidget: (_, __, ___) => emptyImage,
        httpHeaders: isNeedAccessToken
            ? {
                HttpHeaders.authorizationHeader: 'Bearer $accessToken',
              }
            : null,
      );
    } else if (bytes != null) {
      image = Image.memory(
        Uint8List.fromList(bytes!),
        color: color,
        fit: fit,
        errorBuilder: (_, __, ___) => noImage,
      );
    } else if (file != null) {
      image = Image.file(
        file!,
        color: color,
        fit: fit,
        errorBuilder: (_, __, ___) => noImage,
      );
    } else if (asset is String && asset.endsWith('.svg')) {
      image = SvgPicture.asset(
        asset,
        // ignore: deprecated_member_use
        color: color,
        fit: fit,
      );
    } else if (asset is AssetGenImage) {
      image = (asset as AssetGenImage).image(
        color: color,
        fit: fit,
        errorBuilder: (_, __, ___) => noImage,
      );
    } else {
      image = emptyImage;
    }

    final child = isCircle
        ? ClipOval(
            child: image,
          )
        : ClipRRect(
            borderRadius: borderRadius,
            child: image,
          );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          border: border,
          color: backgroundColor,
          boxShadow: boxShadow != null ? [boxShadow!] : null,
        ),
        margin: margin,
        height: height,
        width: width,
        child: child,
      ),
    );
  }
}
