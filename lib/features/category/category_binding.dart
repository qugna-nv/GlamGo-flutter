import 'package:get/get.dart';
import 'package:project_shop/data/repository/categories_action/categories_repository.dart';
import 'package:project_shop/data/repository/products_action/products_repository.dart';
import 'package:project_shop/features/category/category_controller.dart';

class CategoryBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<CategoriesRepository>(() => CategoriesRepository());
    Get.lazyPut<CategoryController>(() => CategoryController());
    Get.put(CategoriesRepository());
    Get.put(ProductsRepository());
  }
}
