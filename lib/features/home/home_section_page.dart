import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_shop/base/util/utils.dart';
import 'package:project_shop/data/repository/categories_action/categories_repository.dart';
import 'package:project_shop/data/repository/products_action/products_repository.dart';
import 'package:project_shop/data/response_models/article/article_model.dart';
import 'package:project_shop/data/response_models/products/products_model.dart';
import 'package:project_shop/features/article/widgets/item_article.dart';
import 'package:project_shop/features/products/widget/products_item_view.dart';
import 'package:project_shop/features/wishlist/wish_list_controller.dart';
import 'package:project_shop/routes/app_routes.dart';

enum HomeSectionType {
  featured,
  recommended,
  hotArticles,
}

class HomeSectionArguments {
  const HomeSectionArguments({
    required this.title,
    required this.type,
    this.products = const [],
    this.articles = const [],
  });

  final String title;
  final HomeSectionType type;
  final List<ProductsModel> products;
  final List<ArticleModel> articles;

  bool get isArticleSection => type == HomeSectionType.hotArticles;
}

class HomeSectionPage extends StatefulWidget {
  const HomeSectionPage({super.key});

  @override
  State<HomeSectionPage> createState() => _HomeSectionPageState();
}

class _HomeSectionPageState extends State<HomeSectionPage> {
  static const int _pageSize = 20;

  final ScrollController _scrollController = ScrollController();
  final ProductsRepository _productsRepository = Get.find();
  final CategoriesRepository _categoriesRepository = Get.find();

  late final HomeSectionArguments _args;
  late final List<ProductsModel> _products;
  late final List<ArticleModel> _articles;

  int _currentPage = 1;
  int _lastPage = 2;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _args = Get.arguments is HomeSectionArguments
        ? Get.arguments as HomeSectionArguments
        : const HomeSectionArguments(
            title: 'Danh sách',
            type: HomeSectionType.featured,
          );
    _products = List<ProductsModel>.from(_args.products);
    _articles = List<ArticleModel>.from(_args.articles);
    _lastPage =
        (_args.isArticleSection ? _articles.length : _products.length) >= 20
            ? 2
            : 1;
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || _currentPage >= _lastPage) {
      return;
    }

    setState(() {
      _isLoadingMore = true;
    });

    final nextPage = _currentPage + 1;

    try {
      if (_args.type == HomeSectionType.hotArticles) {
        final response = await _categoriesRepository.getArticle(
          1,
          null,
          page: nextPage,
          perPage: _pageSize,
        );
        response.fold(
          (_) {},
          (result) {
            _articles.addAll(result.data ?? []);
            _currentPage = result.currentPage ?? nextPage;
            _lastPage = result.lastPage ?? _currentPage;
          },
        );
      } else {
        final response = _args.type == HomeSectionType.featured
            ? await _productsRepository.getFeaturedProducts(
                page: nextPage,
                perPage: _pageSize,
              )
            : await _productsRepository.getRecommendedProducts(
                page: nextPage,
                perPage: _pageSize,
              );
        response.fold(
          (_) {},
          (result) {
            _products.addAll(result.data ?? []);
            _currentPage = result.currentPage ?? nextPage;
            _lastPage = result.lastPage ?? _currentPage;
          },
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_args.title),
      ),
      body: _args.isArticleSection
          ? _ArticleList(
              articles: _articles,
              controller: _scrollController,
              isLoadingMore: _isLoadingMore,
            )
          : _ProductGrid(
              products: _products,
              controller: _scrollController,
              isLoadingMore: _isLoadingMore,
            ),
    );
  }
}

class _ProductGrid extends StatelessWidget {
  const _ProductGrid({
    required this.products,
    required this.controller,
    required this.isLoadingMore,
  });

  final List<ProductsModel> products;
  final ScrollController controller;
  final bool isLoadingMore;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(child: Text('Không có sản phẩm nào'));
    }

    final wishListController = Get.find<WishListController>();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.builder(
        controller: controller,
        itemCount: products.length + (isLoadingMore ? 1 : 0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          mainAxisExtent: 330,
        ),
        itemBuilder: (context, index) {
          if (index >= products.length) {
            return const Center(child: CircularProgressIndicator());
          }

          final product = products[index];
          return GestureDetector(
            onTap: () {
              Get.toNamed(Routes.productDetail, arguments: product.id);
            },
            child: Obx(
              () => ProductsItemView(
                name: product.name,
                path: Utils.I.getImageFullPath(product.image ?? ''),
                price: Utils.I.formatCurrency(product.price ?? 0.0),
                priceSale: Utils.I.formatCurrency(product.priceSale ?? 0.0),
                onTap: () => wishListController.toggleFavorite(product),
                isWishList: wishListController.isFavorite(product),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ArticleList extends StatelessWidget {
  const _ArticleList({
    required this.articles,
    required this.controller,
    required this.isLoadingMore,
  });

  final List<ArticleModel> articles;
  final ScrollController controller;
  final bool isLoadingMore;

  @override
  Widget build(BuildContext context) {
    if (articles.isEmpty) {
      return const Center(child: Text('Không có bài viết nào'));
    }

    return ListView.separated(
      controller: controller,
      padding: const EdgeInsets.all(12),
      itemCount: articles.length + (isLoadingMore ? 1 : 0),
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        if (index >= articles.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final article = articles[index];
        return ItemArticle(
          path: Utils.I.getImageFullPath(article.image ?? ''),
          titleNews: article.title ?? '',
          description: article.metaDescription ?? '',
          radius: 12,
          heightImg: 92,
          widthImg: 112,
          titleStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          descriptionStyle: const TextStyle(
            fontSize: 13,
            color: Colors.black54,
          ),
          onTap: () {
            Get.toNamed(Routes.articleDetail, arguments: article);
          },
        );
      },
    );
  }
}
