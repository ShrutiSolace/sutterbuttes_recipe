class CheckOutModel {
  CheckOutModel({
      this.success, 
      this.orderId, 
      this.orderKey, 
      this.status, 
      this.total,
      this.shippingTotal,
      this.currency, 
      this.payment, 
      this.viewOrder,});

  CheckOutModel.fromJson(dynamic json) {
    success = json['success'];
    orderId = json['order_id'];
    orderKey = json['order_key'];
    status = json['status'];
    total = json['total'];
    shippingTotal = json['shipping_total'];
    currency = json['currency'];
    payment = json['payment'];
    viewOrder = json['view_order'];
  }
  bool? success;
  int? orderId;
  String? orderKey;
  String? status;
  String? total;
  String? shippingTotal;
  String? currency;
  String? payment;
  String? viewOrder;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['order_id'] = orderId;
    map['order_key'] = orderKey;
    map['status'] = status;
    map['total'] = total;
    map['shipping_total'] = shippingTotal;
    map['currency'] = currency;
    map['payment'] = payment;
    map['view_order'] = viewOrder;
    return map;
  }

}