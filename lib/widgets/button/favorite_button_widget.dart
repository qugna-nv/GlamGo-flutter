import 'package:flutter/material.dart';

class FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onTap;
  final double size;
  final double padding;

  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onTap,
    this.size = 40.0,
    this.padding = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(padding),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white, // Hoặc ColorName.white
          borderRadius: BorderRadius.circular(size > 0 ? size * 1.5 : 55),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(1, 3),
            ),
          ],
        ),
        child: isFavorite
            ? Image.asset(
                "assets/images/ic_heart_fill.png", // Thay bằng Assets.images.icHeartFill.path
                color: Colors.red, // Hoặc ColorName.red5
              )
            : Image.asset(
                "assets/images/ic_heart.png", // Thay bằng Assets.images.icHeart.path
              ),
      ),
    );
  }
}
