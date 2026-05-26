import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import 'package:project_shop/base/app_exception.dart';
import 'package:project_shop/data/api_service/api_service.dart';
import 'package:project_shop/data/base/base_response.dart';
import 'package:project_shop/data/response_models/products/product_rating_model.dart';
import 'package:project_shop/data/response_models/products/products_model.dart';

abstract class IProductsRepository {
  Future<Either<AppException, BaseResponse<List<ProductImage>>>> getBanner();

  Future<Either<AppException, BaseResponse<List<ProductsModel>>>> getProducts();

  Future<Either<AppException, BaseResponse<List<ProductsModel>>>>
      getProductsByCategory(int? categoryId);

  Future<Either<AppException, BaseResponse<ProductsModel>>> getProductDetail(
      int? productId);

  Future<Either<AppException, BaseResponse<ProductRatingResponse>>>
      getProductRatings(int productId);

  Future<Either<AppException, BaseResponse<ProductRatingModel>>>
      createProductRating(int productId, Map<String, dynamic> body);
}

class ProductsRepository implements IProductsRepository {
  final ApiService _apiService = Get.find();

  @override
  Future<Either<AppException, BaseResponse<List<ProductImage>>>>
      getBanner() async {
    try {
      final response = await _apiService.getBanner();
      if (response.errorCode != 200) {
        return Left(AppException(message: response.message.toString()));
      }
      return Right(response);
    } catch (e) {
      return Left(AppException(message: _getErrorMessage(e)));
    }
  }

  @override
  Future<Either<AppException, BaseResponse<List<ProductsModel>>>>
      getProducts() async {
    try {
      final response = await _apiService.getProducts();
      if (response.errorCode != 200) {
        return Left(AppException(message: response.message.toString()));
      }
      return Right(response);
    } catch (e) {
      return Left(AppException(message: _getErrorMessage(e)));
    }
  }

  @override
  Future<Either<AppException, BaseResponse<List<ProductsModel>>>>
      getProductsByCategory(int? categoryId) async {
    try {
      final response = await _apiService.getProductsByCategory(categoryId);
      if (response.errorCode != 200) {
        return Left(AppException(message: response.message.toString()));
      }
      return Right(response);
    } catch (e) {
      return Left(AppException(message: _getErrorMessage(e)));
    }
  }

  @override
  Future<Either<AppException, BaseResponse<ProductsModel>>> getProductDetail(
      int? productId) async {
    try {
      final response = await _apiService.getProductDetail(productId);
      if (response.errorCode != 200) {
        return Left(AppException(message: response.message.toString()));
      }
      return Right(response);
    } catch (e) {
      return Left(AppException(message: _getErrorMessage(e)));
    }
  }

  @override
  Future<Either<AppException, BaseResponse<ProductRatingResponse>>>
      getProductRatings(int productId) async {
    try {
      final response = await _apiService.getProductRatings(productId);
      if (response.errorCode != 200) {
        return Left(AppException(message: response.message.toString()));
      }
      return Right(response);
    } catch (e) {
      return Left(AppException(message: _getErrorMessage(e)));
    }
  }

  @override
  Future<Either<AppException, BaseResponse<ProductRatingModel>>>
      createProductRating(int productId, Map<String, dynamic> body) async {
    try {
      final response = await _apiService.createProductRating(productId, body);
      if (response.errorCode != 201) {
        return Left(AppException(message: response.message.toString()));
      }
      return Right(response);
    } catch (e) {
      return Left(AppException(message: _getErrorMessage(e)));
    }
  }

  String _getErrorMessage(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        return data['message']?.toString() ?? 'Co loi xay ra.';
      }
    }

    return error.toString();
  }
}
