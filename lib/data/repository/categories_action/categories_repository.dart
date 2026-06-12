import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import 'package:project_shop/base/app_exception.dart';
import 'package:project_shop/data/api_service/api_service.dart';
import 'package:project_shop/data/base/base_response.dart';
import 'package:project_shop/data/response_models/article/article_model.dart';
import 'package:project_shop/data/response_models/categories/category_model.dart';
import 'package:project_shop/data/response_models/products/products_model.dart';

abstract class ICategoriesRepository {
  // Future<Either<AppException, BaseResponse<List<ProductImage>>>> getBanner();

  Future<Either<AppException, BaseResponse<List<CategoryModel>>>>
      getCategories();

  // Future<Either<AppException, BaseResponse<List<ProductsModel>>>> getProducts();

  // Future<Either<AppException, BaseResponse<List<ProductsModel>>>>
  //     getProductsByCategory(int? categoryId);

  // Future<Either<AppException, BaseResponse<ProductsModel>>> getProductDetail(
  //     int? productId);

  Future<Either<AppException, BaseResponse<List<ArticleModel>>>> getArticle(
    int? isHote,
    int? categoryArticleId, {
    int? page,
    int? perPage,
  });

  Future<Either<AppException, BaseResponse<List<CategoryModel>>>>
      getCategoriesArticle();
}

class CategoriesRepository implements ICategoriesRepository {
  final ApiService _apiService = Get.find();

  @override
  Future<Either<AppException, BaseResponse<List<CategoryModel>>>>
      getCategories() async {
    try {
      final response = await _apiService.getCategories();
      if (response.errorCode != 200) {
        return Left(AppException(message: response.message.toString()));
      }
      return Right(response);
    } catch (e) {
      return Left(AppException(message: e.toString()));
    }
  }

  // @override
  // Future<Either<AppException, BaseResponse<List<ProductsModel>>>>
  //     getProducts() async {
  //   try {
  //     final response = await _apiService.getProducts();
  //     if (response.errorCode != 200) {
  //       return Left(AppException(message: response.message.toString()));
  //     }
  //     return Right(response);
  //   } catch (e) {
  //     return Left(AppException(message: e.toString()));
  //   }
  // }

  // @override
  // Future<Either<AppException, BaseResponse<List<ProductsModel>>>>
  //     getProductsByCategory(int? categoryId) async {
  //   try {
  //     final response = await _apiService.getProductsByCategory(categoryId);
  //     if (response.errorCode != 200) {
  //       return Left(AppException(message: response.message.toString()));
  //     }
  //     return Right(response);
  //   } catch (e) {
  //     return Left(AppException(message: e.toString()));
  //   }
  // }

  // @override
  // Future<Either<AppException, BaseResponse<ProductsModel>>> getProductDetail(
  //     int? productId) async {
  //   try {
  //     final response = await _apiService.getProductDetail(productId);
  //     if (response.errorCode != 200) {
  //       return Left(AppException(message: response.message.toString()));
  //     }
  //     return Right(response);
  //   } catch (e) {
  //     return Left(AppException(message: e.toString()));
  //   }
  // }

  @override
  Future<Either<AppException, BaseResponse<List<ArticleModel>>>> getArticle(
    int? isHot,
    int? categoryArticleId, {
    int? page,
    int? perPage,
  }) async {
    try {
      final response =
          await _apiService.getArticle(isHot, categoryArticleId, page, perPage);
      if (response.errorCode != 200) {
        return Left(AppException(message: response.message.toString()));
      }
      return Right(response);
    } catch (e) {
      return Left(AppException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, BaseResponse<List<CategoryModel>>>>
      getCategoriesArticle() async {
    try {
      final response = await _apiService.getCategoriesArticle();
      if (response.errorCode != 200) {
        return Left(AppException(message: response.message.toString()));
      }
      return Right(response);
    } catch (e) {
      return Left(AppException(message: e.toString()));
    }
  }

  Future<dynamic> getBanner() async {}

  // @override
  // Future<Either<AppException, BaseResponse<List<ProductImage>>>>
  //     getBanner() async {
  //   try {
  //     final response = await _apiService.getBanner();
  //     if (response.errorCode != 200) {
  //       return Left(AppException(message: response.message.toString()));
  //     }
  //     return Right(response);
  //   } catch (e) {
  //     return Left(AppException(message: e.toString()));
  //   }
  // }
}
