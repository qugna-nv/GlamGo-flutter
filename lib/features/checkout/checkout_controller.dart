import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_shop/base/base_controller.dart';
import 'package:project_shop/data/api_service/api_service.dart';
import 'package:project_shop/data/response_models/address/address_model.dart';
import 'package:project_shop/data/response_models/cart/cart_model.dart';
import 'package:project_shop/features/address/address_page_args.dart';
import 'package:project_shop/features/cart/cart_controller.dart';
import 'package:project_shop/routes/app_routes.dart';
import 'package:project_shop/utils/payment_method.dart';
import 'package:project_shop/widgets/appbar_custom/common_snackbar.dart';
import 'package:project_shop/widgets/common/toast_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CheckoutController extends BaseController {
  final ApiService apiService = Get.find();
  final CartController? cartController =
      Get.isRegistered<CartController>() ? Get.find<CartController>() : null;
  final List<int> selectedItemIds = _readSelectedItemIds();

  final Rxn<CartModel> cart = Rxn<CartModel>();
  final RxList<AddressModel> addresses = <AddressModel>[].obs;
  final Rxn<AddressModel> selectedAddress = Rxn<AddressModel>();
  final Rx<PaymentMethod> selectedPaymentMethod =
      PaymentMethod.cashOnDelivery.obs;
  final RxDouble walletBalance = 0.0.obs;
  final RxBool submitting = false.obs;
  final couponController = TextEditingController();
  final noteController = TextEditingController();

  List<CartItemModel> get checkoutItems {
    final items = cart.value?.items ?? [];
    if (selectedItemIds.isEmpty) return items;

    return items.where((item) => selectedItemIds.contains(item.id)).toList();
  }

  double get checkoutSubtotal =>
      checkoutItems.fold<double>(0, (sum, item) => sum + item.totalPrice);

  double get checkoutTotalPrice {
    final discount = cart.value?.discount ?? 0;
    final total = checkoutSubtotal - discount;
    return total < 0 ? 0 : total;
  }

  static List<int> _readSelectedItemIds() {
    final args = Get.arguments;
    if (args is Map && args['item_ids'] is List) {
      return (args['item_ids'] as List)
          .map((id) => int.tryParse(id.toString()) ?? 0)
          .where((id) => id > 0)
          .toList();
    }

    return <int>[];
  }

  @override
  void onReady() {
    loadCheckout();
    super.onReady();
  }

  Future<void> loadCheckout() async {
    isLoading.value = true;
    try {
      final cartResponse = await apiService.getCart();
      final userResponse = await apiService.getCurrentUser();

      cart.value = cartResponse.data;
      walletBalance.value = userResponse.data?.walletBalance ?? 0;
      _assignAddresses(userResponse.data?.addresses ?? []);
    } catch (error) {
      Get.find<ToastWidget>().showToast(
        Get.context!,
        title: 'Đặt hàng',
        toastStatus: ToastStatus.fail,
        description: _getErrorMessage(error),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> manageAddresses() async {
    await Get.toNamed(
      Routes.addresses,
      arguments: const AddressPageArgs(
        mode: AddressPageMode.selectDefaultForCheckout,
      ),
    );
    try {
      final userResponse = await apiService.getCurrentUser();
      walletBalance.value = userResponse.data?.walletBalance ?? 0;
      _assignAddresses(userResponse.data?.addresses ?? []);
    } catch (error) {
      Get.find<ToastWidget>().showToast(
        Get.context!,
        title: 'Thất bại',
        toastStatus: ToastStatus.fail,
        description: _getErrorMessage(error),
      );
    }
  }

  void selectAddress(AddressModel address) {
    selectedAddress.value = address;
  }

  void selectPaymentMethod(PaymentMethod method) {
    selectedPaymentMethod.value = method;
  }

  Future<void> submitOrder() async {
    final currentCart = cart.value;
    final deliveryAddress = selectedAddress.value;

    if (currentCart == null || checkoutItems.isEmpty) {
      Get.find<ToastWidget>().showToast(
        Get.context!,
        title: 'Cảnh báo',
        toastStatus: ToastStatus.success,
        description: 'Vui lòng chọn sản phảm cần đặt',
      );
      return;
    }

    if (deliveryAddress?.id == null) {
      final message = addresses.isEmpty
          ? 'Bạn chưa có địa chỉ giao hàng. Vui lòng thêm địa chỉ.'
          : 'Vui lòng chọn địa chỉ trước khi đặt hàng.';
      Get.find<ToastWidget>().showToast(
        Get.context!,
        title: 'Cảnh báo',
        toastStatus: ToastStatus.warning,
        description: message,
      );
      return;
    }

    submitting.value = true;
    try {
      final response = await apiService.checkout({
        'address_id': deliveryAddress!.id,
        'note': noteController.text.trim(),
        'coupon_code': couponController.text.trim(),
        'payment_method': selectedPaymentMethod.value.value,
        'item_ids': selectedItemIds,
      });

      await cartController?.getCart(
        redirectIfUnauthenticated: false,
        showErrors: false,
      );

      final paymentUrl = response.data?.paymentUrl;
      if (paymentUrl != null && paymentUrl.isNotEmpty) {
        await _openPaymentUrl(paymentUrl);
        return;
      }

      Get.find<ToastWidget>().showToast(
        Get.context!,
        title: 'Thành công',
        toastStatus: ToastStatus.success,
        description: 'Đặt hàng thành công',
      );
      Get.offNamed(Routes.orders);
    } catch (error) {
      Get.find<ToastWidget>().showToast(
        Get.context!,
        title: 'Cảnh báo',
        toastStatus: ToastStatus.warning,
        description: _getErrorMessage(error),
      );
    } finally {
      submitting.value = false;
    }
  }

  Future<void> _openPaymentUrl(String paymentUrl) async {
    if (Uri.tryParse(paymentUrl) == null) {
      throw Exception('Payment URL không hợp lệ.');
    }

    final launched = await launchUrlString(
      paymentUrl,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      throw Exception('Không thể mở cổng thanh toán.');
    }
  }

  void _assignAddresses(List<AddressModel> items) {
    addresses.assignAll(items);
    selectedAddress.value = items.firstWhereOrNull((item) => item.isDefault);
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

  @override
  void onClose() {
    couponController.dispose();
    noteController.dispose();
    super.onClose();
  }
}
