class UploadProfileImageModel {
  UploadProfileImageModel({
    this.success,
    this.message,
    this.data,
  });

  UploadProfileImageModel.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? ProfileImageData.fromJson(json['data']) : null;
  }

  bool? success;
  String? message;
  ProfileImageData? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

class ProfileImageData {
  ProfileImageData({
    this.profileImage,
  });

  ProfileImageData.fromJson(dynamic json) {
    profileImage = json['profile_image'] != null
        ? ProfileImageSizes.fromJson(json['profile_image'])
        : null;
  }

  ProfileImageSizes? profileImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (profileImage != null) {
      map['profile_image'] = profileImage?.toJson();
    }
    return map;
  }
}

class ProfileImageSizes {
  ProfileImageSizes({
    this.full,
    this.medium,
    this.thumbnail,
    this.squareImage,
    this.relatedPostImage,
    this.portfolioThumb,
    this.woocommerceThumbnail,
    this.woocommerceSingle,
    this.woocommerceGalleryThumbnail,
    this.shopCatalog,
    this.shopSingle,
    this.shopThumbnail,
    this.dgwtWcasProductSuggestion,
  });

  ProfileImageSizes.fromJson(dynamic json) {
    full = json['full'];
    medium = json['medium'];
    thumbnail = json['thumbnail'];
    squareImage = json['square-image'];
    relatedPostImage = json['related-post-image'];
    portfolioThumb = json['portfolio-thumb'];
    woocommerceThumbnail = json['woocommerce_thumbnail'];
    woocommerceSingle = json['woocommerce_single'];
    woocommerceGalleryThumbnail = json['woocommerce_gallery_thumbnail'];
    shopCatalog = json['shop_catalog'];
    shopSingle = json['shop_single'];
    shopThumbnail = json['shop_thumbnail'];
    dgwtWcasProductSuggestion = json['dgwt-wcas-product-suggestion'];
  }

  String? full;
  String? medium;
  String? thumbnail;
  String? squareImage;
  String? relatedPostImage;
  String? portfolioThumb;
  String? woocommerceThumbnail;
  String? woocommerceSingle;
  String? woocommerceGalleryThumbnail;
  String? shopCatalog;
  String? shopSingle;
  String? shopThumbnail;
  String? dgwtWcasProductSuggestion;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['full'] = full;
    map['medium'] = medium;
    map['thumbnail'] = thumbnail;
    map['square-image'] = squareImage;
    map['related-post-image'] = relatedPostImage;
    map['portfolio-thumb'] = portfolioThumb;
    map['woocommerce_thumbnail'] = woocommerceThumbnail;
    map['woocommerce_single'] = woocommerceSingle;
    map['woocommerce_gallery_thumbnail'] = woocommerceGalleryThumbnail;
    map['shop_catalog'] = shopCatalog;
    map['shop_single'] = shopSingle;
    map['shop_thumbnail'] = shopThumbnail;
    map['dgwt-wcas-product-suggestion'] = dgwtWcasProductSuggestion;
    return map;
  }
}