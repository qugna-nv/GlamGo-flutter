import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';
import 'package:project_shop/widgets/button/favorite_button_widget.dart';

class ProductsImageWidget extends StatelessWidget {
  const ProductsImageWidget({
    super.key,
    this.heightImage,
    this.widthImage,
    this.onTap,
    required this.path,
    this.icon,
    this.cacheKey,
    this.errorWidget,
    this.iconSize,
    this.boxFit,
    this.bgrColor,
    this.colorIcon,
    this.isWishList = false,
  });

  final double? heightImage;
  final double? widthImage;
  final VoidCallback? onTap;
  final double? iconSize;
  final String path;
  final String? icon;
  final String? cacheKey;
  final Widget? errorWidget;
  final BoxFit? boxFit;
  final Color? bgrColor, colorIcon;
  final bool isWishList;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: ColorName.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
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
                    'assets/images/img_placeholder.png',
                  );
                },
                errorWidget: (context, obj, trace) {
                  return errorWidget ??
                      Image.asset(
                        'assets/images/img_placeholder.png',
                      );
                },
              )),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: FavoriteButton(
              isFavorite: isWishList,
              onTap: () {
                if (onTap != null) onTap!();
              }),
        ),
      ],
    );
  }
}
