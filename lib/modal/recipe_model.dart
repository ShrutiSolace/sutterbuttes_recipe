class RecipeItem {
  final int id;
  final String slug;
  final String title;
  final String link;
  final String date;
  final String contentHtml;
  final int featuredMediaId;
  final String imageUrl;

  RecipeItem({
    required this.id,
    required this.slug,
    required this.title,
    required this.link,
    required this.date,
    required this.contentHtml,
    required this.featuredMediaId,
    required this.imageUrl,
  });

  factory RecipeItem.fromJson(Map<String, dynamic> json) {
    final String rawTitle = (json['title']?['rendered'] ?? '').toString();
    final String image = (json['_embedded']?['wp:featuredmedia'] is List &&
        (json['_embedded']['wp:featuredmedia'] as List).isNotEmpty)
        ? ((json['_embedded']['wp:featuredmedia'][0]?['source_url'] ?? '').toString())
        : '';

    return RecipeItem(
      id: json['id'] ?? 0,
      slug: json['slug'] ?? '',
      title: _stripHtml(rawTitle),
      link: json['link'] ?? '',
      date: json['date'] ?? '',
      contentHtml: (json['content']?['rendered'] ?? '').toString(),
      featuredMediaId: json['featured_media'] ?? 0,
      imageUrl: image,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'title': title,
      'link': link,
      'date': date,
      'contentHtml': contentHtml,
      'featured_media': featuredMediaId,
      'imageUrl': imageUrl,
    };
  }

  static String _stripHtml(String input) {
    return input
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#038;', '&')
        .trim();

  }
}