class FavouritesModel {
  FavouritesModel({
      this.success, 
      this.favorites,});

  FavouritesModel.fromJson(dynamic json) {
    success = json['success'];
    favorites = json['favorites'] != null ? Favorites.fromJson(json['favorites']) : null;
  }
  bool? success;
  Favorites? favorites;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    if (favorites != null) {
      map['favorites'] = favorites?.toJson();
    }
    return map;
  }

}

class Favorites {
  Favorites({
      this.recipes, 
      this.products,});

  Favorites.fromJson(dynamic json) {
    if (json['recipes'] != null) {
      recipes = [];
      json['recipes'].forEach((v) {
        recipes?.add(Recipes.fromJson(v));
      });
    }
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products?.add(Products.fromJson(v));
      });
    }
  }
  List<Recipes>? recipes;
  List<Products>? products;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (recipes != null) {
      map['recipes'] = recipes?.map((v) => v.toJson()).toList();
    }
    if (products != null) {
      map['products'] = products?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Products {
  Products({
      this.id, 
      this.title, 
      this.price, 
      this.link, 
      this.image,});

  Products.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];
    link = json['link'];
    image = json['image'];
  }
  int? id;
  String? title;
  String? price;
  String? link;
  String? image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['price'] = price;
    map['link'] = link;
    map['image'] = image;
    return map;
  }

}

class Recipes {
  Recipes({
      this.id, 
      this.title, 
      this.link, 
      this.image,});

  Recipes.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    link = json['link'];
    image = json['image'];
  }
  int? id;
  String? title;
  String? link;
  String? image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['link'] = link;
    map['image'] = image;
    return map;
  }

}