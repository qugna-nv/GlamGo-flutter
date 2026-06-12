import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_shop/base/util/utils.dart';
import 'package:project_shop/data/response_models/address/address_model.dart';
import 'package:project_shop/features/account/account_detail_controller.dart';
import 'package:project_shop/features/account/widgets/payment_widget.dart';
import 'package:project_shop/gen/assets.gen.dart';
import 'package:project_shop/routes/app_routes.dart';
import 'package:project_shop/widgets/button/normal_button.dart';
import 'package:project_shop/widgets/image_base/base_image_widget.dart';
import 'package:project_shop/widgets/styles_widget/styles_widget.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';

class AccountDetailPage extends GetView<AccountDetailController> {
  const AccountDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin tài khoản'),
        centerTitle: true,
        actions: [
          Obx(
            () => IconButton(
              onPressed: controller.saving.value
                  ? null
                  : controller.isEditing.value
                      ? controller.cancelEdit
                      : controller.startEdit,
              icon: Icon(
                controller.isEditing.value ? Icons.close : Icons.edit_outlined,
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        final user = controller.accountController.user.value;

        if (controller.accountController.isLoading.value && user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!controller.accountController.isAuthenticated.value) {
          return Center(
            child: IButton.primaryNormal(
              title: 'Đăng nhập',
              onPress: () => Get.toNamed(Routes.login),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshUser,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              _ProfileHeader(),
              const SizedBox(height: 16),
              _EditableInfo(),
              const SizedBox(height: 16),
              _WalletInfo(),
              const SizedBox(height: 16),
              _AddressSection(addresses: user?.addresses ?? []),
            ],
          ),
        );
      }),
      bottomNavigationBar: Obx(
        () => controller.isEditing.value
            ? SafeArea(
                minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: IButton.primaryNormal(
                  title:
                      controller.saving.value ? 'Đang lưu...' : 'Lưu thay đổi',
                  onPress:
                      controller.saving.value ? null : controller.saveProfile,
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

class _ProfileHeader extends GetView<AccountDetailController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = controller.accountController.user.value;
      final selectedAvatar = controller.selectedAvatar.value;
      final avatar = user?.avatar;
      final hasRemoteAvatar = avatar != null && avatar.isNotEmpty;
      final isEditing = controller.isEditing.value;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColorName.grey53,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: isEditing ? controller.pickAvatar : null,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: selectedAvatar != null
                        ? Image.file(
                            File(selectedAvatar.path),
                            width: 82,
                            height: 82,
                            fit: BoxFit.cover,
                          )
                        : hasRemoteAvatar
                            ? BaseImageWidget(
                                path: Utils.I.getImageFullPath(avatar),
                                widthImage: 82,
                                heightImage: 82,
                                radius: 999,
                              )
                            : Image.asset(
                                Assets.images.avatar.path,
                                width: 82,
                                height: 82,
                                fit: BoxFit.cover,
                              ),
                  ),
                  if (isEditing)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: ColorName.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.name ?? 'Tài khoản',
                    style: Styles.normalTextW700(size: 18),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    style: Styles.normalText(size: 13, color: ColorName.grey1),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    user?.code ?? '',
                    style: Styles.normalTextW600(size: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _EditableInfo extends GetView<AccountDetailController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = controller.accountController.user.value;
      final isEditing = controller.isEditing.value;

      return _Section(
        title: 'Thông tin cá nhân',
        child: Column(
          children: [
            TextField(
              controller: controller.nameController,
              enabled: isEditing,
              decoration: const InputDecoration(
                labelText: 'Họ tên',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller.phoneController,
              enabled: isEditing,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Số điện thoại',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              enabled: false,
              controller: TextEditingController(text: user?.email ?? ''),
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _WalletInfo extends GetView<AccountDetailController> {
  @override
  Widget build(BuildContext context) {
    final user = controller.accountController.user.value;

    return _Section(
      title: 'Ví tài khoản',
      action: IconButton(
        tooltip: 'Nạp ví',
        onPressed: () async {
          final updated = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const PaymentScreen()),
          );

          if (updated == true) {
            await controller.refreshUser();
          }
        },
        icon: const Icon(Icons.add_card_outlined),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Số dư', style: Styles.normalTextW600(size: 14)),
          Text(
            Utils.I.formatCurrency(user?.walletBalance ?? 0),
            style: Styles.normalTextW700(size: 16),
          ),
        ],
      ),
    );
  }
}

class _AddressSection extends StatelessWidget {
  const _AddressSection({required this.addresses});

  final List<AddressModel> addresses;

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Địa chỉ',
      action: TextButton(
        onPressed: () => Get.toNamed(Routes.addresses),
        child: const Text('Quản lý'),
      ),
      child: addresses.isEmpty
          ? Text(
              'Chưa có địa chỉ nào.',
              style: Styles.normalText(size: 13, color: ColorName.grey1),
            )
          : Column(
              children: addresses
                  .map(
                    (address) => Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: ColorName.grey1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  address.recipientName ?? 'Người nhận',
                                  style: Styles.normalTextW600(size: 14),
                                ),
                              ),
                              if (address.isDefault)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ColorName.black,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    'Mặc định',
                                    style: Styles.normalText(
                                      size: 11,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(address.phone ?? ''),
                          const SizedBox(height: 4),
                          Text(address.addressLine ?? ''),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.child,
    this.action,
  });

  final String title;
  final Widget child;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColorName.grey53,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title, style: Styles.mediumTextW600()),
              ),
              if (action != null) action!,
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
