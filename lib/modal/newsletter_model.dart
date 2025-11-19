import 'dart:convert';

// Newsletter Preferences Model
class NewsletterPreferences {
  final bool newRecipes;
  final bool cookingTips;
  final bool seasonalOffers;
  final bool productUpdates;
  final bool subscribed;

  NewsletterPreferences({
    required this.newRecipes,
    required this.cookingTips,
    required this.seasonalOffers,
    required this.productUpdates,
    required this.subscribed,
  });

  factory NewsletterPreferences.fromJson(Map<String, dynamic> json) {
    return NewsletterPreferences(
      newRecipes: json['new_recipes'] ?? false,
      cookingTips: json['cooking_tips'] ?? false,
      seasonalOffers: json['seasonal_offers'] ?? false,
      productUpdates: json['product_updates'] ?? false,
      subscribed: json['subscribed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'new_recipes': newRecipes,
      'cooking_tips': cookingTips,
      'seasonal_offers': seasonalOffers,
      'product_updates': productUpdates,
      'subscribed': subscribed,
    };
  }
}

// Newsletter Response Model
class NewsletterResponse {
  final bool success;
  final String email;
  final String name;
  final NewsletterPreferences preferences;

  NewsletterResponse({
    required this.success,
    required this.email,
    required this.name,
    required this.preferences,
  });

  factory NewsletterResponse.fromJson(Map<String, dynamic> json) {
    return NewsletterResponse(
      success: json['success'] ?? false,
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      preferences: NewsletterPreferences.fromJson(json['preferences'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'email': email,
      'name': name,
      'preferences': preferences.toJson(),
    };
  }
}



class NewsletterSubscribeRequest {
  final String email;
  final String name;
  final bool newRecipes;

  final bool seasonalOffers;
  final bool productUpdates;

  NewsletterSubscribeRequest({
    required this.email,
    required this.name,
    required this.newRecipes,

    required this.seasonalOffers,
    required this.productUpdates,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'new_recipes': newRecipes,
      'seasonal_offers': seasonalOffers,
      'product_updates': productUpdates,
    };
  }
}


class Preferences {
  final bool newRecipes;
  final bool cookingTips;
  final bool seasonalOffers;
  final bool productUpdates;
  final bool subscribed;

  Preferences({
    required this.newRecipes,
    required this.cookingTips,
    required this.seasonalOffers,
    required this.productUpdates,
    required this.subscribed,
  });

  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(
      newRecipes: json['new_recipes'] ?? false,
      cookingTips: json['cooking_tips'] ?? false,
      seasonalOffers: json['seasonal_offers'] ?? false,
      productUpdates: json['product_updates'] ?? false,
      subscribed: json['subscribed'] ?? false,
    );
  }
}


class NewsletterSubscribeResponse {
  final bool success;
  final String message;
  final Preferences preferences;

  NewsletterSubscribeResponse({
    required this.success,
    required this.message,
    required this.preferences,
  });

  factory NewsletterSubscribeResponse.fromJson(Map<String, dynamic> json) {
    return NewsletterSubscribeResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      preferences: Preferences.fromJson(json['preferences'] ?? {}),
    );
  }
}


// Unsubscribe Response Model
  class NewsletterUnsubscireResponse{
    final bool success;
    final String message;



    NewsletterUnsubscireResponse({
      required this.success,
      required this.message,
    });

    factory NewsletterUnsubscireResponse.fromJson(Map<String, dynamic> json) {
      return NewsletterUnsubscireResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
      );
    }
}