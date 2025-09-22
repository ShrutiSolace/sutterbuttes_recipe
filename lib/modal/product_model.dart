class Product {
  final int id;
  final String name;
  final String slug;
  final String permalink;
  final String type;
  final String status;
  final bool featured;
  final String description;
  final String shortDescription;
  final String sku;
  final String price;
  final String regularPrice;
  final String salePrice;
  final bool onSale;
  final bool purchasable;
  final int totalSales;
  final bool virtual;
  final bool downloadable;
  final String taxStatus;
  final bool manageStock;
  final int? stockQuantity;
  final String stockStatus;
  final bool soldIndividually;
  final String weight;
  final Dimensions dimensions;
  final bool shippingRequired;
  final bool shippingTaxable;
  final bool reviewsAllowed;
  final String averageRating;
  final int ratingCount;
  final List<Category> categories;
  final List<ProductImage> images;
  final List<dynamic> tags;
  final String priceHtml;

  Product({
    required this.id,
    required this.name,
    required this.slug,
    required this.permalink,
    required this.type,
    required this.status,
    required this.featured,
    required this.description,
    required this.shortDescription,
    required this.sku,
    required this.price,
    required this.regularPrice,
    required this.salePrice,
    required this.onSale,
    required this.purchasable,
    required this.totalSales,
    required this.virtual,
    required this.downloadable,
    required this.taxStatus,
    required this.manageStock,
    this.stockQuantity,
    required this.stockStatus,
    required this.soldIndividually,
    required this.weight,
    required this.dimensions,
    required this.shippingRequired,
    required this.shippingTaxable,
    required this.reviewsAllowed,
    required this.averageRating,
    required this.ratingCount,
    required this.categories,
    required this.images,
    required this.tags,
    required this.priceHtml,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      permalink: json['permalink'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      featured: json['featured'] ?? false,
      description: json['description'] ?? '',
      shortDescription: json['short_description'] ?? '',
      sku: json['sku'] ?? '',
      price: json['price'] ?? '',
      regularPrice: json['regular_price'] ?? '',
      salePrice: json['sale_price'] ?? '',
      onSale: json['on_sale'] ?? false,
      purchasable: json['purchasable'] ?? false,
      totalSales: json['total_sales'] ?? 0,
      virtual: json['virtual'] ?? false,
      downloadable: json['downloadable'] ?? false,
      taxStatus: json['tax_status'] ?? '',
      manageStock: json['manage_stock'] ?? false,
      stockQuantity: json['stock_quantity'],
      stockStatus: json['stock_status'] ?? '',
      soldIndividually: json['sold_individually'] ?? false,
      weight: json['weight'] ?? '',
      dimensions: Dimensions.fromJson(json['dimensions'] ?? {}),
      shippingRequired: json['shipping_required'] ?? false,
      shippingTaxable: json['shipping_taxable'] ?? false,
      reviewsAllowed: json['reviews_allowed'] ?? false,
      averageRating: json['average_rating'] ?? '0.00',
      ratingCount: json['rating_count'] ?? 0,
      categories: (json['categories'] as List?)
          ?.map((category) => Category.fromJson(category))
          .toList() ?? [],
      images: (json['images'] as List?)
          ?.map((image) => ProductImage.fromJson(image))
          .toList() ?? [],
      tags: json['tags'] ?? [],
      priceHtml: json['price_html'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'permalink': permalink,
      'type': type,
      'status': status,
      'featured': featured,
      'description': description,
      'short_description': shortDescription,
      'sku': sku,
      'price': price,
      'regular_price': regularPrice,
      'sale_price': salePrice,
      'on_sale': onSale,
      'purchasable': purchasable,
      'total_sales': totalSales,
      'virtual': virtual,
      'downloadable': downloadable,
      'tax_status': taxStatus,
      'manage_stock': manageStock,
      'stock_quantity': stockQuantity,
      'stock_status': stockStatus,
      'sold_individually': soldIndividually,
      'weight': weight,
      'dimensions': dimensions.toJson(),
      'shipping_required': shippingRequired,
      'shipping_taxable': shippingTaxable,
      'reviews_allowed': reviewsAllowed,
      'average_rating': averageRating,
      'rating_count': ratingCount,
      'categories': categories.map((category) => category.toJson()).toList(),
      'images': images.map((image) => image.toJson()).toList(),
      'tags': tags,
      'price_html': priceHtml,
    };
  }
}

class Dimensions {
  final String length;
  final String width;
  final String height;

  Dimensions({
    required this.length,
    required this.width,
    required this.height,
  });

  factory Dimensions.fromJson(Map<String, dynamic> json) {
    return Dimensions(
      length: json['length'] ?? '',
      width: json['width'] ?? '',
      height: json['height'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'length': length,
      'width': width,
      'height': height,
    };
  }
}

class Category {
  final int id;
  final String name;
  final String slug;

  Category({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
    };
  }
}

class ProductImage {
  final int id;
  final String dateCreated;
  final String dateCreatedGmt;
  final String dateModified;
  final String dateModifiedGmt;
  final String src;
  final String name;
  final String alt;

  ProductImage({
    required this.id,
    required this.dateCreated,
    required this.dateCreatedGmt,
    required this.dateModified,
    required this.dateModifiedGmt,
    required this.src,
    required this.name,
    required this.alt,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'] ?? 0,
      dateCreated: json['date_created'] ?? '',
      dateCreatedGmt: json['date_created_gmt'] ?? '',
      dateModified: json['date_modified'] ?? '',
      dateModifiedGmt: json['date_modified_gmt'] ?? '',
      src: json['src'] ?? '',
      name: json['name'] ?? '',
      alt: json['alt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date_created': dateCreated,
      'date_created_gmt': dateCreatedGmt,
      'date_modified': dateModified,
      'date_modified_gmt': dateModifiedGmt,
      'src': src,
      'name': name,
      'alt': alt,
    };
  }
}