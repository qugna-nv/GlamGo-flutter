import 'package:get/get.dart';
import 'package:project_shop/features/product_review/product_review_controller.dart';

class ProductReviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductReviewController());
  }
}
