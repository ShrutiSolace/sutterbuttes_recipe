class ShippingCostModel {
  ShippingCostModel({
    this.success,
    this.matchedZone,
    this.matchedState,
    this.shippingMethods,
    this.selectedMethod,
    this.cartSubtotal,
    this.estimatedTotal,
    this.currency,
  });

  ShippingCostModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    matchedZone = json['matched_zone'];
    matchedState = json['matched_state'];
    if (json['shipping_methods'] != null) {
      shippingMethods = [];
      json['shipping_methods'].forEach((v) {
        shippingMethods?.add(ShippingMethod.fromJson(v));
      });
    }
    selectedMethod = json['selected_method'] != null
        ? ShippingMethod.fromJson(json['selected_method'])
        : null;
    cartSubtotal = json['cart_subtotal'];
    estimatedTotal = json['estimated_total'];
    currency = json['currency'];
  }

  bool? success;
  String? matchedZone;
  String? matchedState;
  List<ShippingMethod>? shippingMethods;
  ShippingMethod? selectedMethod;
  String? cartSubtotal;
  String? estimatedTotal;
  String? currency;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['matched_zone'] = matchedZone;
    map['matched_state'] = matchedState;
    if (shippingMethods != null) {
      map['shipping_methods'] = shippingMethods?.map((v) => v.toJson()).toList();
    }
    if (selectedMethod != null) {
      map['selected_method'] = selectedMethod?.toJson();
    }
    map['cart_subtotal'] = cartSubtotal;
    map['estimated_total'] = estimatedTotal;
    map['currency'] = currency;
    return map;
  }
}

class ShippingMethod {
  ShippingMethod({
    this.id,
    this.methodId,
    this.label,
    this.costRaw,
    this.cost,
  });

  ShippingMethod.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    methodId = json['method_id'];
    label = json['label'];
    costRaw = json['cost_raw']?.toDouble() ?? 0.0;
    cost = json['cost'];
  }

  String? id;
  String? methodId;
  String? label;
  double? costRaw;
  String? cost;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['method_id'] = methodId;
    map['label'] = label;
    map['cost_raw'] = costRaw;
    map['cost'] = cost;
    return map;
  }
}