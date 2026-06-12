import 'dart:io';

import 'package:dio/dio.dart';
import 'package:project_shop/configs/app_configs.dart';
import 'package:project_shop/data/base/base_response.dart';
import 'package:project_shop/data/response_models/article/article_model.dart';
import 'package:project_shop/data/response_models/auth/auth_response.dart';
import 'package:project_shop/data/response_models/address/address_model.dart';
import 'package:project_shop/data/response_models/cart/cart_model.dart';
import 'package:project_shop/data/response_models/chat/chat_model.dart';
import 'package:project_shop/data/response_models/categories/category_model.dart';
import 'package:project_shop/data/response_models/notification/notification_model.dart';
import 'package:project_shop/data/response_models/orders/order_model.dart';
import 'package:project_shop/data/response_models/products/product_rating_model.dart';
import 'package:project_shop/data/response_models/products/products_model.dart';
import 'package:project_shop/data/response_models/user/user_model.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET(CategoryAction.getCategories)
  Future<BaseResponse<List<CategoryModel>>> getCategories();

  @GET(ProductsAction.getProducts)
  Future<BaseResponse<List<ProductsModel>>> getProducts(
    @Query("page") int? page,
    @Query("per_page") int? perPage,
  );

  @GET(ProductsAction.getFeaturedProducts)
  Future<BaseResponse<List<ProductsModel>>> getFeaturedProducts(
    @Query("page") int? page,
    @Query("per_page") int? perPage,
  );

  @GET(ProductsAction.getRecommendedProducts)
  Future<BaseResponse<List<ProductsModel>>> getRecommendedProducts(
    @Query("page") int? page,
    @Query("per_page") int? perPage,
  );

  @GET(ProductsAction.getProductsByCategory)
  Future<BaseResponse<List<ProductsModel>>> getProductsByCategory(
    @Query("category_id") int? categoryId,
    @Query("page") int? page,
    @Query("per_page") int? perPage,
  );

  @GET(ProductsAction.getProductDetail)
  Future<BaseResponse<ProductsModel>> getProductDetail(
      @Query("id") int? productId);

  @GET(FavoriteAction.favorites)
  Future<BaseResponse<List<ProductsModel>>> getFavoriteProducts();

  @POST('/favorites/{productId}')
  Future<BaseResponse<ProductsModel>> addFavoriteProduct(
    @Path('productId') int productId,
  );

  @DELETE('/favorites/{productId}')
  Future<BaseResponse<dynamic>> removeFavoriteProduct(
    @Path('productId') int productId,
  );

  @GET('/products/{id}/ratings')
  Future<BaseResponse<ProductRatingResponse>> getProductRatings(
    @Path('id') int id,
  );

  @POST('/products/{id}/ratings')
  Future<BaseResponse<ProductRatingModel>> createProductRating(
    @Path('id') int id,
    @Body() Map<String, dynamic> body,
  );

  @PUT('/products/{id}/ratings/{ratingId}')
  Future<BaseResponse<ProductRatingModel>> updateProductRating(
    @Path('id') int id,
    @Path('ratingId') int ratingId,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/products/{id}/ratings/{ratingId}')
  Future<BaseResponse<dynamic>> deleteProductRating(
    @Path('id') int id,
    @Path('ratingId') int ratingId,
  );

  @GET(ArticleAction.getArticle)
  Future<BaseResponse<List<ArticleModel>>> getArticle(
    @Query("is_hot") int? isHot,
    @Query("category_artical_id") int? categoryArticleId,
    @Query("page") int? page,
    @Query("per_page") int? perPage,
  );

  @GET(ArticleAction.getCategoriesArticle)
  Future<BaseResponse<List<CategoryModel>>> getCategoriesArticle();

  @GET(ImageAction.getBanner)
  Future<BaseResponse<List<ProductImage>>> getBanner();

  @POST(AuthAction.login)
  Future<BaseResponse<AuthResponse>> login(@Body() Map<String, dynamic> body);

  @POST(AuthAction.register)
  Future<BaseResponse<AuthResponse>> register(
      @Body() Map<String, dynamic> body);

  @GET(AuthAction.me)
  Future<BaseResponse<UserModel>> getCurrentUser();

  @MultiPart()
  @POST('/auth/profile')
  Future<BaseResponse<UserModel>> updateProfile(
    @Part(name: 'name') String? name,
    @Part(name: 'phone') String? phone,
    @Part(name: 'avatar') File? avatar,
  );

  @POST('/auth/wallet/top-up')
  Future<BaseResponse<dynamic>> topUpWallet(
    @Body() Map<String, dynamic> body,
  );

  @POST('/auth/push-subscription')
  Future<BaseResponse<dynamic>> syncPushSubscription(
    @Body() Map<String, dynamic> body,
  );

  @GET(AddressAction.addresses)
  Future<BaseResponse<List<AddressModel>>> getAddresses();

  @POST(AddressAction.addresses)
  Future<BaseResponse<AddressModel>> createAddress(
      @Body() Map<String, dynamic> body);

  @PUT('/addresses/{id}')
  Future<BaseResponse<AddressModel>> updateAddress(
    @Path('id') int id,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/addresses/{id}')
  Future<BaseResponse<dynamic>> deleteAddress(@Path('id') int id);

  @POST('/addresses/{id}/default')
  Future<BaseResponse<AddressModel>> setDefaultAddress(@Path('id') int id);

  @GET(CartAction.cart)
  Future<BaseResponse<CartModel>> getCart();

  @POST(CartAction.items)
  Future<BaseResponse<CartModel>> addCartItem(
      @Body() Map<String, dynamic> body);

  @PUT('/cart/items/{id}')
  Future<BaseResponse<CartModel>> updateCartItem(
    @Path('id') int id,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/cart/items/{id}')
  Future<BaseResponse<CartModel>> deleteCartItem(@Path('id') int id);

  @DELETE(CartAction.clear)
  Future<BaseResponse<CartModel>> clearCart();

  @GET(OrderAction.orders)
  Future<BaseResponse<OrderPaginationModel>> getOrders(
    @Query('status') int? status,
  );

  @GET('/orders/{id}')
  Future<BaseResponse<OrderDetailModel>> getOrderDetail(@Path('id') int id);

  @POST(OrderAction.checkout)
  Future<BaseResponse<OrderDetailModel>> checkout(
      @Body() Map<String, dynamic> body);

  @POST('/orders/{id}/cancel')
  Future<BaseResponse<OrderSummaryModel>> cancelOrder(@Path('id') int id);

  @GET(ChatAction.messages)
  Future<BaseResponse<ChatThreadModel>> getChatMessages();

  @MultiPart()
  @POST(ChatAction.messages)
  Future<BaseResponse<ChatMessageModel>> sendChatMessage(
    @Part(name: 'message') String? message,
    @Part(name: 'file') File? file,
  );

  @POST(ChatAction.broadcastingAuth)
  Future<dynamic> authorizeChatChannel(@Body() Map<String, dynamic> body);

  @GET(NotificationAction.notifications)
  Future<NotificationListResponse> getNotifications(
    @Query('per_page') int? perPage,
  );

  @POST('/notifications/{id}/read')
  Future<NotificationReadResponse> markNotificationAsRead(
    @Path('id') String id,
  );

  @POST(NotificationAction.markAllAsRead)
  Future<NotificationMarkAllResponse> markAllNotificationsAsRead();
}
