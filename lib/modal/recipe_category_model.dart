class RecipeCategory {
  final int id;
  final String name;
  final String slug;
  final int count;
  final String link;
  final String image; // NEW

  RecipeCategory({
    required this.id,
    required this.name,
    required this.slug,
    required this.count,
    required this.link,
    required this.image,
  });

  factory RecipeCategory.fromJson(Map<String, dynamic> json) {
    return RecipeCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      count: json['count'] ?? 0,
      link: json['link'] ?? '',
      image: json['image'] ?? '', // NEW
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'count': count,
      'link': link,
      'image': image, // NEW
    };
  }
}

class RecipeCategoriesResponse {
  final bool success;
  final List<RecipeCategory> categories;

  RecipeCategoriesResponse({
    required this.success,
    required this.categories,
  });

  factory RecipeCategoriesResponse.fromJson(Map<String, dynamic> json) {
    print("======Parsing RecipeCategoriesResponse from JSON: $json");
    return RecipeCategoriesResponse(
      success: json['success'] ?? false,
      categories: (json['categories'] as List<dynamic>?)
          ?.map((category) => RecipeCategory.fromJson(category))
          .toList() ?? [],
    );
  }
}