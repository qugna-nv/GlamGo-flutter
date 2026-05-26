import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:project_shop/features/article/article_binding.dart';
import 'package:project_shop/features/article/article_detail/article_detail_page.dart';
import 'package:project_shop/features/article/article_page.dart';
import 'package:project_shop/features/address/address_binding.dart';
import 'package:project_shop/features/address/address_page.dart';
import 'package:project_shop/features/cart/cart_binding.dart';
import 'package:project_shop/features/cart/cart_page.dart';
import 'package:project_shop/features/checkout/checkout_binding.dart';
import 'package:project_shop/features/checkout/checkout_page.dart';
import 'package:project_shop/features/category/category_binding.dart';
import 'package:project_shop/features/category/category_page.dart';
import 'package:project_shop/features/home/home_binding.dart';
import 'package:project_shop/features/home/home_page.dart';
import 'package:project_shop/features/login/login_binding.dart';
import 'package:project_shop/features/login/login_page.dart';
import 'package:project_shop/features/navigation/main_screen_binding.dart';
import 'package:project_shop/features/navigation/main_screen.dart';
import 'package:project_shop/features/onboarding/onboarding_binding.dart';
import 'package:project_shop/features/onboarding/onboarding_page.dart';
import 'package:project_shop/features/order/order_binding.dart';
import 'package:project_shop/features/order/order_page.dart';
import 'package:project_shop/features/products/products_detail/product_detail_binding.dart';
import 'package:project_shop/features/products/products_detail/product_detail_page.dart';
import 'package:project_shop/features/splash/splash_binding.dart';
import 'package:project_shop/features/splash/splash_page.dart';
import 'package:project_shop/features/wishlist/wish_list_binding.dart';
import 'package:project_shop/features/wishlist/wish_list_page.dart';
import 'package:project_shop/routes/app_routes.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.login,
      binding: LoginBinding(),
      page: () => LoginPage(),
    ),
    GetPage(
      name: Routes.splash,
      binding: SplashBinding(),
      page: () => SplashPage(),
    ),
    GetPage(
      name: Routes.onboarding,
      binding: OnboardingBinding(),
      page: () => OnboardingScreen(),
    ),
    GetPage(
      name: Routes.initPage,
      binding: MainScreenBinding(),
      page: () => MainScreen(),
      transition: Transition.cupertino,
      transitionDuration: Duration(seconds: 1),
    ),
    GetPage(
      name: Routes.home,
      binding: HomeBinding(),
      page: () => HomePage(),
      // transition: Transition.cupertino,
      // transitionDuration: Duration(seconds: 1),
    ),
    GetPage(
      name: Routes.wishlist,
      binding: WishListBinding(),
      page: () => WishListPage(),
      // transition: Transition.cupertino,
      // transitionDuration: Duration(seconds: 1),
    ),
    GetPage(
      name: Routes.cart,
      binding: CartBinding(),
      page: () => CartPage(),
      // transition: Transition.cupertino,
      // transitionDuration: Duration(seconds: 1),
    ),
    GetPage(
      name: Routes.checkout,
      binding: CheckoutBinding(),
      page: () => const CheckoutPage(),
    ),
    GetPage(
      name: Routes.orders,
      binding: OrderBinding(),
      page: () => const OrderPage(),
    ),
    GetPage(
      name: Routes.addresses,
      binding: AddressBinding(),
      page: () => const AddressPage(),
    ),
    GetPage(
      name: Routes.categories,
      binding: CategoryBinding(),
      page: () => CategoryPage(),
      // transition: Transition.cupertino,
      // transitionDuration: Duration(seconds: 1),
    ),
    GetPage(
      name: Routes.productDetail,
      binding: ProductDetailBinding(),
      page: () => ProductDetailPage(),
      // transition: Transition.cupertino,
      // transitionDuration: Duration(seconds: 1),
    ),
    GetPage(
      name: Routes.article,
      binding: ArticleBinding(),
      page: () => ArticlePage(),
    ),
    GetPage(
      name: Routes.articleDetail,
      page: () => ArticleDetailPage(),
    ),
  ];
}
