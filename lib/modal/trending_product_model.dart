





class TrendingProductModel {
  TrendingProductModel({
    this.success,
    this.count,
    this.products,
  });

  TrendingProductModel.fromJson(dynamic json) {
    success = json['success'];
    count = json['count'];
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products?.add(TrendingProduct.fromJson(v));
      });
    }
  }

  bool? success;
  int? count;
  List<TrendingProduct>? products;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['count'] = count;
    if (products != null) {
      map['products'] = products?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class TrendingProduct {
  TrendingProduct({
    this.id,
    this.name,
    this.price,
    this.regularPrice,
    this.salePrice,
    this.description,
    this.image,
    this.permalink,
  });

  TrendingProduct.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    description = json['description'];
    image = json['image'];
    permalink = json['permalink'];
  }

  int? id;
  String? name;
  String? price;
  String? regularPrice;
  String? salePrice;
  String? image;
  String? description;
  String? permalink;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['price'] = price;
    map['regular_price'] = regularPrice;
    map['sale_price'] = salePrice;
    map['image'] = image;
    map['description'] = description;
    map['permalink'] = permalink;
    return map;
  }
}







