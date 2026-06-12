import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:project_shop/base/base_controller.dart';
import 'package:project_shop/data/api_service/api_service.dart';
import 'package:project_shop/data/response_models/orders/order_model.dart';
import 'package:project_shop/data/secure_storage/secure_storage.dart';
import 'package:project_shop/routes/app_routes.dart';
import 'package:project_shop/widgets/appbar_custom/common_snackbar.dart';
import 'package:project_shop/widgets/common/toast_widget.dart';

class OrderStatusTab {
  const OrderStatusTab({required this.label, this.status});

  final String label;
  final int? status;
}

class OrderController extends BaseController {
  final ApiService apiService = Get.find();
  final SecureStorage secureStorage = Get.find();

  final tabs = const <OrderStatusTab>[
    OrderStatusTab(label: 'Tất cả'),
    OrderStatusTab(label: 'Chờ xác nhận', status: 1),
    OrderStatusTab(label: 'Chờ lấy hàng', status: 2),
    OrderStatusTab(label: 'Chờ giao hàng', status: 3),
    OrderStatusTab(label: 'Đã giao', status: 4),
    OrderStatusTab(label: 'Đã huỷ', status: 5),
  ];

  final selectedTabIndex = 0.obs;
  final orders = <OrderSummaryModel>[].obs;
  final Rxn<OrderDetailModel> selectedOrder = Rxn<OrderDetailModel>();
  final RxBool detailLoading = false.obs;

  OrderStatusTab get selectedTab => tabs[selectedTabIndex.value];

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

    Get.find<ToastWidget>().showToast(
      Get.context!,
      title: 'Cảnh báo',
      toastStatus: ToastStatus.fail,
      description: 'Vui lòng đăng nhập để xem danh sách đơn hàng',
    );
    Get.offNamed(Routes.login, arguments: {'redirect': Routes.orders});
    return false;
  }

  Future<void> selectTab(int index) async {
    if (index == selectedTabIndex.value) return;

    selectedTabIndex.value = index;
    await getOrders();
  }

  Future<void> getOrders() async {
    if (!await ensureLoggedIn()) return;

    isLoading.value = true;
    try {
      final response = await apiService.getOrders(selectedTab.status);
      orders.assignAll(response.data?.data ?? []);
    } catch (error) {
      Get.find<ToastWidget>().showToast(
        Get.context!,
        title: 'Thất bại',
        toastStatus: ToastStatus.fail,
        description: _getErrorMessage(error),
      );
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
      Get.find<ToastWidget>().showToast(
        Get.context!,
        title: 'Thông báo',
        toastStatus: ToastStatus.fail,
        description: _getErrorMessage(error),
      );
    } finally {
      detailLoading.value = false;
    }
  }

  Future<void> cancelOrder(int id) async {
    if (!await ensureLoggedIn()) return;

    try {
      await apiService.cancelOrder(id);
      Get.find<ToastWidget>().showToast(
        Get.context!,
        title: 'Thông báo',
        toastStatus: ToastStatus.fail,
        description: 'Đã huỷ đơn hàng thành công',
      );
      await getOrders();
      if (selectedOrder.value?.id == id) {
        await getOrderDetail(id);
      }
    } catch (error) {
      Get.find<ToastWidget>().showToast(
        Get.context!,
        title: 'Thông báo',
        toastStatus: ToastStatus.fail,
        description: _getErrorMessage(error),
      );
    }
  }

  Future<void> buyAgain(OrderItemModel item) async {
    if (!await ensureLoggedIn()) return;

    try {
      await apiService.addCartItem({
        'product_id': item.productId,
        'product_variant_id': item.productVariantId,
        'quantity': item.quantity > 0 ? item.quantity : 1,
        'attribute_name_id': item.attributeNameId,
        'attribute_ids': item.attributes
            .map((attribute) => attribute.attributeValueId)
            .toList(),
      });
      Get.find<ToastWidget>().showToast(
        Get.context!,
        title: 'Thành công',
        toastStatus: ToastStatus.success,
        description: 'Đã thêm sản phẩm vào giỏ hàng.',
      );
    } catch (error) {
      Get.find<ToastWidget>().showToast(
        Get.context!,
        title: 'Thất bại',
        toastStatus: ToastStatus.fail,
        description: _getErrorMessage(error),
      );
    }
  }

  String statusText(int status) {
    switch (status) {
      case 1:
        return 'chờ xác nhận';
      case 2:
        return 'Đang chuẩn bị';
      case 3:
        return 'Đang giao';
      case 4:
        return 'Đã giao';
      case 5:
        return 'Đã huỷ';
      default:
        return 'Không xác định';
    }
  }

  String paymentStatusText(int status) {
    return status == 1 ? 'Đã thanh toán' : 'Chưa thanh toán';
  }

  String _getErrorMessage(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        return data['message']?.toString() ?? 'Có lỗi xảy ra.';
      }
    }
    return 'Có lỗi xảy ra.';
  }
}
