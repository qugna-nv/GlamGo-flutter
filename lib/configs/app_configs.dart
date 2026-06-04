class AppConfigs {
  // static String hostUrl = 'http://192.168.1.252:8000';
  // static String hostUrl = 'http://192.168.0.108:8000';
  // static String hostUrl = 'http://192.168.1.20:8000';
  static String hostUrl = 'http://192.168.1.13:8000';
  static String apiUrl = '/api/v1';
  static String baseUrl = '$hostUrl$apiUrl';

  static const oneSignalAppId = 'f4519d4f-1741-40b1-b8b3-a34b04647cff';
  static const reverbAppKey = String.fromEnvironment(
    'REVERB_APP_KEY',
    defaultValue: 'glamgo-local-key',
  );
  static const reverbHost = String.fromEnvironment('REVERB_HOST');
  static const reverbPort =
      int.fromEnvironment('REVERB_PORT', defaultValue: 8080);
  static const reverbScheme = String.fromEnvironment(
    'REVERB_SCHEME',
    defaultValue: 'http',
  );

  static Uri get reverbWebSocketUri {
    final host = reverbHost.isEmpty ? Uri.parse(hostUrl).host : reverbHost;

    return Uri(
      scheme: reverbScheme == 'https' ? 'wss' : 'ws',
      host: host,
      port: reverbPort,
      path: '/app/$reverbAppKey',
      queryParameters: const {
        'protocol': '7',
        'client': 'flutter',
        'version': '1.0',
        'flash': 'false',
      },
    );
  }
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

class FavoriteAction {
  static const favorites = '/favorites';
  static String item(int productId) => '/favorites/$productId';
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

class ChatAction {
  static const messages = '/chat/messages';
  static const broadcastingAuth = '/broadcasting/auth';
}
