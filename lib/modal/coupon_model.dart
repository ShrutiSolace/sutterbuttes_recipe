class CouponResponse {
  bool? success;
  String? message;
  CartTotals? cartTotals;

  CouponResponse({
    this.success,
    this.message,
    this.cartTotals,
  });

  CouponResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    cartTotals = json['cart_totals'] != null
        ? CartTotals.fromJson(json['cart_totals'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (cartTotals != null) {
      map['cart_totals'] = cartTotals?.toJson();
    }
    return map;
  }
}

class CartTotals {
  String? subtotal;
  double? discountTotal;
  String? total;
  List<String>? appliedCoupons;

  CartTotals({
    this.subtotal,
    this.discountTotal,
    this.total,
    this.appliedCoupons,
  });

  CartTotals.fromJson(Map<String, dynamic> json) {
    subtotal = json['subtotal']?.toString();
    discountTotal = (json['discount_total'] as num?)?.toDouble();
    total = json['total']?.toString();


    if (json['applied_coupons'] != null) {
      appliedCoupons = [];


      if (json['applied_coupons'] is Map) {
        final map = json['applied_coupons'] as Map;

        map.forEach((key, value) {
          appliedCoupons?.add(value.toString());
        });
        print("Parsed appliedCoupons from Map: $appliedCoupons");
      } else if (json['applied_coupons'] is List) {

        json['applied_coupons'].forEach((v) {
          appliedCoupons?.add(v.toString());
        });
        print("Parsed appliedCoupons from List: $appliedCoupons");
      }
    } else {
      print("applied_coupons is null in JSON");
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['subtotal'] = subtotal;
    map['discount_total'] = discountTotal;
    map['total'] = total;
    if (appliedCoupons != null) {
      map['applied_coupons'] = appliedCoupons;
    }
    return map;
  }
}