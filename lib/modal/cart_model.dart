class CartModel {
  CartModel({
    this.success,
    this.items,
    this.totals,
    this.coupons,
    this.message,
  });

  CartModel.fromJson(dynamic json) {
    success = json['success'];
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items?.add(CartItems.fromJson(v));
      });
    }
    totals = json['totals'] != null ? Totals.fromJson(json['totals']) : null;
    if (json['coupons'] != null) {
      coupons = [];
      json['coupons'].forEach((v) {
        coupons?.add(v);
      });
    }
    message = json['message'];
  }
  bool? success;
  List<CartItems>? items;
  Totals? totals;
  List<dynamic>? coupons;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    if (items != null) {
      map['items'] = items?.map((v) => v.toJson()).toList();
    }
    if (totals != null) {
      map['totals'] = totals?.toJson();
    }
    if (coupons != null) {
      map['coupons'] = coupons?.map((v) => v.toJson()).toList();
    }
    map['message'] = message;
    return map;
  }
}

class Totals {
  Totals({
    this.subtotal,

  });

  Totals.fromJson(dynamic json) {
    subtotal = (json['subtotal'] as num?)?.toDouble();

  }
  double? subtotal;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['subtotal'] = subtotal;

    return map;
  }
}

class CartItems {
  CartItems({
    this.productId,
    this.variationId,
    this.name,
    this.quantity,
    this.price,
    this.lineTotal,
    this.image,
    this.permalink,
    this.stockStatus,
  });

  CartItems.fromJson(dynamic json) {
    productId = json['product_id'];
    variationId = json['variation_id'];
    name = json['name'];
    quantity = json['quantity'];
    price = (json['price'] as num?)?.toDouble();  // ✅ FIXED
    lineTotal = (json['line_total'] as num?)?.toDouble();
    image = json['image'];
    permalink = json['permalink'];
    stockStatus = json['stock_status'];
  }
  int? productId;
  int? variationId;
  String? name;
  int? quantity;
  double? price;
  double? lineTotal;
  String? image;
  String? permalink;
  String? stockStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['product_id'] = productId;
    map['variation_id'] = variationId;
    map['name'] = name;
    map['quantity'] = quantity;
    map['price'] = price;
    map['line_total'] = lineTotal;
    map['image'] = image;
    map['permalink'] = permalink;
    map['stock_status'] = stockStatus;
    return map;
  }
}
