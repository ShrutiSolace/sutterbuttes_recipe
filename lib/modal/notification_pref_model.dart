class NotificationPrefModel {
  NotificationPrefModel({
    this.success,
    this.preferences,
  });

  NotificationPrefModel.fromJson(dynamic json) {
    success = json['success'];
    preferences = json['preferences'] != null ? Preferences.fromJson(json['preferences']) : null;
  }
  bool? success;
  Preferences? preferences;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    if (preferences != null) {
      map['preferences'] = preferences?.toJson();
    }
    return map;
  }
}

class Preferences {
  Preferences({
    this.email,
    this.push,
    this.sms,
    this.app,
  });

  Preferences.fromJson(dynamic json) {
    email = json['email'] != null ? Email.fromJson(json['email']) : null;
    push = json['push'] != null ? Push.fromJson(json['push']) : null;
    sms = json['sms'] != null ? Sms.fromJson(json['sms']) : null;
    app = json['app'] != null ? App.fromJson(json['app']) : null;
  }
  Email? email;
  Push? push;
  Sms? sms;
  App? app;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (email != null) {
      map['email'] = email?.toJson();
    }
    if (push != null) {
      map['push'] = push?.toJson();
    }
    if (sms != null) {
      map['sms'] = sms?.toJson();
    }
    if (app != null) {
      map['app'] = app?.toJson();
    }
    return map;
  }
}

class App {
  App({
    this.favoriteUpdates,
    this.recipeRecommendations,
    this.socialFeatures,
  });

  App.fromJson(dynamic json) {
    favoriteUpdates = json['favorite_updates'];
    recipeRecommendations = json['recipe_recommendations'];
    socialFeatures = json['social_features'];
  }
  bool? favoriteUpdates;
  bool? recipeRecommendations;
  bool? socialFeatures;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['favorite_updates'] = favoriteUpdates;
    map['recipe_recommendations'] = recipeRecommendations;
    map['social_features'] = socialFeatures;
    return map;
  }
}

class Sms {
  Sms({
    this.orderUpdates,
    this.promotions,
  });

  Sms.fromJson(dynamic json) {
    orderUpdates = json['order_updates'];
    promotions = json['promotions'];
  }
  bool? orderUpdates;
  bool? promotions;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['order_updates'] = orderUpdates;
    map['promotions'] = promotions;
    return map;
  }
}

class Push {
  Push({
    this.newRecipes,
    this.orderUpdates,
    this.promotions,
    this.cookingReminders,
  });

  Push.fromJson(dynamic json) {
    newRecipes = json['new_recipes'];
    orderUpdates = json['order_updates'];
    promotions = json['promotions'];
    cookingReminders = json['cooking_reminders'];
  }
  bool? newRecipes;
  bool? orderUpdates;
  bool? promotions;
  bool? cookingReminders;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['new_recipes'] = newRecipes;
    map['order_updates'] = orderUpdates;
    map['promotions'] = promotions;
    map['cooking_reminders'] = cookingReminders;
    return map;
  }
}

class Email {
  Email({
    this.newRecipes,
    this.orderUpdates,
    this.promotions,
    this.newsletter,
  });

  Email.fromJson(dynamic json) {
    newRecipes = json['new_recipes'];
    orderUpdates = json['order_updates'];
    promotions = json['promotions'];
    newsletter = json['newsletter'];
  }
  bool? newRecipes;
  bool? orderUpdates;
  bool? promotions;
  bool? newsletter;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['new_recipes'] = newRecipes;
    map['order_updates'] = orderUpdates;
    map['promotions'] = promotions;
    map['newsletter'] = newsletter;
    return map;
  }
}
