class OrdersListResponse {
  bool? success;
  List<OrderSummary>? orders;

  OrdersListResponse({
    this.success,
    this.orders,
  });

  OrdersListResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    orders = (json['orders'] as List<dynamic>?)
        ?.map((e) => OrderSummary.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    if (orders != null) {
      map['orders'] = orders?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class OrderSummary {
  int? id;
  String? status;
  String? total;
  String? currency;
  String? date;

  OrderSummary({
    this.id,
    this.status,
    this.total,
    this.currency,
    this.date,
  });

  OrderSummary.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    total = json['total'];
    currency = json['currency'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['status'] = status;
    map['total'] = total;
    map['currency'] = currency;
    map['date'] = date;
    return map;
  }
}