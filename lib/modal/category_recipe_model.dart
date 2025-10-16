class CategoryRecipeItem {
  final int id;
  final String title;
  final String link;
  final String excerpt;
  final String image;

  CategoryRecipeItem({
    required this.id,
    required this.title,
    required this.link,
    required this.excerpt,
    required this.image,
  });

  factory CategoryRecipeItem.fromJson(Map<String, dynamic> json) {
    return CategoryRecipeItem(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? '',
      link: json['link']?.toString() ?? '',
      excerpt: json['excerpt']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'link': link,
      'excerpt': excerpt,
      'image': image,
    };
  }
}