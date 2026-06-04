import 'dart:convert';

import 'package:get/get.dart';
import 'package:project_shop/base/app_exception.dart';
import 'package:project_shop/base/base_controller.dart';
import 'package:project_shop/data/repository/categories_action/categories_repository.dart';
import 'package:project_shop/data/repository/products_action/products_repository.dart';
import 'package:project_shop/data/response_models/categories/category_model.dart';
import 'package:project_shop/data/response_models/products/products_model.dart';
import 'package:project_shop/data/secure_storage/share_preference_manager.dart';
import 'package:project_shop/features/cart/cart_controller.dart';
import 'package:project_shop/features/wishlist/wish_list_controller.dart';
import 'package:project_shop/utils/constant.dart';

class HomeController extends BaseController {
  final SharedPreferencesManager prefManager = Get.find();

  final _currentIndex = 0.obs;

  get currentIndex => _currentIndex.value;

  final _categoriesRepository = Get.find<CategoriesRepository>();

  final _productsRepository = Get.find<ProductsRepository>();

  final WishListController wishListController = Get.find();
  final CartController cartController = Get.find();

  final List<String> listImgCarousel = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];

  final _selectedIndex = 0.obs;
  get selectedIndex => _selectedIndex.value;

  final _isSelected = false.obs;
  get isSelected => _isSelected.value;

  @override
  final RxBool isLoading = false.obs;

  final _isLoadingProduct = false.obs;
  bool get isLoadingProduct => _isLoadingProduct.value;

  final _isLoadingProductByCa = false.obs;
  bool get isLoadingProductByCa => _isLoadingProductByCa.value;

  final RxList<CategoryModel> _listCategories = <CategoryModel>[].obs;
  List<CategoryModel> get listCategories => _listCategories;

  final RxList<ProductImage> _listBanner = <ProductImage>[].obs;
  List<ProductImage> get listBanner => _listBanner;

  final RxList<ProductsModel> _listAllProducts = <ProductsModel>[].obs;
  List<ProductsModel> get listAllProducts => _listAllProducts;

  final _listProducts = ProductsModel().obs;
  ProductsModel get listProducts => _listProducts.value;

  final RxList<ProductsModel> _productsByCategory = <ProductsModel>[].obs;
  List<ProductsModel> get productsByCategory => _productsByCategory;

  List<ProductsModel> get listDisplayedProducts =>
      _selectedIndex.value == 0 ? _listAllProducts : _productsByCategory;

  final Map<int, List<ProductsModel>> _productsCacheByCategory = {};
  final Map<int, Map<int, List<ProductsModel>>> _productsByCategoryAndPage = {};

  @override
  void onInit() {
    getBanner();
    getCategories();
    getProducts();
    cartController.getCart(
      redirectIfUnauthenticated: false,
      showErrors: false,
    );
    super.onInit();
  }

  Future<void> onRefresh() async {
    await getBanner();
    await getCategories();
    await getProducts();
    await cartController.getCart(
      redirectIfUnauthenticated: false,
      showErrors: false,
    );
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

  void jumpToPage(int index) {
    _currentIndex.value = index;
  }

  Future<void> getBanner() async {
    try {
      // _listBanner.clear();
      final response = await _productsRepository.getBanner();
      response.fold(
        (error) async {
          appException.value = error;
          _isLoadingProduct.value = false;

          loadBannerLocal();
        },
        (result) {
          final banners = result.data ?? <ProductImage>[];
          _listBanner.assignAll(banners);
          loadBannerLocal();
          _isLoadingProduct.value = false;
        },
      );
    } catch (e) {
      _isLoadingProduct.value = false;
      appException.value = AppException(message: e.toString());
      loadBannerLocal();
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
          print("Error getCategories: ${error.message}");
        },
        (result) {
          _listCategories.assignAll(result.data ?? []);
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
        (result) {
          _listAllProducts.assignAll(result.data ?? []);
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
    if (categoryId != null &&
        _productsCacheByCategory.containsKey(categoryId) &&
        _productsCacheByCategory[categoryId]!.isNotEmpty) {
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
        (result) {
          final products = result.data ?? [];
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

  Future<void> loadBannerLocal() async {
    if (_listBanner.isNotEmpty) return;
    final cachedJsonList =
        prefManager.getStringList(Constant.KEY_LIST_BANNER) ?? [];

    if (cachedJsonList.isNotEmpty) {
      final cachedBanners = cachedJsonList
          .map((e) => ProductImage.fromJson(jsonDecode(e)))
          .toList();

      _listBanner.assignAll(cachedBanners);
    }
  }
}
