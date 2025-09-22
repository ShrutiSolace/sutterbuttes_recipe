class Profile {
  final int id;
  final String name;
  final String slug;
  final String link;
  final Map<String, dynamic> avatarUrls;
  final Map<String, dynamic> rawJson;

  Profile({
    required this.id,
    required this.name,
    required this.slug,
    required this.link,
    required this.avatarUrls,
    required this.rawJson,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      link: json['link'] ?? '',
      avatarUrls: (json['avatar_urls'] ?? {}) as Map<String, dynamic>,
      rawJson: json,
    );
  }
}