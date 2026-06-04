import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_shop/base/base_controller.dart';
import 'package:project_shop/data/api_service/api_service.dart';
import 'package:project_shop/data/response_models/orders/order_model.dart';

class ProductReviewController extends BaseController {
  final ApiService apiService = Get.find();
  final OrderItemModel? item =
      Get.arguments is OrderItemModel ? Get.arguments as OrderItemModel : null;

  final rating = 5.0.obs;
  final commentController = TextEditingController();
  final submitting = false.obs;

  Future<void> submitReview() async {
    final productId = item?.productId;
    if (productId == null || productId <= 0) {
      Get.snackbar('Danh gia', 'Khong tim thay sản phẩm can danh gia.');
      return;
    }

    submitting.value = true;
    try {
      await apiService.createProductRating(productId, {
        'rating_value': rating.value.round(),
        'comment': commentController.text.trim(),
        'image_real': <String>[],
      });

      Get.snackbar('Danh gia', 'Da gui danh gia sản phẩm.');
      Get.back(result: true);
    } catch (error) {
      Get.snackbar('Danh gia', _getErrorMessage(error));
    } finally {
      submitting.value = false;
    }
  }

  String _getErrorMessage(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        return data['message']?.toString() ?? 'Có lỗi xảy ra.';
      }
    }

    return 'Có lỗi xảy ra.';
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }
}
