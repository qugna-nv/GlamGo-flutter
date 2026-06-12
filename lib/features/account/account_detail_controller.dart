import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_shop/base/base_controller.dart';
import 'package:project_shop/data/api_service/api_service.dart';
import 'package:project_shop/features/account/account_controller.dart';
import 'package:project_shop/widgets/appbar_custom/common_snackbar.dart';
import 'package:project_shop/widgets/common/toast_widget.dart';

class AccountDetailController extends BaseController {
  final ApiService apiService = Get.find();
  final AccountController accountController = Get.find();
  final ImagePicker _picker = ImagePicker();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final Rxn<XFile> selectedAvatar = Rxn<XFile>();
  final RxBool isEditing = false.obs;
  final RxBool saving = false.obs;

  @override
  void onInit() {
    super.onInit();
    _syncFields();
    ever(accountController.user, (_) => _syncFields());
  }

  Future<void> refreshUser() => accountController.loadCurrentUser();

  Future<void> pickAvatar() async {
    if (!isEditing.value) return;

    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1200,
    );

    if (image != null) {
      selectedAvatar.value = image;
    }
  }

  Future<void> saveProfile() async {
    saving.value = true;
    try {
      final avatar = selectedAvatar.value == null
          ? null
          : File(selectedAvatar.value!.path);

      final response = await apiService.updateProfile(
        nameController.text.trim(),
        phoneController.text.trim(),
        avatar,
      );

      accountController.user.value = response.data;
      selectedAvatar.value = null;
      isEditing.value = false;
      _showToast(ToastStatus.success,
          'Cập nhật thông tin tài khoản thành công.', 'Thành công');
    } catch (error) {
      _showToast(ToastStatus.fail, _getErrorMessage(error), 'Thất bại');
    } finally {
      saving.value = false;
    }
  }

  void _syncFields() {
    final user = accountController.user.value;
    nameController.text = user?.name ?? '';
    phoneController.text = user?.phone ?? '';
  }

  void startEdit() {
    isEditing.value = true;
  }

  void cancelEdit() {
    selectedAvatar.value = null;
    _syncFields();
    isEditing.value = false;
  }

  void _showToast(ToastStatus status, String message, String title) {
    final context = Get.context;
    if (context == null || !Get.isRegistered<ToastWidget>()) return;

    Get.find<ToastWidget>().showToast(
      context,
      toastStatus: status,
      description: message,
      title: title,
    );
  }

  String _getErrorMessage(Object error) {
    if (error is dio.DioException) {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        return data['message']?.toString() ?? 'Co loi xay ra.';
      }
    }

    return 'Co loi xay ra.';
  }

  @override
  void onClose() {
    super.onClose();
  }
}
