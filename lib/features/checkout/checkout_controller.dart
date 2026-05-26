import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_shop/base/base_controller.dart';
import 'package:project_shop/data/api_service/api_service.dart';
import 'package:project_shop/data/response_models/address/address_model.dart';
import 'package:project_shop/data/response_models/cart/cart_model.dart';
import 'package:project_shop/routes/app_routes.dart';

class CheckoutController extends BaseController {
  final ApiService apiService = Get.find();

  final Rxn<CartModel> cart = Rxn<CartModel>();
  final RxList<AddressModel> addresses = <AddressModel>[].obs;
  final Rxn<AddressModel> selectedAddress = Rxn<AddressModel>();
  final RxBool submitting = false.obs;
  final couponController = TextEditingController();
  final noteController = TextEditingController();

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
      _assignAddresses(userResponse.data?.addresses ?? []);
    } catch (error) {
      Get.snackbar('Dat hang', _getErrorMessage(error));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> manageAddresses() async {
    await Get.toNamed(Routes.addresses);
    try {
      final userResponse = await apiService.getCurrentUser();
      _assignAddresses(userResponse.data?.addresses ?? []);
    } catch (error) {
      Get.snackbar('Dia chi', _getErrorMessage(error));
    }
  }

  void selectAddress(AddressModel address) {
    selectedAddress.value = address;
  }

  Future<void> submitOrder() async {
    final currentCart = cart.value;
    final deliveryAddress = selectedAddress.value;

    if (currentCart == null || currentCart.items.isEmpty) {
      Get.snackbar('Dat hang', 'Gio hang dang trong.');
      return;
    }

    if (deliveryAddress?.id == null) {
      Get.snackbar('Dat hang', 'Vui long chon dia chi giao hang.');
      return;
    }

    submitting.value = true;
    try {
      await apiService.checkout({
        'address_id': deliveryAddress!.id,
        'note': noteController.text.trim(),
        'coupon_code': couponController.text.trim(),
        'payment_method': 1,
      });

      Get.snackbar('Dat hang', 'Dat hang thanh cong.');
      Get.offNamed(Routes.orders);
    } catch (error) {
      Get.snackbar('Dat hang that bai', _getErrorMessage(error));
    } finally {
      submitting.value = false;
    }
  }

  void _assignAddresses(List<AddressModel> items) {
    final selectedId = selectedAddress.value?.id;
    addresses.assignAll(items);

    selectedAddress.value =
        items.firstWhereOrNull((item) => item.id == selectedId) ??
            items.firstWhereOrNull((item) => item.isDefault) ??
            items.firstOrNull;
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

  @override
  void onClose() {
    couponController.dispose();
    noteController.dispose();
    super.onClose();
  }
}
