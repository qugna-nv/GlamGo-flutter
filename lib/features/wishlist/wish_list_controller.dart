import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:project_shop/base/base_controller.dart';
import 'package:project_shop/data/api_service/api_service.dart';
import 'package:project_shop/data/response_models/products/products_model.dart';
import 'package:project_shop/data/secure_storage/secure_storage.dart';
import 'package:project_shop/data/secure_storage/share_preference_manager.dart';
import 'package:project_shop/routes/app_routes.dart';
import 'package:project_shop/utils/constant.dart';
import 'package:project_shop/widgets/appbar_custom/common_snackbar.dart';
import 'package:project_shop/widgets/common/toast_widget.dart';

class WishListController extends BaseController {
  final ApiService apiService = Get.find();
  final SecureStorage secureStorage = Get.find();
  final SharedPreferencesManager prefManager = Get.find();

  final RxList<ProductsModel> _favoriteProducts = <ProductsModel>[].obs;

  List<ProductsModel> get favoriteProducts => _favoriteProducts;

  Future<void> loadFavoriteProducts() async {
    if (!await _ensureLoggedIn(redirectToLogin: false)) {
      _loadLocalFavoriteProducts();
      return;
    }

    isLoading.value = true;
    try {
      await _syncLocalFavoritesToServer();
      final response = await apiService.getFavoriteProducts();
      _favoriteProducts.assignAll(response.data ?? []);
      await _cacheFavorites();
    } catch (error) {
      Get.find<ToastWidget>().showToast(
        Get.context!,
        title: 'Thất bại',
        toastStatus: ToastStatus.fail,
        description: _getErrorMessage(error),
      );
      _loadLocalFavoriteProducts();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addToFavorites(ProductsModel product) async {
    final productId = product.id;
    if (productId == null) return;

    if (!await _ensureLoggedIn()) return;

    if (!_favoriteProducts.any((item) => item.id == productId)) {
      _favoriteProducts.add(product);
    }

    try {
      final response = await apiService.addFavoriteProduct(productId);
      final serverProduct = response.data;
      if (serverProduct != null) {
        _favoriteProducts.removeWhere((item) => item.id == productId);
        _favoriteProducts.add(serverProduct);
      }
      await _cacheFavorites();
      Get.find<ToastWidget>().showToast(
        Get.context!,
        toastStatus: ToastStatus.success,
        title: 'Thành công',
        description: 'Thêm sản phẩm yêu thích thành công',
      );
    } catch (error) {
      _favoriteProducts.removeWhere((item) => item.id == productId);
      Get.find<ToastWidget>().showToast(
        Get.context!,
        toastStatus: ToastStatus.fail,
        description: _getErrorMessage(error),
      );
    }
  }

  Future<void> removeFromFavorites(ProductsModel product) async {
    final productId = product.id;
    if (productId == null) return;

    if (!await _ensureLoggedIn()) return;

    final oldProducts = List<ProductsModel>.from(_favoriteProducts);
    _favoriteProducts.removeWhere((item) => item.id == productId);

    try {
      await apiService.removeFavoriteProduct(productId);
      await _cacheFavorites();
      Get.find<ToastWidget>().showToast(
        Get.context!,
        toastStatus: ToastStatus.success,
        description: 'Đã xoá sản phẩm yêu thích',
      );
    } catch (error) {
      _favoriteProducts.assignAll(oldProducts);
      Get.find<ToastWidget>().showToast(
        Get.context!,
        toastStatus: ToastStatus.fail,
        description: _getErrorMessage(error),
      );
    }
  }

  Future<void> toggleFavorite(ProductsModel product) async {
    final isExist = _favoriteProducts.any((item) => item.id == product.id);
    if (isExist) {
      await removeFromFavorites(product);
    } else {
      await addToFavorites(product);
    }
  }

  bool isFavorite(ProductsModel? product) {
    return _favoriteProducts.any((item) => item.id == product?.id);
  }

  Future<bool> _ensureLoggedIn({bool redirectToLogin = true}) async {
    final token = await secureStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      return true;
    }

    if (redirectToLogin) {
      Get.snackbar('Dang nhap', 'Vui long dang nhap de dung yeu thich.');
      Get.toNamed(Routes.login);
    }
    return false;
  }

  void _loadLocalFavoriteProducts() {
    final storedProducts =
        prefManager.getStringList(Constant.KEY_WISH_LIST_PRODUCTS);

    if (storedProducts == null) {
      _favoriteProducts.clear();
      return;
    }

    final products = storedProducts
        .map((item) => ProductsModel.fromJson(jsonDecode(item)))
        .toList();
    _favoriteProducts.assignAll(products);
  }

  Future<void> _syncLocalFavoritesToServer() async {
    final storedProducts =
        prefManager.getStringList(Constant.KEY_WISH_LIST_PRODUCTS);

    if (storedProducts == null || storedProducts.isEmpty) {
      return;
    }

    for (final item in storedProducts) {
      final product = ProductsModel.fromJson(jsonDecode(item));
      final productId = product.id;
      if (productId != null) {
        await apiService.addFavoriteProduct(productId);
      }
    }

    await prefManager.putStringList(Constant.KEY_WISH_LIST_PRODUCTS, []);
  }

  Future<void> _cacheFavorites() async {
    final products =
        _favoriteProducts.map((item) => jsonEncode(item.toJson())).toList();
    await prefManager.putStringList(Constant.KEY_WISH_LIST_PRODUCTS, products);
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
  void onReady() {
    loadFavoriteProducts();
    super.onReady();
  }
}
