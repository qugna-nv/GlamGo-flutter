import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_shop/features/onboarding/onboarding_controller.dart';
import 'package:project_shop/gen/assets.gen.dart';
import 'package:project_shop/gen/colors.gen.dart';
import 'package:project_shop/widgets/button/normal_button.dart';
import 'package:project_shop/widgets/styles_widget/styles_widget.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Obx(() {
          return Stack(
            children: [
              PageView(
                controller: controller.pageController,
                onPageChanged: controller.onChangePage,
                children: [
                  OnboardingPage(
                    title: 'Chào mừng đến với ShopStyle',
                    image: Assets.images.onboarding1.path,
                    describe:
                        'Khám phá hàng ngàn sản phẩm thời trang xu hướng mới nhất',
                  ),
                  OnboardingPage(
                    image: Assets.images.onboarding2.path,
                    title: 'Lọc và tìm kiếm thông minh',
                    describe:
                        'Dễ dàng tìm thấy món đồ yêu thích của bạn với bộ lọc đa dạng',
                    topShapeColor: ColorName.orange13.withAlpha(80),
                    bottomShapeColor: ColorName.orangeChart.withAlpha(80),
                  ),
                  OnboardingPage(
                    image: Assets.images.onboarding3.path,
                    title: 'Thanh toán Nhanh chóng & Bảo mật',
                    describe:
                        'Mua sắm an toàn với nhiều phương thức thanh toán linh hoạt và bảo mật',
                  ),
                ],
              ),
              Positioned(
                top: 20,
                right: 20,
                child: GestureDetector(
                  onTap: () {
                    controller.skipPage();
                  },
                  child: controller.initialIndex.value == 2
                      ? SizedBox()
                      : Text(
                          'Skip',
                          style: Styles.normalTextW600(color: ColorName.purple),
                        ),
                ),
              ),
              Positioned(
                  bottom: 50,
                  left: 20,
                  right: 20,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                          (index) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: controller.initialIndex.value == index
                                  ? 10
                                  : 6,
                              height: controller.initialIndex.value == index
                                  ? 10
                                  : 6,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 6),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: controller.initialIndex.value == index
                                    ? ColorName.black
                                    : ColorName.grey50,
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 12),
                      Obx(() {
                        return IButton.primaryNormal(
                          title: controller.isLastPage.value
                              ? 'Get Started'
                              : 'Next',
                          height: 46,
                          radius: 50,
                          onPress: () {
                            controller.getStarted();
                          },
                          backgroundColor: controller.isLastPage.value
                              ? ColorName.black
                              : ColorName.grey53,
                          isDisable: false,
                          textColor: controller.isLastPage.value
                              ? ColorName.white
                              : ColorName.black,
                        );
                      }),
                    ],
                  )),
            ],
          );
        }),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    this.image,
    this.title,
    this.describe,
    this.topShapeColor = const Color(0xFFE3EDFB),
    this.bottomShapeColor = const Color(0xFFE3EDFB),
  });

  final String? title, describe, image;
  final Color topShapeColor;
  final Color bottomShapeColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 250, 255),
      body: Stack(
        children: [
          Positioned(
            top: -Get.height * 0.1,
            right: -Get.width * 0.2,
            child: Container(
              width: Get.width * 0.6,
              height: Get.width * 0.6,
              decoration: BoxDecoration(
                color: topShapeColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -Get.height * 0.15,
            left: -Get.width * 0.2,
            child: Container(
              width: Get.width * 0.8,
              height: Get.width * 1.2,
              decoration: BoxDecoration(
                color: bottomShapeColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: Get.height * 0.08),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Image.asset(
                    image ?? Assets.images.introImage.path,
                    fit: BoxFit.contain,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title ?? "Chào mừng đến ShopStyle!",
                        style: Styles.bigText().copyWith(
                            fontSize: 28.sp, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        describe ??
                            "Khám phá hàng ngàn sản phẩm thời trang xu hướng mới nhất.",
                        style: Styles.normalTextW400(size: 16.sp),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
