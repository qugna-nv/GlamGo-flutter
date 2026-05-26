import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:project_shop/base/base_controller.dart';
import 'package:project_shop/data/api_service/api_service.dart';
import 'package:project_shop/data/response_models/orders/order_model.dart';
import 'package:project_shop/data/secure_storage/secure_storage.dart';
import 'package:project_shop/routes/app_routes.dart';

class OrderController extends BaseController {
  final ApiService apiService = Get.find();
  final SecureStorage secureStorage = Get.find();

  final orders = <OrderSummaryModel>[].obs;
  final Rxn<OrderDetailModel> selectedOrder = Rxn<OrderDetailModel>();
  final RxBool detailLoading = false.obs;

  @override
  void onReady() {
    _loadIfLoggedIn();
    super.onReady();
  }

  Future<void> _loadIfLoggedIn() async {
    if (!await ensureLoggedIn()) return;
    await getOrders();
  }

  Future<bool> ensureLoggedIn() async {
    final token = await secureStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      return true;
    }

    Get.snackbar('Dang nhap', 'Vui long dang nhap de xem don hang.');
    Get.offNamed(Routes.login, arguments: {'redirect': Routes.orders});
    return false;
  }

  Future<void> getOrders() async {
    if (!await ensureLoggedIn()) return;

    isLoading.value = true;
    try {
      final response = await apiService.getOrders();
      orders.assignAll(response.data?.data ?? []);
    } catch (error) {
      Get.snackbar('Don hang', _getErrorMessage(error));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getOrderDetail(int id) async {
    if (!await ensureLoggedIn()) return;

    detailLoading.value = true;
    selectedOrder.value = null;
    try {
      final response = await apiService.getOrderDetail(id);
      selectedOrder.value = response.data;
    } catch (error) {
      Get.snackbar('Don hang', _getErrorMessage(error));
    } finally {
      detailLoading.value = false;
    }
  }

  Future<void> cancelOrder(int id) async {
    if (!await ensureLoggedIn()) return;

    try {
      await apiService.cancelOrder(id);
      Get.snackbar('Don hang', 'Da huy don hang.');
      await getOrders();
      if (selectedOrder.value?.id == id) {
        await getOrderDetail(id);
      }
    } catch (error) {
      Get.snackbar('Don hang', _getErrorMessage(error));
    }
  }

  String statusText(int status) {
    switch (status) {
      case 1:
        return 'Cho kiem tra';
      case 2:
        return 'Dang chuan bi';
      case 3:
        return 'Dang giao';
      case 4:
        return 'Da giao';
      case 5:
        return 'Da huy';
      default:
        return 'Khong xac dinh';
    }
  }

  String paymentStatusText(int status) {
    return status == 1 ? 'Da thanh toan' : 'Chua thanh toan';
  }

  String _getErrorMessage(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        return data['message']?.toString() ?? 'Co loi xay ra.';
      }
    }
    return 'Co loi xay ra.';
  }
}
