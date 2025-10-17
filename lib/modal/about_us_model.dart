class AboutContentModel {
  final int id;
  final String title;
  final String content;
  final String excerpt;
  final String slug;
  final String status;
  final String type;
  final String date;
  final String modified;
  final Author author;

  AboutContentModel({
    required this.id,
    required this.title,
    required this.content,
    required this.excerpt,
    required this.slug,
    required this.status,
    required this.type,
    required this.date,
    required this.modified,
    required this.author,
  });

  factory AboutContentModel.fromJson(Map<String, dynamic> json) {
    return AboutContentModel(
      id: json['id'],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      excerpt: json['excerpt'] ?? '',
      slug: json['slug'] ?? '',
      status: json['status'] ?? '',
      type: json['type'] ?? '',
      date: json['date'] ?? '',
      modified: json['modified'] ?? '',
      author: Author.fromJson(json['author']),
    );
  }
}

class Author {
  final String id;
  final String name;
  final String email;
  final String url;

  Author({
    required this.id,
    required this.name,
    required this.email,
    required this.url,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      url: json['url'] ?? '',
    );
  }
}
