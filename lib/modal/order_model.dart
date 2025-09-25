class OrderModel {
  OrderModel({
      this.id, 
      this.parentId, 
      this.status, 
      this.currency, 
      this.version, 
      this.pricesIncludeTax, 
      this.dateCreated, 
      this.dateModified, 
      this.discountTotal, 
      this.discountTax, 
      this.shippingTotal, 
      this.shippingTax, 
      this.cartTax, 
      this.total, 
      this.totalTax, 
      this.customerId, 
      this.orderKey, 
      this.billing, 
      this.shipping, 
      this.paymentMethod, 
      this.paymentMethodTitle, 
      this.transactionId, 
      this.customerIpAddress, 
      this.customerUserAgent, 
      this.createdVia, 
      this.customerNote, 
      this.dateCompleted, 
      this.datePaid, 
      this.cartHash, 
      this.number, 
      this.metaData, 
      this.lineItems, 
      this.taxLines, 
      this.shippingLines, 
      this.feeLines, 
      this.couponLines, 
      this.refunds, 
      this.paymentUrl, 
      this.isEditable, 
      this.needsPayment, 
      this.needsProcessing, 
      this.dateCreatedGmt, 
      this.dateModifiedGmt, 
      this.dateCompletedGmt, 
      this.datePaidGmt, 
      this.currencySymbol, 
      this.links,});

  OrderModel.fromJson(dynamic json) {
    id = json['id'];
    parentId = json['parent_id'];
    status = json['status'];
    currency = json['currency'];
    version = json['version'];
    pricesIncludeTax = json['prices_include_tax'];
    dateCreated = json['date_created'];
    dateModified = json['date_modified'];
    discountTotal = json['discount_total'];
    discountTax = json['discount_tax'];
    shippingTotal = json['shipping_total'];
    shippingTax = json['shipping_tax'];
    cartTax = json['cart_tax'];
    total = json['total'];
    totalTax = json['total_tax'];
    customerId = json['customer_id'];
    orderKey = json['order_key'];
    billing = json['billing'] != null ? Billing.fromJson(json['billing']) : null;
    shipping = json['shipping'] != null ? Shipping.fromJson(json['shipping']) : null;
    paymentMethod = json['payment_method'];
    paymentMethodTitle = json['payment_method_title'];
    transactionId = json['transaction_id'];
    customerIpAddress = json['customer_ip_address'];
    customerUserAgent = json['customer_user_agent'];
    createdVia = json['created_via'];
    customerNote = json['customer_note'];
    dateCompleted = json['date_completed'];
    datePaid = json['date_paid'];
    cartHash = json['cart_hash'];
    number = json['number'];
    /*if (json['meta_data'] != null) {
      metaData = [];
      json['meta_data'].forEach((v) {
        metaData?.add(MetaData.fromJson(v));
      });
    }*/
    if (json['line_items'] != null) {
      lineItems = [];
      json['line_items'].forEach((v) {
        lineItems?.add(LineItems.fromJson(v));
      });
    }
    if (json['tax_lines'] != null) {
      taxLines = [];
      json['tax_lines'].forEach((v) {
        taxLines?.add(v);
      });
    }
    if (json['shipping_lines'] != null) {
      shippingLines = [];
      json['shipping_lines'].forEach((v) {
        shippingLines?.add(v);
      });
    }
    if (json['fee_lines'] != null) {
      feeLines = [];
      json['fee_lines'].forEach((v) {
        feeLines?.add(v);
      });
    }
    if (json['coupon_lines'] != null) {
      couponLines = [];
      json['coupon_lines'].forEach((v) {
        couponLines?.add(v);
      });
    }
    if (json['refunds'] != null) {
      refunds = [];
      json['refunds'].forEach((v) {
        refunds?.add(v);
      });
    }
    paymentUrl = json['payment_url'];
    isEditable = json['is_editable'];
    needsPayment = json['needs_payment'];
    needsProcessing = json['needs_processing'];
    dateCreatedGmt = json['date_created_gmt'];
    dateModifiedGmt = json['date_modified_gmt'];
    dateCompletedGmt = json['date_completed_gmt'];
    datePaidGmt = json['date_paid_gmt'];
    currencySymbol = json['currency_symbol'];
    links = json['_links'] != null ? Links.fromJson(json['_links']) : null;
  }
  int? id;
  int? parentId;
  String? status;
  String? currency;
  String? version;
  bool? pricesIncludeTax;
  String? dateCreated;
  String? dateModified;
  String? discountTotal;
  String? discountTax;
  String? shippingTotal;
  String? shippingTax;
  String? cartTax;
  String? total;
  String? totalTax;
  int? customerId;
  String? orderKey;
  Billing? billing;
  Shipping? shipping;
  String? paymentMethod;
  String? paymentMethodTitle;
  String? transactionId;
  String? customerIpAddress;
  String? customerUserAgent;
  String? createdVia;
  String? customerNote;
  dynamic dateCompleted;
  dynamic datePaid;
  String? cartHash;
  String? number;
  List<MetaData>? metaData;
  List<LineItems>? lineItems;
  List<dynamic>? taxLines;
  List<dynamic>? shippingLines;
  List<dynamic>? feeLines;
  List<dynamic>? couponLines;
  List<dynamic>? refunds;
  String? paymentUrl;
  bool? isEditable;
  bool? needsPayment;
  bool? needsProcessing;
  String? dateCreatedGmt;
  String? dateModifiedGmt;
  dynamic dateCompletedGmt;
  dynamic datePaidGmt;
  String? currencySymbol;
  Links? links;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['parent_id'] = parentId;
    map['status'] = status;
    map['currency'] = currency;
    map['version'] = version;
    map['prices_include_tax'] = pricesIncludeTax;
    map['date_created'] = dateCreated;
    map['date_modified'] = dateModified;
    map['discount_total'] = discountTotal;
    map['discount_tax'] = discountTax;
    map['shipping_total'] = shippingTotal;
    map['shipping_tax'] = shippingTax;
    map['cart_tax'] = cartTax;
    map['total'] = total;
    map['total_tax'] = totalTax;
    map['customer_id'] = customerId;
    map['order_key'] = orderKey;
    if (billing != null) {
      map['billing'] = billing?.toJson();
    }
    if (shipping != null) {
      map['shipping'] = shipping?.toJson();
    }
    map['payment_method'] = paymentMethod;
    map['payment_method_title'] = paymentMethodTitle;
    map['transaction_id'] = transactionId;
    map['customer_ip_address'] = customerIpAddress;
    map['customer_user_agent'] = customerUserAgent;
    map['created_via'] = createdVia;
    map['customer_note'] = customerNote;
    map['date_completed'] = dateCompleted;
    map['date_paid'] = datePaid;
    map['cart_hash'] = cartHash;
    map['number'] = number;
    if (metaData != null) {
      map['meta_data'] = metaData?.map((v) => v.toJson()).toList();
    }
    if (lineItems != null) {
      map['line_items'] = lineItems?.map((v) => v.toJson()).toList();
    }
    if (taxLines != null) {
      map['tax_lines'] = taxLines?.map((v) => v.toJson()).toList();
    }
    if (shippingLines != null) {
      map['shipping_lines'] = shippingLines?.map((v) => v.toJson()).toList();
    }
    if (feeLines != null) {
      map['fee_lines'] = feeLines?.map((v) => v.toJson()).toList();
    }
    if (couponLines != null) {
      map['coupon_lines'] = couponLines?.map((v) => v.toJson()).toList();
    }
    if (refunds != null) {
      map['refunds'] = refunds?.map((v) => v.toJson()).toList();
    }
    map['payment_url'] = paymentUrl;
    map['is_editable'] = isEditable;
    map['needs_payment'] = needsPayment;
    map['needs_processing'] = needsProcessing;
    map['date_created_gmt'] = dateCreatedGmt;
    map['date_modified_gmt'] = dateModifiedGmt;
    map['date_completed_gmt'] = dateCompletedGmt;
    map['date_paid_gmt'] = datePaidGmt;
    map['currency_symbol'] = currencySymbol;
    if (links != null) {
      map['_links'] = links?.toJson();
    }
    return map;
  }

}

