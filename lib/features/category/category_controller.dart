import 'dart:convert';

import 'package:get/get.dart';
import 'package:project_shop/base/app_exception.dart';
import 'package:project_shop/base/base_controller.dart';
import 'package:project_shop/data/api_service/api_service.dart';
import 'package:project_shop/data/repository/categories_action/categories_repository.dart';
import 'package:project_shop/data/repository/products_action/products_repository.dart';
import 'package:project_shop/data/response_models/categories/category_model.dart';
import 'package:project_shop/data/response_models/products/products_model.dart';
import 'package:project_shop/features/wishlist/wish_list_controller.dart';

class CategoryController extends BaseController {
  final WishListController wishListController = Get.find();

  final _categoriesRepository = Get.find<CategoriesRepository>();
  final _productsRepository = Get.find<ProductsRepository>();

  final RxList<CategoryModel> _listCategories = <CategoryModel>[].obs;
  List<CategoryModel> get listCategories => _listCategories;

  final _selectedIndex = 0.obs;
  int get selectedIndex => _selectedIndex.value;

  final _isSelected = false.obs;
  bool get isSelected => _isSelected.value;

  @override
  final RxBool isLoading = false.obs;

  final _isLoadingProduct = false.obs;
  bool get isLoadingProduct => _isLoadingProduct.value;

  final _isLoadingProductByCa = false.obs;
  bool get isLoadingProductByCa => _isLoadingProductByCa.value;

  final ApiService _apiService = Get.find();

  final RxList<ProductsModel> _listAllProducts = <ProductsModel>[].obs;
  List<ProductsModel> get listAllProducts => _listAllProducts;

  final RxList<ProductsModel> _productsByCategory = <ProductsModel>[].obs;
  List<ProductsModel> get productsByCategory => _productsByCategory;

  List<ProductsModel> get listDisplayedProducts =>
      _selectedIndex.value == 0 ? _listAllProducts : _productsByCategory;

  final Map<int, List<ProductsModel>> _productsCacheByCategory = {};

  final Map<int, Map<int, List<ProductsModel>>> _productsByCategoryAndPage = {};

  @override
  void onInit() {
    getCategories();
    getProducts();
    super.onInit();
  }

  Future<void> onRefresh() async {
    await getCategories();
    await getProducts();
  }

  void selectCategory({required int index, int? categoryId}) {
    _selectedIndex.value = index;

    if (categoryId == null) {
      if (_listAllProducts.isEmpty) {
        getProducts();
      }
    } else {
      getProductsByCategory(categoryId);
    }
  }

  Future<void> getCategories() async {
    isLoading.value = true;
    try {
      final response = await _categoriesRepository.getCategories();
      response.fold(
        (error) {
          appException.value = error;
          isLoading.value = false;
        },
        (data) {
          _listCategories.assignAll(data.data ?? []);
          isLoading.value = false;
        },
      );
    } catch (e) {
      appException.value = AppException(message: e.toString());
      isLoading.value = false;
    }
  }

  Future<void> getProducts() async {
    _isLoadingProduct.value = true;
    try {
      final response = await _productsRepository.getProducts();
      response.fold(
        (error) {
          appException.value = error;
          _isLoadingProduct.value = false;
        },
        (data) {
          _listAllProducts.assignAll(data.data ?? []);
          _isLoadingProduct.value = false;
        },
      );
    } catch (e, stackTrace) {
      appException.value = AppException(message: e.toString());
      print("Error Exception: $stackTrace");
      _isLoadingProduct.value = false;
    }
  }

  Future<void> getProductsByCategory(int? categoryId) async {
    //phân trang
    //   final hasCache = _productsCacheByCategoryAndPage[categoryId]?[page];
    // if (hasCache != null) {
    //   _productsByCategory.assignAll(hasCache);
    //   return;
    // }
    if (categoryId != null &&
        _productsCacheByCategory.containsKey(categoryId)) {
      final cachedProducts = _productsCacheByCategory[categoryId] ?? [];
      _productsByCategory.assignAll(cachedProducts);
      return;
    }

    _isLoadingProductByCa.value = true;
    try {
      final response =
          await _productsRepository.getProductsByCategory(categoryId);
      response.fold(
        (error) {
          appException.value = error;
          _productsByCategory.clear();
          _isLoadingProductByCa.value = false;
        },
        (data) {
          final products = data.data ?? [];
          _productsByCategory.assignAll(products);
          if (categoryId != null) {
            _productsCacheByCategory[categoryId] = products;
          }
          _isLoadingProductByCa.value = false;
        },
      );
    } catch (e, stackTrace) {
      print('Error StackTrace: $stackTrace');
      appException.value = AppException(message: e.toString());
      _productsByCategory.clear();
      _isLoadingProductByCa.value = false;
    }
  }
}
