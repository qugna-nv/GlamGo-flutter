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
import 'package:project_shop/features/account/account_controller.dart';
import 'package:project_shop/features/cart/cart_controller.dart';
import 'package:project_shop/features/wishlist/wish_list_controller.dart';
import 'package:project_shop/features/products/products_detail/widget/edit_rating_dialog.dart';
import 'package:project_shop/widgets/appbar_custom/common_snackbar.dart';
import 'package:project_shop/widgets/common/toast_widget.dart';

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
  final CartController cartController = Get.isRegistered<CartController>()
      ? Get.find<CartController>()
      : Get.put(CartController(), permanent: true);

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
  final RxBool ratingDeleting = false.obs;
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
      'Chi khach hang da nhan don thành công moi co the danh gia sản phẩm.';

  final RxMap<int, int> selectedAttributes = <int, int>{}.obs;

  bool get hasVariants => (productDetail?.variants ?? []).isNotEmpty;

  ProductVariantModel? get selectedVariant {
    final variants = productDetail?.variants ?? [];
    if (variants.isEmpty || !_hasSelectedAllAttributes) return null;

    final selectedIds = selectedAttributes.values.toList()..sort();

    for (final variant in variants) {
      final variantIds = List<int>.from(variant.attributeIds)..sort();
      if (variantIds.length == selectedIds.length &&
          variantIds.every((id) => selectedIds.contains(id))) {
        return variant;
      }
    }

    return null;
  }

  int? get selectedStockQuantity => selectedVariant?.quantity;

  bool get selectedVariantCanBuy {
    if (!hasVariants) return true;
    final variant = selectedVariant;
    return variant != null &&
        (variant.status ?? 0) == 1 &&
        (variant.quantity ?? 0) > 0;
  }

  double get currentDisplayPrice {
    final variantPrice = selectedVariant?.price ?? 0;
    if (variantPrice > 0) return variantPrice;

    final product = productDetail;
    return ((product?.priceSale ?? 0) > 0)
        ? product?.priceSale ?? 0
        : product?.price ?? 0;
  }

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

  Future<void> onRefresh() async {
    await Future.wait([
      getProductDetail(_currentProductId),
      getProductRatings(),
    ]);
  }

  void selectAttribute({
    required int attributeId,
    required int value,
  }) {
    selectedAttributes[attributeId] = value;
    final stock = selectedStockQuantity;
    if (stock != null && stock > 0 && quantity.value > stock) {
      quantity.value = stock;
    }
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

  bool canManageRating(ProductRatingModel rating) {
    final userId = Get.isRegistered<AccountController>()
        ? Get.find<AccountController>().user.value?.id
        : null;
    return userId != null && rating.userId == userId;
  }

  Future<void> showEditRatingDialog(ProductRatingModel rating) async {
    final id = _currentProductId;
    final ratingId = rating.id;
    if (id == null || ratingId == null) return;

    await Get.dialog<void>(
      EditRatingDialog(
        rating: rating,
        isSubmitting: ratingSubmitting,
        onSave: ({
          required fullname,
          required phone,
          required comment,
          required ratingValue,
        }) =>
            updateRating(
          productId: id,
          ratingId: ratingId,
          fullname: fullname,
          phone: phone,
          comment: comment,
          ratingValue: ratingValue,
        ),
      ),
    );
  }

  Future<void> updateRating({
    required int productId,
    required int ratingId,
    required String fullname,
    required String phone,
    required String comment,
    required int ratingValue,
  }) async {
    if (fullname.isEmpty) {
      Get.snackbar('Đánh giá', 'Vui lòng nhập họ tên.');
      return;
    }

    ratingSubmitting.value = true;
    final response = await _productsRepository.updateProductRating(
      productId,
      ratingId,
      {
        'fullname': fullname,
        'phone': phone,
        'comment': comment,
        'rating_value': ratingValue,
        'image_real': <String>[],
      },
    );

    response.fold(
      (error) {
        Get.snackbar('Danh gia', error.message);
      },
      (_) async {
        Get.back();
        Get.snackbar('Đánh giá', 'Cập nhật đánh giá thành công.');
        await getProductRatings();
      },
    );
    ratingSubmitting.value = false;
  }

  Future<void> confirmDeleteRating(ProductRatingModel rating) async {
    final id = _currentProductId;
    final ratingId = rating.id;
    if (id == null || ratingId == null) return;

    await Get.defaultDialog<void>(
      title: 'Xoá đánh giá',
      middleText: 'Bạn có chắc muốn xoá đánh giá này?',
      textCancel: 'Huỷ',
      textConfirm: 'Xoá',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        Get.back();
        await deleteRating(id, ratingId);
      },
    );
  }

  Future<void> deleteRating(int productId, int ratingId) async {
    ratingDeleting.value = true;
    final response =
        await _productsRepository.deleteProductRating(productId, ratingId);
    response.fold(
      (error) {
        Get.snackbar('Đánh giá', error.message);
      },
      (_) async {
        Get.snackbar('Đánh giá', 'Đã xoá đánh giá.');
        await getProductRatings();
      },
    );
    ratingDeleting.value = false;
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
        Get.snackbar('Đánh giá', error.message);
      },
      (_) async {
        ratingNameController.clear();
        ratingPhoneController.clear();
        ratingCommentController.clear();
        selectedRating.value = 5.0;
        Get.snackbar('Đánh giá', 'Đã gửi đánh giá sản phẩm.');
        await getProductRatings();
      },
    );
    ratingSubmitting.value = false;
  }

  int? getSelectedValue(int attributeId) {
    return selectedAttributes[attributeId];
  }

  void increaseQuantity() {
    final stock = selectedStockQuantity;
    if (stock != null && quantity.value >= stock) {
      Get.snackbar('Sản phẩm', 'Số lượng tồn kho không đủ.');
      return;
    }

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

  bool get hasSelectedAllAttributes => _hasSelectedAllAttributes;

  bool get canSubmitCartSelection {
    if (!_hasSelectedAllAttributes) return false;
    if (!hasVariants) return true;
    return selectedVariantCanBuy;
  }

  String get cartSelectionButtonTitle {
    if (!_hasSelectedAllAttributes) return 'Chọn phân loại';
    if (hasVariants && !selectedVariantCanBuy) return 'Hết hàng';
    return '';
  }

  Future<bool> addToCart() async {
    final product = productDetail;
    if (product?.id == null) return false;

    if (!await _ensureLoggedIn()) {
      return false;
    }

    if (!_hasSelectedAllAttributes) {
      Get.find<ToastWidget>().showToast(
        Get.context!,
        toastStatus: ToastStatus.warning,
        description: 'Vui lòng chọn đầy đủ phân loại sản phẩm.',
      );
      return false;
    }

    if (hasVariants && selectedVariant == null) {
      Get.find<ToastWidget>().showToast(
        Get.context!,
        toastStatus: ToastStatus.warning,
        description: 'Tổ hợp phân loại sản phẩm không tồn tại.',
      );
      return false;
    }

    if (!selectedVariantCanBuy) {
      Get.find<ToastWidget>().showToast(
        Get.context!,
        toastStatus: ToastStatus.warning,
        description: 'Phân loại sản phẩm này đang hết hàng hoặc tạm ngừng bán.',
      );
      return false;
    }

    cartLoading.value = true;
    try {
      final response = await apiService.addCartItem({
        'product_id': product!.id,
        'quantity': quantity.value,
        'attribute_name_id': selectedAttributes.keys.isEmpty
            ? null
            : selectedAttributes.keys.first,
        'attribute_ids': selectedAttributes.values.toList(),
        'product_variant_id': selectedVariant?.id,
      });
      cartController.setCart(response.data);

      Get.find<ToastWidget>().showToast(
        Get.context!,
        toastStatus: ToastStatus.success,
        description: 'Đã thêm sản phẩm vào giỏ hàng.',
      );
      return true;
    } catch (error) {
      Get.find<ToastWidget>().showToast(
        Get.context!,
        toastStatus: ToastStatus.fail,
        description: 'Không thể thêm sản phẩm vào giỏ hàng.',
      );
      return false;
    } finally {
      cartLoading.value = false;
    }
  }

  Future<bool> _ensureLoggedIn() async {
    final token = await secureStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      return true;
    }

    Get.find<ToastWidget>().showToast(
      Get.context!,
      title: 'Cảnh báo',
      toastStatus: ToastStatus.warning,
      description: 'Vui lòng đăng nhập để tiếp tục.',
    );
    return false;
  }

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
