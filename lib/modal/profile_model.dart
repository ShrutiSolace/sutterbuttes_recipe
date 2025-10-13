/*
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
}*/
class Profile {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String profileImage;

  Profile({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.profileImage,
  });

  String get fullName => "$firstName $lastName".trim();

  factory Profile.fromJson(Map<String, dynamic> json) {
    // handle the nested 'data' field
    final data = json['data'] ?? json;
    return Profile(
      id: data['id'] ?? 0,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      firstName: data['first_name'] ?? '',
      lastName: data['last_name'] ?? '',
      profileImage: data['profile_image'] ?? '',
    );
  }
}

