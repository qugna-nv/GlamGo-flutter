import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:project_shop/base/base_controller.dart';
import 'package:project_shop/data/api_service/api_service.dart';
import 'package:project_shop/data/response_models/cart/cart_model.dart';
import 'package:project_shop/data/secure_storage/secure_storage.dart';
import 'package:project_shop/routes/app_routes.dart';

class CartController extends BaseController {
  final ApiService apiService = Get.find();
  final SecureStorage secureStorage = Get.find();

  final Rxn<CartModel> cart = Rxn<CartModel>();
  final Map<int, Timer> _quantityDebouncers = {};
  final Map<int, int> _pendingQuantities = {};

  List<CartItemModel> get items => cart.value?.items ?? [];
  bool get isEmpty => items.isEmpty;

  @override
  void onReady() {
    _loadIfLoggedIn();
    super.onReady();
  }

  Future<void> _loadIfLoggedIn() async {
    if (!await ensureLoggedIn()) return;
    await getCart();
  }

  Future<bool> ensureLoggedIn() async {
    final token = await secureStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      return true;
    }

    Get.snackbar('Dang nhap', 'Vui long dang nhap de xem gio hang.');
    Get.offNamed(Routes.login, arguments: {'redirect': Routes.cart});
    return false;
  }

  Future<void> getCart() async {
    if (!await ensureLoggedIn()) return;

    isLoading.value = true;
    try {
      final response = await apiService.getCart();
      cart.value = response.data;
    } catch (error) {
      Get.snackbar('Gio hang', _getErrorMessage(error));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateQuantity(CartItemModel item, int quantity) async {
    if (quantity < 1) return;
    if (!await ensureLoggedIn()) return;

    _applyLocalQuantity(item.id, quantity);
    _pendingQuantities[item.id] = quantity;
    _quantityDebouncers[item.id]?.cancel();
    _quantityDebouncers[item.id] = Timer(const Duration(seconds: 1), () {
      _syncQuantity(item.id, quantity);
    });
  }

  Future<void> _syncQuantity(int itemId, int quantity) async {
    try {
      final response = await apiService.updateCartItem(itemId, {
        'quantity': quantity,
      });

      if (_pendingQuantities[itemId] == quantity) {
        _pendingQuantities.remove(itemId);
        _quantityDebouncers.remove(itemId)?.cancel();
      }

      cart.value = _mergePendingQuantities(response.data);
    } catch (error) {
      Get.snackbar('Gio hang', _getErrorMessage(error));
      await getCart();
    }
  }

  Future<void> removeItem(int id) async {
    if (!await ensureLoggedIn()) return;

    _quantityDebouncers.remove(id)?.cancel();
    _pendingQuantities.remove(id);

    try {
      final response = await apiService.deleteCartItem(id);
      cart.value = response.data;
      Get.snackbar('Gio hang', 'Da xoa san pham khoi gio hang.');
    } catch (error) {
      Get.snackbar('Gio hang', _getErrorMessage(error));
    }
  }

  Future<void> clearCart() async {
    if (!await ensureLoggedIn()) return;

    _cancelQuantityDebouncers();

    try {
      final response = await apiService.clearCart();
      cart.value = response.data;
    } catch (error) {
      Get.snackbar('Gio hang', _getErrorMessage(error));
    }
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

  void _applyLocalQuantity(int itemId, int quantity) {
    cart.value = _copyCartWithQuantity(cart.value, itemId, quantity);
  }

  CartModel? _mergePendingQuantities(CartModel? source) {
    var result = source;
    _pendingQuantities.forEach((itemId, quantity) {
      result = _copyCartWithQuantity(result, itemId, quantity);
    });
    return result;
  }

  CartModel? _copyCartWithQuantity(
      CartModel? source, int itemId, int quantity) {
    if (source == null) return null;

    final updatedItems = source.items.map((item) {
      if (item.id != itemId) return item;

      return CartItemModel(
        id: item.id,
        productId: item.productId,
        productName: item.productName,
        productCode: item.productCode,
        productImage: item.productImage,
        attributeNameId: item.attributeNameId,
        attributeIds: item.attributeIds,
        personaliseName: item.personaliseName,
        price: item.price,
        quantity: quantity,
        totalPrice: item.price * quantity,
      );
    }).toList();

    final subtotal =
        updatedItems.fold<double>(0, (sum, item) => sum + item.totalPrice);
    final totalQuantity =
        updatedItems.fold<int>(0, (sum, item) => sum + item.quantity);
    final totalPrice = subtotal - source.discount;

    return CartModel(
      id: source.id,
      code: source.code,
      userId: source.userId,
      subtotal: subtotal,
      discount: source.discount,
      totalPrice: totalPrice < 0 ? 0 : totalPrice,
      totalQuantity: totalQuantity,
      items: updatedItems,
    );
  }

  void _cancelQuantityDebouncers() {
    for (final timer in _quantityDebouncers.values) {
      timer.cancel();
    }
    _quantityDebouncers.clear();
    _pendingQuantities.clear();
  }

  @override
  void onClose() {
    _cancelQuantityDebouncers();
    super.onClose();
  }
}
