class AppConfigs {
  static String hostUrl = 'http://192.168.1.252:8000';
  // static String hostUrl = 'http://192.168.0.108:8000';
  // static String hostUrl = 'http://192.168.1.20:8000';
  // static String hostUrl = 'http://192.168.1.11:8000';
  static String apiUrl = '/api/v1';
  static String baseUrl = '$hostUrl$apiUrl';

  static const oneSignalAppId = 'f4519d4f-1741-40b1-b8b3-a34b04647cff';
}

class ImageAction {
  static const getBanner = '/get-banner';
}

class CategoryAction {
  static const getCategories = '/categories';
}

class ProductsAction {
  static const getProducts = '/products';
  static const getProductsByCategory = '/products/get-products-by-category';
  static const getProductDetail = '/products/get-products-details';
  static String productRatings(int id) => '/products/$id/ratings';
}

class ArticleAction {
  static const getArticle = '/artical';
  static const getCategoriesArticle = '/artical/categories';
}

class AuthAction {
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const me = '/auth/me';
  static const logout = '/auth/logout';
}

class CartAction {
  static const cart = '/cart';
  static const items = '/cart/items';
  static String item(int id) => '/cart/items/$id';
  static const clear = '/cart/clear';
}

class OrderAction {
  static const orders = '/orders';
  static const checkout = '/orders/checkout';
  static String detail(int id) => '/orders/$id';
  static String cancel(int id) => '/orders/$id/cancel';
}

class AddressAction {
  static const addresses = '/addresses';
  static String item(int id) => '/addresses/$id';
  static String setDefault(int id) => '/addresses/$id/default';
}
