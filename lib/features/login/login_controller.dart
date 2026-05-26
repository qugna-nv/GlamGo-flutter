import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:project_shop/base/base_controller.dart';
import 'package:project_shop/data/api_service/api_service.dart';
import 'package:project_shop/data/secure_storage/secure_storage.dart';
import 'package:project_shop/routes/app_routes.dart';

class LoginController extends BaseController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final ApiService apiService = Get.find();
  final SecureStorage secureStorage = Get.find();
  final RxBool isRegisterMode = false.obs;

  Future<void> login() async {
    if (!_validateLogin()) return;

    isLoading.value = true;
    try {
      final response = await apiService.login({
        'email': emailController.text.trim(),
        'password': passwordController.text,
      });
      final token = response.data?.token;

      if (token == null || token.isEmpty) {
        Get.snackbar('Loi', 'Khong nhan duoc token dang nhap.');
        return;
      }

      await secureStorage.saveTokens(token);
      _goAfterAuth();
    } catch (error) {
      Get.snackbar('Dang nhap that bai', _getErrorMessage(error));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    if (!_validateRegister()) return;

    isLoading.value = true;
    try {
      final response = await apiService.register({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'password': passwordController.text,
        'password_confirmation': confirmPasswordController.text,
      });
      final token = response.data?.token;

      if (token == null || token.isEmpty) {
        Get.snackbar('Loi', 'Khong nhan duoc token dang ky.');
        return;
      }

      await secureStorage.saveTokens(token);
      _goAfterAuth();
    } catch (error) {
      Get.snackbar('Dang ky that bai', _getErrorMessage(error));
    } finally {
      isLoading.value = false;
    }
  }

  void submit() {
    isRegisterMode.value ? register() : login();
  }

  void goToRegister() {
    isRegisterMode.toggle();
  }

  void _goAfterAuth() {
    final args = Get.arguments;
    final redirect = args is Map ? args['redirect']?.toString() : null;

    if (redirect != null && redirect.isNotEmpty) {
      Get.offNamed(redirect);
      return;
    }

    Get.offAllNamed(Routes.initPage);
  }

  bool _validateLogin() {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar('Thong bao', 'Vui long nhap email va mat khau.');
      return false;
    }
    return true;
  }

  bool _validateRegister() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar('Thong bao', 'Vui long nhap ho ten.');
      return false;
    }

    if (!_validateLogin()) return false;

    if (phoneController.text.trim().isEmpty) {
      Get.snackbar('Thong bao', 'Vui long nhap so dien thoai.');
      return false;
    }

    if (passwordController.text.length < 6) {
      Get.snackbar('Thong bao', 'Mat khau toi thieu 6 ky tu.');
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Thong bao', 'Xac nhan mat khau khong khop.');
      return false;
    }

    return true;
  }

  String _getErrorMessage(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        final errors = data['errors'];
        if (errors is Map && errors.isNotEmpty) {
          final first = errors.values.first;
          if (first is List && first.isNotEmpty) {
            return first.first.toString();
          }
        }
        return data['message']?.toString() ?? 'Co loi xay ra.';
      }
    }
    return 'Co loi xay ra.';
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
