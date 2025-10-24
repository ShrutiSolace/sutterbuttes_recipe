class SearchResultModel {
  final bool success;
  final String query;
  final SearchResults results;

  SearchResultModel({
    required this.success,
    required this.query,
    required this.results,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      success: json['success'] ?? false,
      query: json['query'] ?? '',
      results: SearchResults.fromJson(json['results'] ?? {}),
    );
  }
}

class SearchResults {
  final List<SearchRecipe> recipes;
  final List<SearchProduct> products;

  SearchResults({
    required this.recipes,
    required this.products,
  });

  factory SearchResults.fromJson(Map<String, dynamic> json) {
    return SearchResults(
      recipes: (json['recipes'] as List?)
          ?.map((item) => SearchRecipe.fromJson(item))
          .toList() ?? [],
      products: (json['products'] as List?)
          ?.map((item) => SearchProduct.fromJson(item))
          .toList() ?? [],
    );
  }
}

class SearchRecipe {
  final int id;
  final String title;
  final String excerpt;
  final String link;
  final String image;

  SearchRecipe({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.link,
    required this.image,
  });

  factory SearchRecipe.fromJson(Map<String, dynamic> json) {
    return SearchRecipe(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      excerpt: json['excerpt'] ?? '',
      link: json['link'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class SearchProduct {
  final int id;
  final String title;
  final String price;
  final String link;
  final String image;

  SearchProduct({
    required this.id,
    required this.title,
    required this.price,
    required this.link,
    required this.image,
  });

  factory SearchProduct.fromJson(Map<String, dynamic> json) {
    return SearchProduct(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      price: json['price'] ?? '',
      link: json['link'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

// Union type for displaying both recipes and products in the same list
abstract class SearchItem {
  int get id;
  String get title;
  String get image;
  String get link;
  String get type;
}

class SearchRecipeItem extends SearchRecipe implements SearchItem {
  SearchRecipeItem({
    required int id,
    required String title,
    required String excerpt,
    required String link,
    required String image,
  }) : super(
    id: id,
    title: title,
    excerpt: excerpt,
    link: link,
    image: image,
  );

  @override
  String get type => 'recipe';

  factory SearchRecipeItem.fromSearchRecipe(SearchRecipe recipe) {
    return SearchRecipeItem(
      id: recipe.id,
      title: recipe.title,
      excerpt: recipe.excerpt,
      link: recipe.link,
      image: recipe.image,
    );
  }
}

class SearchProductItem extends SearchProduct implements SearchItem {
  SearchProductItem({
    required int id,
    required String title,
    required String price,
    required String link,
    required String image,
  }) : super(
    id: id,
    title: title,
    price: price,
    link: link,
    image: image,
  );

  @override
  String get type => 'product';

  factory SearchProductItem.fromSearchProduct(SearchProduct product) {
    return SearchProductItem(
      id: product.id,
      title: product.title,
      price: product.price,
      link: product.link,
      image: product.image,
    );
  }
}