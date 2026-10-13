import '../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  final double? originalPrice;
  final double rating;
  final int reviewCount;
  final bool isFeatured;
  final bool isNew;

  const ProductModel({
    required super.id,
    required super.name,
    required super.category,
    required super.price,
    required super.imageUrl,
    required super.sizes,
    required super.description,
    this.originalPrice,
    this.rating = 4.8,
    this.reviewCount = 128,
    this.isFeatured = true,
    this.isNew = false,
  });

  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  int get discountPercent {
    if (!hasDiscount || originalPrice == null || originalPrice == 0) return 0;
    return (((originalPrice! - price) / originalPrice!) * 100).round();
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      sizes: (json['sizes'] as List<dynamic>).map((e) => e.toString()).toList(),
      description: json['description'] as String? ?? '',
      originalPrice: json['originalPrice'] != null
          ? (json['originalPrice'] as num).toDouble()
          : null,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      reviewCount: json['reviewCount'] as int? ?? 128,
      isFeatured: json['isFeatured'] as bool? ?? false,
      isNew: json['isNew'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'imageUrl': imageUrl,
      'sizes': sizes,
      'description': description,
      'originalPrice': originalPrice,
      'rating': rating,
      'reviewCount': reviewCount,
      'isFeatured': isFeatured,
      'isNew': isNew,
    };
  }
}
