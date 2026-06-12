import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_shop/base/base_controller.dart';
import 'package:project_shop/data/api_service/api_service.dart';
import 'package:project_shop/data/response_models/orders/order_model.dart';
import 'package:project_shop/widgets/appbar_custom/common_snackbar.dart';
import 'package:project_shop/widgets/common/toast_widget.dart';

class ProductReviewController extends BaseController {
  final ApiService apiService = Get.find();
  final OrderItemModel? item =
      Get.arguments is OrderItemModel ? Get.arguments as OrderItemModel : null;

  final rating = 5.0.obs;
  final commentController = TextEditingController();
  final submitting = false.obs;

  Future<void> submitReview() async {
    if (item?.canReview == false) {
      Get.find<ToastWidget>().showToast(
        Get.context!,
        title: 'Cảnh báo',
        toastStatus: ToastStatus.warning,
        description: item?.hasReviewed == true
            ? 'Bạn đã đánh giá sản phẩm này rồi.'
            : 'Sản phẩm này chưa thể đánh giá.',
      );
      return;
    }

    final productId = item?.productId;
    if (productId == null || productId <= 0) {
      Get.find<ToastWidget>().showToast(
        Get.context!,
        title: 'Thất bại',
        toastStatus: ToastStatus.fail,
        description: 'Không tìm thấy sản phẩm cần đánh giá.',
      );
      return;
    }

    submitting.value = true;
    try {
      await apiService.createProductRating(productId, {
        'rating_value': rating.value.round(),
        'comment': commentController.text.trim(),
        'image_real': <String>[],
      });

      Get.find<ToastWidget>().showToast(
        Get.context!,
        title: 'Thành công',
        toastStatus: ToastStatus.success,
        description: 'Gửi đánh giá sản phẩm thành công',
      );
      Get.back(result: true);
    } catch (error) {
      Get.find<ToastWidget>().showToast(
        Get.context!,
        title: 'Thất bại',
        toastStatus: ToastStatus.fail,
        description: _getErrorMessage(error),
      );
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
