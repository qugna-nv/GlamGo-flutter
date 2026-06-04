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

class CheckoutController extends BaseController {
  final ApiService apiService = Get.find();
  final CartController? cartController =
      Get.isRegistered<CartController>() ? Get.find<CartController>() : null;
  final List<int> selectedItemIds = _readSelectedItemIds();

  final Rxn<CartModel> cart = Rxn<CartModel>();
  final RxList<AddressModel> addresses = <AddressModel>[].obs;
  final Rxn<AddressModel> selectedAddress = Rxn<AddressModel>();
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
      _assignAddresses(userResponse.data?.addresses ?? []);
    } catch (error) {
      Get.snackbar('Dat hang', _getErrorMessage(error));
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

    if (currentCart == null || checkoutItems.isEmpty) {
      Get.snackbar('Dat hang', 'Vui long chon sản phẩm can dat.');
      return;
    }

    if (deliveryAddress?.id == null) {
      final message = addresses.isEmpty
          ? 'Ban chua co dia chi giao hang. Vui long them dia chi.'
          : 'Vui long dat dia chi mac dinh truoc khi dat hang.';
      Get.snackbar('Dat hang', message);
      return;
    }

    submitting.value = true;
    try {
      await apiService.checkout({
        'address_id': deliveryAddress!.id,
        'note': noteController.text.trim(),
        'coupon_code': couponController.text.trim(),
        'payment_method': 1,
        'item_ids': selectedItemIds,
      });

      await cartController?.getCart(
        redirectIfUnauthenticated: false,
        showErrors: false,
      );
      Get.snackbar('Dat hang', 'Dat hang thanh cong.');
      Get.offNamed(Routes.orders);
    } catch (error) {
      Get.snackbar('Dat hang that bai', _getErrorMessage(error));
    } finally {
      submitting.value = false;
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
