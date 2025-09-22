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
    };
  }
}