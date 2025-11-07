class RatingsModel {
  final int count;
  final double average;
  final List<ReviewModel> reviews;

  RatingsModel({
    required this.count,
    required this.average,
    required this.reviews,
  });

  factory RatingsModel.fromJson(Map<String, dynamic> json) {
    return RatingsModel(
      count: json['count'] ?? 0,
      average: (json['average'] ?? 0.0).toDouble(),
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((review) => ReviewModel.fromJson(review))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'average': average,
      'reviews': reviews.map((review) => review.toJson()).toList(),
    };
  }
}

class ReviewModel {
  final String id;
  final String user;
  final int rating;
  final String review;
  final String date;

  ReviewModel({
    required this.id,
    required this.user,
    required this.rating,
    required this.review,
    required this.date,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id']?.toString() ?? '',
      user: json['user']?.toString() ?? '',
      rating: json['rating'] ?? 0,
      review: json['review']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user,
      'rating': rating,
      'review': review,
      'date': date,
    };
  }
}