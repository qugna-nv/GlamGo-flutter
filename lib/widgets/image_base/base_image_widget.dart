import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';

class BaseImageWidget extends StatelessWidget {
  const BaseImageWidget({
    super.key,
    this.heightImage,
    this.widthImage,
    required this.path,
    this.cacheKey,
    this.errorWidget,
    this.boxFit,
    this.radius,
  });

  final double? heightImage;
  final double? widthImage;
  final String path;
  final String? cacheKey;
  final Widget? errorWidget;
  final BoxFit? boxFit;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorName.white,
        borderRadius: BorderRadius.circular(radius ?? 12),
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(radius ?? 12),
          child: CachedNetworkImage(
            alignment: Alignment.topCenter,
            cacheKey: cacheKey,
            fadeInDuration: const Duration(seconds: 0),
            fadeOutDuration: const Duration(seconds: 0),
            height: heightImage ?? Get.height,
            width: widthImage ?? Get.width,
            imageUrl: path,
            filterQuality: FilterQuality.low,
            fit: boxFit ?? BoxFit.cover,
            placeholder: (context, url) {
              return Image.asset(
                'assets/images/avatar.png',
              );
            },
            errorWidget: (context, obj, trace) {
              return errorWidget ??
                  Image.asset(
                    'assets/images/avatar.png',
                  );
            },
          )),
    );
  }
}
