import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:project_shop/gen/colors.gen.dart';
import 'package:project_shop/widgets/shimmer/shimmer_products.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerProductDetail extends StatelessWidget {
  const ShimmerProductDetail({super.key});

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
                    width: Get.width * 0.9, height: 320, borderRadius: 24),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    return Row(
                      children: [
                        ShimmerBox(width: 80, height: 80, borderRadius: 16),
                        if (index < 5) SizedBox(width: 8),
                      ],
                    );
                  }).expand((element) => element.children).toList(),
                ),
                SizedBox(height: 12),
                ShimmerBox(
                    width: Get.width * 0.9, height: 240, borderRadius: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
