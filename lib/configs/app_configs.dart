class AppConfigs {
  // static String hostUrl = 'http://192.168.1.252:8000';
  static String hostUrl = 'http://192.168.1.13:8000';
  // static String hostUrl = 'http://localhost:8000';
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
}

class ArticleAction {
  static const getArticle = '/artical';
  static const getCategoriesArticle = '/artical/categories';
}
