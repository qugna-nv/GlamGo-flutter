import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfigs {
  static String hostUrl = dotenv.env['HOST_URL']?.trim().isNotEmpty == true
      ? dotenv.env['HOST_URL']!.trim()
      : 'http://192.168.1.13:8000';
  static String apiUrl = dotenv.env['API_URL']?.trim().isNotEmpty == true
      ? dotenv.env['API_URL']!.trim()
      : '/api/v1';
  static String baseUrl = '$hostUrl$apiUrl';

  static String oneSignalAppId =
      dotenv.env['ONESIGNAL_APP_ID']?.trim().isNotEmpty == true
          ? dotenv.env['ONESIGNAL_APP_ID']!.trim()
          : '';
  static String reverbAppKey =
      dotenv.env['REVERB_APP_KEY']?.trim().isNotEmpty == true
          ? dotenv.env['REVERB_APP_KEY']!.trim()
          : 'glamgo-local-key';
  static String reverbHost =
      dotenv.env['REVERB_HOST']?.trim().isNotEmpty == true
          ? dotenv.env['REVERB_HOST']!.trim()
          : '';
  static int reverbPort =
      int.tryParse(dotenv.env['REVERB_PORT']?.trim() ?? '') ?? 8080;
  static String reverbScheme =
      dotenv.env['REVERB_SCHEME']?.trim().isNotEmpty == true
          ? dotenv.env['REVERB_SCHEME']!.trim()
          : 'http';

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
  static const getFeaturedProducts = '/products/featured';
  static const getRecommendedProducts = '/products/recommended';
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

class NotificationAction {
  static const notifications = '/notifications';
  static const markAllAsRead = '/notifications/read-all';
  static String markAsRead(String id) => '/notifications/$id/read';
}
