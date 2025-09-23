/// Banner Model
class BannerModel {
  final int? id;
  final String? position;
  final String? title;
  final String? description;
  final List<String>? bannerImg;
  final int? categoryId;

  BannerModel({
    this.id,
    this.position,
    this.title,
    this.description,
    this.bannerImg,
    this.categoryId,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] as int?,
      position: json['position'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      bannerImg: (json['banner_img'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      categoryId: json['category_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "position": position,
      "title": title,
      "description": description,
      "banner_img": bannerImg,
      "category_id": categoryId,
    };
  }
}

/// Product Model
class ProductModel {
  final int? id;
  final String? name;
  final String? description;
  final String? price;
  final String? sku;
  final int? categoryId;
  final String? size;
  final String? colors;
  final int? stock;
  final String? rating;
  final bool? isFeatured;
  final bool? isRecommended;
  final String? createdAt;
  final String? updatedAt;
  final String? productImg;
  final bool? topCollection;

  ProductModel({
    this.id,
    this.name,
    this.description,
    this.price,
    this.sku,
    this.categoryId,
    this.size,
    this.colors,
    this.stock,
    this.rating,
    this.isFeatured,
    this.isRecommended,
    this.createdAt,
    this.updatedAt,
    this.productImg,
    this.topCollection,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      price: json['price'] as String?,
      sku: json['sku'] as String?,
      categoryId: json['category_id'] as int?,
      size: json['size'] as String?,
      colors: json['colors'] as String?,
      stock: json['stock'] as int?,
      rating: json['rating'] as String?,
      isFeatured: json['is_featured'] as bool?,
      isRecommended: json['is_recommended'] as bool?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      productImg: json['product_img'] as String?,
      topCollection: json['top_collection'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "price": price,
      "sku": sku,
      "category_id": categoryId,
      "size": size,
      "colors": colors,
      "stock": stock,
      "rating": rating,
      "is_featured": isFeatured,
      "is_recommended": isRecommended,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "product_img": productImg,
      "top_collection": topCollection,
    };
  }
}

/// Main API Response Model
class ProductBannerResponse {
  final String? message;
  final List<BannerModel>? banners;
  final List<ProductModel>? products;

  ProductBannerResponse({
    this.message,
    this.banners,
    this.products,
  });

  factory ProductBannerResponse.fromJson(Map<String, dynamic> json) {
    return ProductBannerResponse(
      message: json['message'] as String?,
      banners: (json['banners'] as List<dynamic>?)
          ?.map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "banners": banners?.map((e) => e.toJson()).toList(),
      "products": products?.map((e) => e.toJson()).toList(),
    };
  }
}