class Links {
  Links({
      this.self, 
      this.collection, 
      this.emailTemplates, 
      this.customer,});

  Links.fromJson(dynamic json) {
    if (json['self'] != null) {
      self = [];
      json['self'].forEach((v) {
        self?.add(Self.fromJson(v));
      });
    }
    if (json['collection'] != null) {
      collection = [];
      json['collection'].forEach((v) {
        collection?.add(Collection.fromJson(v));
      });
    }
    if (json['email_templates'] != null) {
      emailTemplates = [];
      json['email_templates'].forEach((v) {
        emailTemplates?.add(EmailTemplates.fromJson(v));
      });
    }
    if (json['customer'] != null) {
      customer = [];
      json['customer'].forEach((v) {
        customer?.add(Customer.fromJson(v));
      });
    }
  }
  List<Self>? self;
  List<Collection>? collection;
  List<EmailTemplates>? emailTemplates;
  List<Customer>? customer;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (self != null) {
      map['self'] = self?.map((v) => v.toJson()).toList();
    }
    if (collection != null) {
      map['collection'] = collection?.map((v) => v.toJson()).toList();
    }
    if (emailTemplates != null) {
      map['email_templates'] = emailTemplates?.map((v) => v.toJson()).toList();
    }
    if (customer != null) {
      map['customer'] = customer?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Customer {
  Customer({
      this.href,});

  Customer.fromJson(dynamic json) {
    href = json['href'];
  }
  String? href;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['href'] = href;
    return map;
  }

}

class EmailTemplates {
  EmailTemplates({
      this.embeddable, 
      this.href,});

