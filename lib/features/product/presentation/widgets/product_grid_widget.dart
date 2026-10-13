import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';
import 'compact_product_card.dart';

class ProductGridWidget extends StatelessWidget {
  final List<ProductModel> products;
  final void Function(ProductModel product) onAddToCart;

  const ProductGridWidget({
    super.key,
    required this.products,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Màn hình rộng hiển thị 3 cột, màn hình điện thoại vừa vặn 2 cột với spacing khít đẹp
        final crossAxisCount = constraints.maxWidth > 500 ? 3 : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.62,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return CompactProductCard(
              product: product,
              onAddToCart: () => onAddToCart(product),
            );
          },
        );
      },
    );
  }
}
