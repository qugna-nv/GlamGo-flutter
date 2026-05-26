import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:project_shop/base/base_controller.dart';
import 'package:project_shop/data/api_service/api_service.dart';
import 'package:project_shop/data/response_models/user/user_model.dart';
import 'package:project_shop/data/secure_storage/secure_storage.dart';

class AccountController extends BaseController {
  final ApiService apiService = Get.find();
  final SecureStorage secureStorage = Get.find();

  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isAuthenticated = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadCurrentUser();
  }

  Future<void> loadCurrentUser() async {
    final token = await secureStorage.getAccessToken();
    if (token == null || token.isEmpty) {
      user.value = null;
      isAuthenticated.value = false;
      return;
    }

    isAuthenticated.value = true;
    errorMessage.value = '';
    isLoading.value = true;
    try {
      final response = await apiService.getCurrentUser();
      user.value = response.data;
    } catch (error) {
      if (error is DioException &&
          (error.response?.statusCode == 401 ||
              error.response?.statusCode == 403)) {
        await secureStorage.deleteTokens();
        user.value = null;
        isAuthenticated.value = false;
        return;
      }

      errorMessage.value = 'Khong the tai thong tin tai khoan.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await secureStorage.deleteTokens();
    user.value = null;
    isAuthenticated.value = false;
  }
}