  EmailTemplates.fromJson(dynamic json) {
    embeddable = json['embeddable'];
    href = json['href'];
  }
  bool? embeddable;
  String? href;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['embeddable'] = embeddable;
    map['href'] = href;
    return map;
  }

}

class Collection {
  Collection({
      this.href,});

  Collection.fromJson(dynamic json) {
    href = json['href'];
  }
  String? href;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['href'] = href;
    return map;
  }

}

class Self {
  Self({
      this.href, 
      this.targetHints,});

  Self.fromJson(dynamic json) {
    href = json['href'];
    targetHints = json['targetHints'] != null ? TargetHints.fromJson(json['targetHints']) : null;
  }
  String? href;
  TargetHints? targetHints;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['href'] = href;
    if (targetHints != null) {
      map['targetHints'] = targetHints?.toJson();
    }
    return map;
  }

}

class TargetHints {
  TargetHints({
      this.allow,});

  TargetHints.fromJson(dynamic json) {
    allow = json['allow'] != null ? json['allow'].cast<String>() : [];
  }
  List<String>? allow;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['allow'] = allow;
    return map;
  }

}

class LineItems {
  LineItems({
      this.id, 
      this.name, 
      this.productId, 
      this.variationId, 
      this.quantity, 
      this.taxClass, 
      this.subtotal, 
      this.subtotalTax, 
      this.total, 
      this.totalTax, 
      this.taxes, 
      this.metaData, 
      this.sku, 
      this.price, 
      this.image, 
      this.parentName,});

