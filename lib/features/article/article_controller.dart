import 'package:get/get.dart';
import 'package:project_shop/base/app_exception.dart';
import 'package:project_shop/base/base_controller.dart';
import 'package:project_shop/data/repository/categories_action/categories_repository.dart';
import 'package:project_shop/data/response_models/article/article_model.dart';
import 'package:project_shop/data/response_models/categories/category_model.dart';

class ArticleController extends BaseController {
  static const int _pageSize = 20;

  final _categoriesRepository = Get.find<CategoriesRepository>();

  @override
  void onInit() {
    getCategoriesArticle();
    getArticle(1, null);
    super.onInit();
  }

  final RxList<CategoryModel> _listCategoriesArticle = <CategoryModel>[].obs;
  List<CategoryModel> get listCategoriesArticle => _listCategoriesArticle;

  final RxList<ArticleModel> _listArticle = <ArticleModel>[].obs;
  List<ArticleModel> get listArticle => _listArticle;

  final _selectedIndex = 0.obs;
  get selectedIndex => _selectedIndex.value;

  void selectCategoryArticle({required int index, int? categoryArticleId}) {
    _selectedIndex.value = index;
    if (categoryArticleId == null) {
      getArticle(1, null);
    } else {
      getArticle(0, categoryArticleId);
    }
  }

  Future<void> getCategoriesArticle() async {
    isLoading.value = true;
    try {
      final response = await _categoriesRepository.getCategoriesArticle();
      response.fold(
        (error) {
          appException.value = error;
          isLoading.value = false;
        },
        (result) {
          _listCategoriesArticle.assignAll(result.data ?? []);
          isLoading.value = false;
        },
      );
    } catch (e) {
      appException.value = AppException(message: e.toString());
      isLoading.value = false;
    }
  }

  Future<void> getArticle(int? isHot, int? categoriesArticleId) async {
    try {
      final response = await _categoriesRepository.getArticle(
        isHot,
        categoriesArticleId,
        perPage: _pageSize,
      );
      response.fold(
        (error) {
          appException.value = error;
          isLoading.value = false;
        },
        (result) {
          _listArticle.assignAll(result.data ?? []);
          // isLoading.value = false;
        },
      );
    } catch (e) {
      appException.value = AppException(message: e.toString());
      isLoading.value = false;
    }
  }
}
