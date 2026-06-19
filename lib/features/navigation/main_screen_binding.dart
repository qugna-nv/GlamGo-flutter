import 'package:get/get.dart';
import 'package:project_shop/data/repository/categories_action/categories_repository.dart';
import 'package:project_shop/data/repository/products_action/products_repository.dart';
import 'package:project_shop/features/account/account_controller.dart';
import 'package:project_shop/features/article/article_controller.dart';
import 'package:project_shop/features/cart/cart_controller.dart';
import 'package:project_shop/features/category/category_controller.dart';
import 'package:project_shop/features/home/home_controller.dart';
import 'package:project_shop/features/navigation/main_screen_controller.dart';
import 'package:project_shop/features/notification/notification_controller.dart';
import 'package:project_shop/features/wishlist/wish_list_controller.dart';

class MainScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainScreenController());
    Get.lazyPut(() => CategoriesRepository());
    Get.lazyPut(() => ProductsRepository());
    Get.lazyPut(() => CartController(), fenix: true);
    Get.lazyPut(() => HomeController());
    if (!Get.isRegistered<NotificationController>()) {
      Get.lazyPut(() => NotificationController(), fenix: true);
    }
    // Get.put(HomeController());
    Get.lazyPut(() => CategoryController());
    Get.lazyPut(() => WishListController());
    if (!Get.isRegistered<AccountController>()) {
      Get.put(AccountController(), permanent: true);
    }
    Get.lazyPut(() => ArticleController());
  }
}
