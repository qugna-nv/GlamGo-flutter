import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_shop/features/splash/splash_controller.dart';
import 'package:project_shop/gen/assets.gen.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';
import 'package:project_shop/widgets/styles_widget/styles_widget.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return Container(
          color: ColorName.yellow,
          padding: EdgeInsets.all(24),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                    animation: controller.animationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: controller.scaleAnimation.value,
                        child: FadeTransition(
                          opacity: controller.fadeAnimation,
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: ColorName.yellow,
                                borderRadius: BorderRadius.circular(999)
                                // shape: BoxShape.circle,
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: ColorName.black.withOpacity(0.1),
                                //     blurRadius: 20,
                                //     offset: const Offset(0, 10),
                                //   )
                                // ],
                                ),
                            child: Image.asset(
                              Assets.images.storeLogo.path,
                              width: 110,
                              height: 110,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    }),
                SizedBox(
                  height: 10,
                ),
                AnimatedBuilder(
                    animation: controller.animationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: controller.scaleAnimation.value,
                        child: FadeTransition(
                            opacity: controller.fadeAnimation,
                            child: Column(
                              children: [
                                Text(
                                  'Jin Store Shop',
                                  style: Styles.normalTextBold(
                                      size: 26, color: ColorName.brown),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Your Premium Shopping Experience',
                                  style: Styles.normalTextW500(
                                      size: 16, color: ColorName.brown),
                                ),
                              ],
                            )),
                      );
                    }),
                SizedBox(height: 30),
                SizedBox(
                  width: 200,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: controller.loadingProgress.value,
                          backgroundColor: ColorName.white.withOpacity(0.2),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              ColorName.red5),
                          minHeight: 6,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        '${(controller.loadingProgress.value * 100).toInt()}%',
                        style: Styles.normalTextW500(
                            size: 16, color: ColorName.red5),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
