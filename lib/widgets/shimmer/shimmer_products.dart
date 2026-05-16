import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:project_shop/gen/colors.gen.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerProducts extends StatelessWidget {
  const ShimmerProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorName.grey16,
      child: Shimmer.fromColors(
        baseColor: ColorName.grey3,
        highlightColor: ColorName.grey28,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 6),
            child: Column(
              children: [
                ShimmerBox(
                  width: Get.width * 0.9,
                  height: 70,
                ),
                SizedBox(height: 12),
                ShimmerBox(
                    width: Get.width * 0.9, height: 200, borderRadius: 24),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(4, (index) {
                    return Row(
                      children: [
                        ShimmerBox(width: 84, height: 40, borderRadius: 16),
                        if (index < 5) SizedBox(width: 8),
                      ],
                    );
                  }).expand((element) => element.children).toList(),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerBox(
                        width: Get.width * 0.6, height: 30, borderRadius: 12),
                    ShimmerBox(
                        width: Get.width * 0.3, height: 30, borderRadius: 12),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerBox(
                        width: Get.width * 0.45, height: 220, borderRadius: 12),
                    ShimmerBox(
                        width: Get.width * 0.45, height: 220, borderRadius: 12),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerBox(
                        width: Get.width * 0.45, height: 90, borderRadius: 12),
                    ShimmerBox(
                        width: Get.width * 0.45, height: 90, borderRadius: 12),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Color? color;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color ?? const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
