import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';

class BaseAvatar extends StatelessWidget {
  const BaseAvatar({
    super.key,
    required this.src,
    this.size,
    this.errorWidget,
    this.colorBorder,
    this.cacheKey,
  });

  final String src;
  final double? size;
  final Widget? errorWidget;
  final Color? colorBorder;
  final String? cacheKey;

  @override
  Widget build(BuildContext context) {
    final imgSize = size ?? 50.w;
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: colorBorder ?? ColorName.backgroundTablet, width: 1.5.w)),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(9999),
          child: CachedNetworkImage(
            alignment: Alignment.topCenter,
            cacheKey: cacheKey,
            fadeInDuration: const Duration(seconds: 0),
            fadeOutDuration: const Duration(seconds: 0),
            width: imgSize,
            height: imgSize,
            filterQuality: FilterQuality.low,
            imageUrl: src,
            fit: BoxFit.cover,
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
