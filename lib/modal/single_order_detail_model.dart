class OrderDetailResponse {
  bool? success;
  OrderDetail? order;

  OrderDetailResponse({
    this.success,
    this.order,
  });

  OrderDetailResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    order = json['order'] != null ? OrderDetail.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    if (order != null) {
      map['order'] = order?.toJson();
    }
    return map;
  }
}

class OrderDetail {
  int? id;
  String? status;
  String? total;
  String? currency;
  String? date;
  List<OrderItem>? items;

  OrderDetail({
    this.id,
    this.status,
    this.total,
    this.currency,
    this.date,
    this.items,
  });

  OrderDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    total = json['total'];
    currency = json['currency'];
    date = json['date'];
    if (json['items'] != null) {
      items = <OrderItem>[];
      json['items'].forEach((v) {
        items?.add(OrderItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['status'] = status;
    map['total'] = total;
    map['currency'] = currency;
    map['date'] = date;
    if (items != null) {
      map['items'] = items?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class OrderItem {
  int? id;
  String? name;
  int? quantity;
  String? subtotal;
  String? unit_price;
  String? total;
  String? image;

  OrderItem({
    this.id,
    this.name,
    this.quantity,
    this.subtotal,
    this.unit_price,
    this.total,
    this.image,
  });

  OrderItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    quantity = json['quantity'];
    subtotal = json['subtotal'];
    unit_price = json['unit_price'];
    total = json['total'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['quantity'] = quantity;
    map['subtotal'] = subtotal;
    map['unit_price'] = unit_price;
    map['total'] = total;
    map['image'] = image;
    return map;
  }
}