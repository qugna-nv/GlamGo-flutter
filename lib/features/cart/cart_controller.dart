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
  final RxList<int> selectedItemIds = <int>[].obs;
  final Map<int, Timer> _quantityDebouncers = {};
  final Map<int, int> _pendingQuantities = {};

  List<CartItemModel> get items => cart.value?.items ?? [];
  bool get isEmpty => items.isEmpty;
  int get totalQuantity => items.length;
  List<CartItemModel> get selectedItems =>
      items.where((item) => selectedItemIds.contains(item.id)).toList();
  bool get hasSelectedItems => selectedItemIds.isNotEmpty;
  bool get isAllSelected =>
      items.isNotEmpty && selectedItemIds.length == items.length;
  int get selectedTotalQuantity =>
      selectedItems.fold<int>(0, (sum, item) => sum + item.quantity);
  double get selectedSubtotal =>
      selectedItems.fold<double>(0, (sum, item) => sum + item.totalPrice);
  double get selectedTotalPrice {
    final discount = cart.value?.discount ?? 0;
    final total = selectedSubtotal - discount;
    return total < 0 ? 0 : total;
  }

  @override
  void onReady() {
    _loadIfLoggedIn();
    super.onReady();
  }

  Future<void> _loadIfLoggedIn() async {
    if (!await ensureLoggedIn(redirectToLogin: false)) return;
    await getCart(redirectIfUnauthenticated: false, showErrors: false);
  }

  Future<bool> ensureLoggedIn({bool redirectToLogin = true}) async {
    final token = await secureStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      return true;
    }

    if (redirectToLogin) {
      Get.snackbar('Dang nhap', 'Vui long dang nhap de xem giỏ hàng.');
      Get.offNamed(Routes.login, arguments: {'redirect': Routes.cart});
    }
    return false;
  }

  Future<void> getCart({
    bool redirectIfUnauthenticated = true,
    bool showErrors = true,
  }) async {
    if (!await ensureLoggedIn(redirectToLogin: redirectIfUnauthenticated)) {
      setCart(null);
      return;
    }

    isLoading.value = true;
    try {
      final response = await apiService.getCart();
      setCart(response.data);
    } catch (error) {
      if (showErrors) {
        Get.snackbar('Giỏ hàng', _getErrorMessage(error));
      }
    } finally {
      isLoading.value = false;
    }
  }

  void setCart(CartModel? value, {bool selectAllIfEmpty = true}) {
    cart.value = value;
    _syncSelectedItemsWithCart(selectAllIfEmpty: selectAllIfEmpty);
  }

  void toggleItemSelection(int itemId, bool selected) {
    if (selected) {
      if (!selectedItemIds.contains(itemId)) {
        selectedItemIds.add(itemId);
      }
    } else {
      selectedItemIds.remove(itemId);
    }
    selectedItemIds.refresh();
  }

  void toggleAllSelection(bool selected) {
    if (selected) {
      selectedItemIds.assignAll(items.map((item) => item.id));
    } else {
      selectedItemIds.clear();
    }
    selectedItemIds.refresh();
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

      setCart(_mergePendingQuantities(response.data), selectAllIfEmpty: false);
    } catch (error) {
      Get.snackbar('Giỏ hàng', _getErrorMessage(error));
      await getCart();
    }
  }

  Future<void> removeItem(int id) async {
    if (!await ensureLoggedIn()) return;

    _quantityDebouncers.remove(id)?.cancel();
    _pendingQuantities.remove(id);

    try {
      final response = await apiService.deleteCartItem(id);
      setCart(response.data, selectAllIfEmpty: false);
      Get.snackbar('Giỏ hàng', 'Đã xoá sản phẩm khỏi giỏ hàng.');
    } catch (error) {
      Get.snackbar('Giỏ hàng', _getErrorMessage(error));
    }
  }

  Future<void> clearCart() async {
    if (!await ensureLoggedIn()) return;

    _cancelQuantityDebouncers();

    try {
      final response = await apiService.clearCart();
      setCart(response.data, selectAllIfEmpty: false);
    } catch (error) {
      Get.snackbar('Giỏ hàng', _getErrorMessage(error));
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
    _syncSelectedItemsWithCart();
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
        attributes: item.attributes,
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

  void _syncSelectedItemsWithCart({bool selectAllIfEmpty = false}) {
    final itemIds = items.map((item) => item.id).toSet();
    selectedItemIds.removeWhere((id) => !itemIds.contains(id));

    if (selectAllIfEmpty && selectedItemIds.isEmpty && itemIds.isNotEmpty) {
      selectedItemIds.assignAll(itemIds);
    }
    selectedItemIds.refresh();
  }

  @override
  void onClose() {
    _cancelQuantityDebouncers();
    super.onClose();
  }
}