  LineItems.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    productId = json['product_id'];
    variationId = json['variation_id'];
    quantity = json['quantity'];
    taxClass = json['tax_class'];
    subtotal = json['subtotal'];
    subtotalTax = json['subtotal_tax'];
    total = json['total'];
    totalTax = json['total_tax'];
    /*if (json['taxes'] != null) {
      taxes = [];
      json['taxes'].forEach((v) {
        taxes?.add(v);
      });
    }*/
    /*if (json['meta_data'] != null) {
      metaData = [];
      json['meta_data'].forEach((v) {
        metaData?.add(v);
      });
    }*/
    sku = json['sku'];
    //price = json['price'];
    image = json['image'] != null ? Images.fromJson(json['image']) : null;
    parentName = json['parent_name'];
  }
  int? id;
  String? name;
  int? productId;
  int? variationId;
  int? quantity;
  String? taxClass;
  String? subtotal;
  String? subtotalTax;
  String? total;
  String? totalTax;
  List<dynamic>? taxes;
  List<dynamic>? metaData;
  String? sku;
  int? price;
  Images? image;
  dynamic parentName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['product_id'] = productId;
    map['variation_id'] = variationId;
    map['quantity'] = quantity;
    map['tax_class'] = taxClass;
    map['subtotal'] = subtotal;
    map['subtotal_tax'] = subtotalTax;
    map['total'] = total;
    map['total_tax'] = totalTax;
    if (taxes != null) {
      map['taxes'] = taxes?.map((v) => v.toJson()).toList();
    }
    if (metaData != null) {
      map['meta_data'] = metaData?.map((v) => v.toJson()).toList();
    }
    map['sku'] = sku;
    map['price'] = price;
    if (image != null) {
      map['image'] = image?.toJson();
    }
    map['parent_name'] = parentName;
    return map;
  }

}

class Images {
  Images({
      this.id, 
      this.src,});

  Images.fromJson(dynamic json) {
    id = json['id'].toString();
    src = json['src'].toString();
  }
  String? id;
  String? src;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['src'] = src;
    return map;
  }

}

class MetaData {
  MetaData({
      this.id, 
      this.key, 
      this.value,});

  MetaData.fromJson(dynamic json) {
    id = json['id'];
    key = json['key'];
    value = json['value'];
  }
  int? id;
  String? key;
  String? value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['key'] = key;
    map['value'] = value;
    return map;
  }

}

class Shipping {
  Shipping({
      this.firstName, 
      this.lastName, 
      this.company, 
      this.address1, 
      this.address2, 
      this.city, 
      this.state, 
      this.postcode, 
      this.country, 
      this.phone,});

  Shipping.fromJson(dynamic json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    company = json['company'];
    address1 = json['address_1'];
    address2 = json['address_2'];
    city = json['city'];
    state = json['state'];
    postcode = json['postcode'];
    country = json['country'];
    phone = json['phone'];
  }
  String? firstName;
  String? lastName;
  String? company;
  String? address1;
  String? address2;
  String? city;
  String? state;
  String? postcode;
  String? country;
  String? phone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['company'] = company;
    map['address_1'] = address1;
    map['address_2'] = address2;
    map['city'] = city;
    map['state'] = state;
    map['postcode'] = postcode;
    map['country'] = country;
    map['phone'] = phone;
    return map;
  }

}

class Billing {
  Billing({
      this.firstName, 
      this.lastName, 
      this.company, 
      this.address1, 
      this.address2, 
      this.city, 
      this.state, 
      this.postcode, 
      this.country, 
      this.email, 
      this.phone,});

  Billing.fromJson(dynamic json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    company = json['company'];
    address1 = json['address_1'];
    address2 = json['address_2'];
    city = json['city'];
    state = json['state'];
    postcode = json['postcode'];
    country = json['country'];
    email = json['email'];
    phone = json['phone'];
  }
  String? firstName;
  String? lastName;
  String? company;
  String? address1;
  String? address2;
  String? city;
  String? state;
  String? postcode;
  String? country;
  String? email;
  String? phone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['company'] = company;
    map['address_1'] = address1;
    map['address_2'] = address2;
    map['city'] = city;
    map['state'] = state;
    map['postcode'] = postcode;
    map['country'] = country;
    map['email'] = email;
    map['phone'] = phone;
    return map;
  }

}