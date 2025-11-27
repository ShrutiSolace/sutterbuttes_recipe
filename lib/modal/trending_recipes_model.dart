class TrendingRecipesModel {
  TrendingRecipesModel({
      this.success, 
      this.count, 
      this.recipes,});

  TrendingRecipesModel.fromJson(dynamic json) {
    success = json['success'];
    count = json['count'];
    if (json['recipes'] != null) {
      recipes = [];
      json['recipes'].forEach((v) {
        recipes?.add(Recipes.fromJson(v));
      });
    }
  }
  bool? success;
  int? count;
  List<Recipes>? recipes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['count'] = count;
    if (recipes != null) {
      map['recipes'] = recipes?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Recipes {
  Recipes({
      this.id, 
      this.title, 
      this.excerpt,
    this.description,
    this.image,
      this.rating, 
      this.link,});

  Recipes.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    excerpt = json['excerpt'];
    description = json['description'];
    image = json['image'];
    rating = json['rating'];
    link = json['link'];
  }
  int? id;
  String? title;
  String? excerpt;
  String? image;
  String?description;
  String? rating;
  String? link;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['excerpt'] = excerpt;
    map['image'] = image;
    map['description'] = description;
    map['rating'] = rating;
    map['link'] = link;
    return map;
  }

}