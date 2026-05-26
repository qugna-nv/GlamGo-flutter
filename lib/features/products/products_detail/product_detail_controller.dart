import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_shop/base/app_exception.dart';
import 'package:project_shop/base/base_controller.dart';
import 'package:project_shop/data/api_service/api_service.dart';
import 'package:project_shop/data/repository/categories_action/categories_repository.dart';
import 'package:project_shop/data/repository/products_action/products_repository.dart';
import 'package:project_shop/data/response_models/products/product_attribute_model.dart';
import 'package:project_shop/data/response_models/products/product_rating_model.dart';
import 'package:project_shop/data/response_models/products/products_model.dart';
import 'package:project_shop/data/secure_storage/secure_storage.dart';
import 'package:project_shop/features/wishlist/wish_list_controller.dart';
import 'package:project_shop/routes/app_routes.dart';

class ProductDetailController extends BaseController {
  final WishListController wishListController = Get.find();
  final RxList<String> imageList = [
    'https://picsum.photos/id/1015/600/400',
    'https://picsum.photos/id/1016/600/400',
    'https://picsum.photos/id/1018/600/400',
    'https://picsum.photos/id/1015/600/400',
    'https://picsum.photos/id/1016/600/400',
    'https://picsum.photos/id/1018/600/400',
  ].obs;

  final _categoriesRepository = Get.find<CategoriesRepository>();
  final _productsRepository = Get.find<ProductsRepository>();
  final ApiService apiService = Get.find();
  final SecureStorage secureStorage = Get.find();

  final RxInt selectedIndex = 0.obs;

  PageController pageController = PageController();

  final ScrollController thumbnailScrollController = ScrollController();

  final RxBool isJumping = false.obs;

  final productId = Get.arguments;

  final Rxn<ProductsModel> _productDetail = Rxn<ProductsModel>();
  ProductsModel? get productDetail => _productDetail.value;

  final _listAttribute = <ProductAttributeModel>[].obs;
  List<ProductAttributeModel> get listAttribute => _listAttribute;

  final RxBool cartLoading = false.obs;
  final RxBool ratingLoading = false.obs;
  final RxBool ratingSubmitting = false.obs;
  final RxInt quantity = 1.obs;
  final RxDouble selectedRating = 5.0.obs;
  final TextEditingController ratingNameController = TextEditingController();
  final TextEditingController ratingPhoneController = TextEditingController();
  final TextEditingController ratingCommentController = TextEditingController();

  final RxList<ProductRatingModel> _ratings = <ProductRatingModel>[].obs;
  List<ProductRatingModel> get ratings => _ratings;

  final Rxn<ProductRatingResponse> _ratingSummary =
      Rxn<ProductRatingResponse>();
  ProductRatingResponse? get ratingSummary => _ratingSummary.value;
  bool get canReviewProduct => ratingSummary?.canReview == true;
  String get reviewDeniedMessage =>
      ratingSummary?.reviewDeniedMessage ??
      'Chi khach hang da nhan don thanh cong moi co the danh gia san pham.';

  final RxMap<int, int> selectedAttributes = <int, int>{}.obs;

  void jumpToPageFromThumbnail(int index) async {
    if (selectedIndex.value == index) return;

    isJumping.value = true;
    await pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    await Future.delayed(const Duration(milliseconds: 50));

    selectedIndex.value = index;
    isJumping.value = false;

    scrollThumbnailToIndex(index);
  }

