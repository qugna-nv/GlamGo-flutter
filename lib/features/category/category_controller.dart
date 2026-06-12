import 'dart:convert';

import 'package:flutter/material.dart';
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
  static const int _pageSize = 20;

  final WishListController wishListController = Get.find();
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

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

  final _isLoadingMore = false.obs;
  bool get isLoadingMore => _isLoadingMore.value;

  final ApiService _apiService = Get.find();

  final RxList<ProductsModel> _listAllProducts = <ProductsModel>[].obs;
  List<ProductsModel> get listAllProducts => _listAllProducts;

  final RxList<ProductsModel> _productsByCategory = <ProductsModel>[].obs;
  List<ProductsModel> get productsByCategory => _productsByCategory;

  int? _selectedCategoryId;
  int _allCurrentPage = 1;
  int _allLastPage = 1;
  final Map<int, int> _categoryCurrentPages = {};
  final Map<int, int> _categoryLastPages = {};

  final _searchQuery = ''.obs;
  String get searchQuery => _searchQuery.value;

  List<ProductsModel> get listDisplayedProducts {
    final products =
        _selectedIndex.value == 0 ? _listAllProducts : _productsByCategory;
    final keyword = _searchQuery.value.trim().toLowerCase();

    if (keyword.isEmpty) {
      return products;
    }

    return products.where((product) {
      final name = product.name?.toLowerCase() ?? '';
      final code = product.code?.toLowerCase() ?? '';
      return name.contains(keyword) || code.contains(keyword);
    }).toList();
  }

  final Map<int, List<ProductsModel>> _productsCacheByCategory = {};

  final Map<int, Map<int, List<ProductsModel>>> _productsByCategoryAndPage = {};

  @override
  void onInit() {
    getCategories();
    getProducts();
    scrollController.addListener(_onScroll);
    super.onInit();
  }

  Future<void> onRefresh() async {
    await getCategories();
    if (_selectedCategoryId == null) {
      await getProducts();
    } else {
      await getProductsByCategory(_selectedCategoryId);
    }
  }

  void selectCategory({required int index, int? categoryId}) {
    _selectedIndex.value = index;
    _selectedCategoryId = categoryId;

    if (categoryId == null) {
      if (_listAllProducts.isEmpty) {
        getProducts();
      }
    } else {
      getProductsByCategory(categoryId);
    }
  }

  void onSearchChanged(String value) {
    _searchQuery.value = value;
  }

  void clearSearch() {
    searchController.clear();
    _searchQuery.value = '';
  }

  void _onScroll() {
    if (!scrollController.hasClients || _searchQuery.value.trim().isNotEmpty) {
      return;
    }

    final position = scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      loadMoreProducts();
    }
  }

  Future<void> loadMoreProducts() async {
    if (_isLoadingMore.value || _isLoadingProduct.value) {
      return;
    }

    if (_selectedCategoryId == null) {
      if (_allCurrentPage >= _allLastPage) {
        return;
      }
      await getProducts(page: _allCurrentPage + 1, append: true);
      return;
    }

    final categoryId = _selectedCategoryId!;
    final currentPage = _categoryCurrentPages[categoryId] ?? 1;
    final lastPage = _categoryLastPages[categoryId] ?? 1;
    if (currentPage >= lastPage) {
      return;
    }

    await getProductsByCategory(
      categoryId,
      page: currentPage + 1,
      append: true,
    );
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();
    super.onClose();
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

  Future<void> getProducts({int page = 1, bool append = false}) async {
    if (append) {
      _isLoadingMore.value = true;
    } else {
      _isLoadingProduct.value = true;
      _allCurrentPage = 1;
    }
    try {
      final response = await _productsRepository.getProducts(
        page: page,
        perPage: _pageSize,
      );
      response.fold(
        (error) {
          appException.value = error;
        },
        (data) {
          final products = data.data ?? [];
          if (append) {
            _listAllProducts.addAll(products);
          } else {
            _listAllProducts.assignAll(products);
          }
          _allCurrentPage = data.currentPage ?? page;
          _allLastPage = data.lastPage ?? _allCurrentPage;
        },
      );
    } catch (e, stackTrace) {
      appException.value = AppException(message: e.toString());
      print("Error Exception: $stackTrace");
    } finally {
      _isLoadingProduct.value = false;
      _isLoadingMore.value = false;
    }
  }

  Future<void> getProductsByCategory(
    int? categoryId, {
    int page = 1,
    bool append = false,
  }) async {
    if (categoryId != null &&
        !append &&
        _productsCacheByCategory.containsKey(categoryId)) {
      final cachedProducts = _productsCacheByCategory[categoryId] ?? [];
      _productsByCategory.assignAll(cachedProducts);
      return;
    }

    if (append) {
      _isLoadingMore.value = true;
    } else {
      _isLoadingProductByCa.value = true;
      if (categoryId != null) {
        _categoryCurrentPages[categoryId] = 1;
      }
    }
    try {
      final response = await _productsRepository.getProductsByCategory(
        categoryId,
        page: page,
        perPage: _pageSize,
      );
      response.fold(
        (error) {
          appException.value = error;
          if (!append) {
            _productsByCategory.clear();
          }
        },
        (data) {
          final products = data.data ?? [];
          if (append) {
            _productsByCategory.addAll(products);
          } else {
            _productsByCategory.assignAll(products);
          }
          if (categoryId != null) {
            _productsCacheByCategory[categoryId] =
                List<ProductsModel>.from(_productsByCategory);
            _categoryCurrentPages[categoryId] = data.currentPage ?? page;
            _categoryLastPages[categoryId] =
                data.lastPage ?? _categoryCurrentPages[categoryId] ?? page;
          }
        },
      );
    } catch (e, stackTrace) {
      print('Error StackTrace: $stackTrace');
      appException.value = AppException(message: e.toString());
      if (!append) {
        _productsByCategory.clear();
      }
    } finally {
      _isLoadingProductByCa.value = false;
      _isLoadingMore.value = false;
    }
  }
}
