import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_shop/features/account/account_controller.dart';
import 'package:project_shop/gen/assets.gen.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';
import 'package:project_shop/routes/app_routes.dart';
import 'package:project_shop/widgets/appbar_custom/custom_app_bar.dart';
import 'package:project_shop/widgets/icon_widget/icon_widget.dart';
import 'package:project_shop/widgets/inkwell/default_ink_well.dart';
import 'package:project_shop/widgets/shimmer/shimmer_products.dart';
import 'package:project_shop/widgets/simple_rows/simple_row_widget.dart';
import 'package:project_shop/widgets/styles_widget/styles_widget.dart';

class AccountPage extends GetView<AccountController> {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          label: 'Thiết lập',
          showBackButton: false,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 16.w),
              _userInfo(),
              SizedBox(
                height: 16.w,
              ),
              _cardAccount(),
              SizedBox(height: 16.w),
              _cardSupport(),
              SizedBox(height: 16.w),
              // IButton.primaryNormal(
              //   contentPadding: EdgeInsets.symmetric(horizontal: 28.w),
              //   title: 'Đăng xuất'.tr,
              //   onPress: () {
              //// mainController?.logout();
              //   },
              //   iconFirst: Assets.icons.icLogout,
              // ),
              // SizedBox(
              //   height: 32.w,
              // )
            ],
          ),
        ),
      ),
    );
  }

  Widget _userInfo() {
    return Obx(() {
      final user = controller.user.value;
      final isLoading = controller.isLoading.value;
      final isAuthenticated = controller.isAuthenticated.value;
      final hasError = controller.errorMessage.value.isNotEmpty;
      final name = user?.name ??
          (isAuthenticated ? 'Tai khoan cua ban' : 'Ban chua dang nhap');
      final detail = user?.email ??
          (hasError
              ? controller.errorMessage.value
              : isAuthenticated
                  ? 'Dang tai thong tin...'
                  : 'Dang nhap de xem thong tin');

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        height: 100,
        decoration: BoxDecoration(
            color: ColorName.grey53, borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                      height: 60,
                      width: 60,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          border: Border.all(color: ColorName.grey10),
                          borderRadius: BorderRadius.circular(999)),
                      child: Image.asset(Assets.images.avatar.path)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          style: Styles.normalTextW700(size: 14.sp),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          detail,
                          style: Styles.normalTextW400(size: 14.sp),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (!isLoading)
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: ColorName.white,
                    borderRadius: BorderRadius.circular(24)),
                child: DefaultInkWell(
                    child: IconWidget.ic24(path: Assets.icons.icEditDocument),
                    onTap: () {}),
              )
          ],
        ),
      );
    });
  }

  Widget _cardSupport() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.w, horizontal: 12.w),
      decoration: BoxDecoration(
        color: ColorName.grey53,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Support'.tr, style: Styles.mediumTextW600()),
          SizedBox(height: 12.w),
          SimpleRowWidget(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            contentFirst: 'Contact Us'.tr,
            onTap: () {
              if (!controller.isAuthenticated.value) {
                Get.toNamed(Routes.login, arguments: {'redirect': Routes.chat});
                return;
              }

              Get.toNamed(Routes.chat);
            },
            imageFirst: Assets.icons.icContactBook,
          ),
          SimpleRowWidget(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            contentFirst: 'Help and information'.tr,
            onTap: () {},
            imageFirst: Assets.icons.icInformation,
          ),
          SimpleRowWidget(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            contentFirst: 'Feedbcak'.tr,
            onTap: () {
              Get.toNamed(Routes.login);
            },
            imageFirst: Assets.icons.icSend,
          ),
          // SimpleRowWidget(
          //   contentFirst: 'passWord'.tr,
          //   onTap: () {},
          //   imageFirst: Assets.icons.icHomeOutlined,
          //   widget: CommonSwitch(
          //     // value: controller.biometric,
          //     enableColor: ColorName.red5,
          //     disableColor: ColorName.grey34.withOpacity(0.16),
          //     onChanged: (value) {
          //       // controller.onSettingAccountBiometrics(
          //       //     isEnable: value);
          //     },
          //     width: 45.w,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _cardAccount() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.w, horizontal: 12.w),
      decoration: BoxDecoration(
        color: ColorName.grey53,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Account'.tr, style: Styles.mediumTextW600()),
          SizedBox(height: 12.w),
          SimpleRowWidget(
            contentFirst: 'Account Details'.tr,
            onTap: () {
              Navigator.push(Get.context!,
                  MaterialPageRoute(builder: (context) => ShimmerProducts()));
            },
            imageFirst: Assets.icons.icUser,
          ),
          SimpleRowWidget(
            contentFirst: 'Notification'.tr,
            onTap: () {},
            imageFirst: Assets.icons.icNotification,
          ),
          SimpleRowWidget(
            contentFirst: 'Order'.tr,
            onTap: () {
              Get.toNamed(Routes.orders);
            },
            imageFirst: Assets.icons.icShoppingBag,
          ),
          SimpleRowWidget(
            contentFirst: 'Location Services'.tr,
            onTap: () {
              if (!controller.isAuthenticated.value) {
                Get.toNamed(Routes.login,
                    arguments: {'redirect': Routes.addresses});
                return;
              }

              Get.toNamed(Routes.addresses);
            },
            imageFirst: Assets.icons.icLocation,
          ),
          SimpleRowWidget(
            contentFirst: 'Delete Account'.tr,
            onTap: () {},
            imageFirst: Assets.icons.icDeleteTableV1,
          ),
          Obx(() => SimpleRowWidget(
                contentFirst:
                    (controller.isAuthenticated.value ? 'Logout' : 'Login').tr,
                onTap: () async {
                  if (!controller.isAuthenticated.value) {
                    Get.toNamed(Routes.login);
                    return;
                  }

                  await controller.logout();
                  Get.offAllNamed(Routes.initPage);
                },
                imageFirst: Assets.icons.icPower,
              )),
        ],
      ),
    );
  }
}