  void scrollThumbnailToIndex(int index) {
    selectedIndex.value = index;

    final double itemWidth = 70 + 8;
    final double targetScrollOffset =
        itemWidth * index - Get.width / 2 + itemWidth / 2;

    thumbnailScrollController.animateTo(
      targetScrollOffset.clamp(
        thumbnailScrollController.position.minScrollExtent,
        thumbnailScrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> getProductDetail(int? productId) async {
    try {
      isLoading.value = true;
      final response = await _productsRepository.getProductDetail(productId);
      response.fold(
        (error) {
          appException.value = error;
          isLoading.value = false;
        },
        (result) {
          _productDetail.value = result.data;
          isLoading.value = false;

          _listAttribute.clear();

          final attributes = _productDetail.value?.attribute;
          if (attributes != null) {
            _listAttribute.addAll(attributes);
          }

          // _isLoadingProduct.value = false;
        },
      );
    } catch (e) {
      appException.value = AppException(message: e.toString());
      isLoading.value = false;
      // _isLoadingProduct.value = false;
    }
  }

  void selectAttribute({
    required int attributeId,
    required int value,
  }) {
    selectedAttributes[attributeId] = value;
    update();
  }

  int? get _currentProductId {
    if (productDetail?.id != null) return productDetail?.id;
    if (productId is int) return productId as int;
    return int.tryParse(productId?.toString() ?? '');
  }

  Future<void> getProductRatings() async {
    final id = _currentProductId;
    if (id == null) return;

    ratingLoading.value = true;
    final response = await _productsRepository.getProductRatings(id);
    response.fold(
      (error) {
        appException.value = error;
        ratingLoading.value = false;
      },
      (result) {
        _ratingSummary.value = result.data;
        _ratings.assignAll(result.data?.items ?? []);
        ratingLoading.value = false;
      },
    );
  }

  Future<void> submitRating() async {
    final id = _currentProductId;
    if (id == null) return;

    if (ratingNameController.text.trim().isEmpty) {
      Get.snackbar('Danh gia', 'Vui long nhap ho ten.');
      return;
    }

    if (!canReviewProduct) {
      Get.snackbar('Danh gia', reviewDeniedMessage);
      return;
    }

    ratingSubmitting.value = true;
    final response = await _productsRepository.createProductRating(id, {
      'fullname': ratingNameController.text.trim(),
      'phone': ratingPhoneController.text.trim(),
      'comment': ratingCommentController.text.trim(),
      'rating_value': selectedRating.value.round(),
      'image_real': <String>[],
    });

    response.fold(
      (error) {
        Get.snackbar('Danh gia', error.message);
      },
      (_) async {
        ratingNameController.clear();
        ratingPhoneController.clear();
        ratingCommentController.clear();
        selectedRating.value = 5.0;
        Get.snackbar('Danh gia', 'Da gui danh gia san pham.');
        await getProductRatings();
      },
    );
    ratingSubmitting.value = false;
  }

  int? getSelectedValue(int attributeId) {
    return selectedAttributes[attributeId];
  }

  void increaseQuantity() {
    quantity.value++;
  }

  void decreaseQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  bool get _hasSelectedAllAttributes {
    return listAttribute.every((attribute) =>
        attribute.id == null || selectedAttributes.containsKey(attribute.id));
  }

  Future<void> addToCart({bool goToCart = false}) async {
    final product = productDetail;
    if (product?.id == null) return;

    if (!await _ensureLoggedIn()) {
      return;
    }

    if (!_hasSelectedAllAttributes) {
      Get.snackbar('Gio hang', 'Vui long chon day du phan loai san pham.');
      return;
    }

    cartLoading.value = true;
    try {
      await apiService.addCartItem({
        'product_id': product!.id,
        'quantity': quantity.value,
        'attribute_name_id': selectedAttributes.keys.isEmpty
            ? null
            : selectedAttributes.keys.first,
        'attribute_ids': selectedAttributes.values.toList(),
      });

      Get.snackbar('Gio hang', 'Da them san pham vao gio hang.');
      if (Get.isBottomSheetOpen == true) {
        Get.back();
      }
      if (goToCart) {
        Get.toNamed(Routes.cart);
      }
    } catch (error) {
      Get.snackbar('Gio hang', 'Khong the them san pham vao gio hang.');
    } finally {
      cartLoading.value = false;
    }
  }

  Future<bool> _ensureLoggedIn() async {
    final token = await secureStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      return true;
    }

    Get.snackbar('Dang nhap', 'Vui long dang nhap de tiep tuc.');
    return false;
  }

  void printSelected() {}

  @override
  void onReady() {
    getProductDetail(productId);
    getProductRatings();
    super.onReady();
  }

  @override
  void onClose() {
    pageController.dispose();
    thumbnailScrollController.dispose();
    ratingNameController.dispose();
    ratingPhoneController.dispose();
    ratingCommentController.dispose();
    super.onClose();
  }
}
