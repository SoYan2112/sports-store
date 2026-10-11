import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  final List<String> sizes;
  final String description;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.sizes,
    required this.description,
  });

  @override
  List<Object?> get props => [id, name, category, price, imageUrl, sizes, description];
}
