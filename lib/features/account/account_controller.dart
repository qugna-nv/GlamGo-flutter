import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:project_shop/base/base_controller.dart';
import 'package:project_shop/core/notification_service.dart';
import 'package:project_shop/data/api_service/api_service.dart';
import 'package:project_shop/data/response_models/user/user_model.dart';
import 'package:project_shop/data/secure_storage/secure_storage.dart';
import 'package:project_shop/features/notification/notification_controller.dart';

class AccountController extends BaseController {
  final ApiService apiService = Get.find();
  final SecureStorage secureStorage = Get.find();

  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isAuthenticated = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isAuthChecking = true.obs;

  @override
  void onInit() {
    super.onInit();
    print('AccountController onInit');
    loadCurrentUser();
  }

  Future<void> loadCurrentUser({bool force = false}) async {
    if (!force && user.value != null) return;

    isAuthChecking.value = true;

    try {
      final token = await secureStorage.getAccessToken();

      if (token == null || token.isEmpty) {
        user.value = null;
        isAuthenticated.value = false;
        return;
      }

      isAuthenticated.value = true;

      if (!force && user.value != null) return;

      errorMessage.value = '';
      isLoading.value = true;

      final response = await apiService.getCurrentUser();
      user.value = response.data;
    } finally {
      isLoading.value = false;
      isAuthChecking.value = false;
    }
  }
  // Future<void> loadCurrentUser() async {
  //   isAuthChecking.value = true;
  //   final token = await secureStorage.getAccessToken();
  //   if (token == null || token.isEmpty) {
  //     user.value = null;
  //     isAuthenticated.value = false;
  //     isAuthChecking.value = false;
  //     return;
  //   }

  //   isAuthenticated.value = true;
  //   errorMessage.value = '';
  //   isLoading.value = true;
  //   try {
  //     final response = await apiService.getCurrentUser();
  //     user.value = response.data;
  //   } catch (error) {
  //     if (error is DioException &&
  //         (error.response?.statusCode == 401 ||
  //             error.response?.statusCode == 403)) {
  //       await secureStorage.deleteTokens();
  //       await _logoutOneSignal();
  //       _clearNotifications();
  //       user.value = null;
  //       isAuthenticated.value = false;
  //       return;
  //     }

  //     errorMessage.value = 'Không thể tải thông tin tài khoản.';
  //   } finally {
  //     isLoading.value = false;
  //     isAuthChecking.value = false;
  //   }
  // }

  Future<void> logout() async {
    await secureStorage.deleteTokens();
    await _logoutOneSignal();
    _clearNotifications();
    user.value = null;
    isAuthenticated.value = false;
  }

  Future<void> _logoutOneSignal() async {
    if (Get.isRegistered<NotificationService>()) {
      await Get.find<NotificationService>().logout();
    }
  }

  void _clearNotifications() {
    if (Get.isRegistered<NotificationController>()) {
      Get.find<NotificationController>().clear();
    }
  }
}
