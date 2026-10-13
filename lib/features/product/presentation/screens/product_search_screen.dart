import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/datasources/mock_product_data_source.dart';
import '../../data/models/product_model.dart';
import '../widgets/home_search_bar_widget.dart';
import '../widgets/recent_searches_widget.dart';
import '../widgets/product_grid_widget.dart';
import '../../../cart/domain/entities/cart_item_entity.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';

class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({super.key});

  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ProductModel> _filteredProducts = MockProductDataSource.mockProducts;
  final List<String> _recentSearches = [
    'Ultraboost',
    'Samba OG',
    'Giày bóng đá',
    'Áo tập',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      final q = query.trim().toLowerCase();
      if (q.isEmpty) {
        _filteredProducts = MockProductDataSource.mockProducts;
      } else {
        _filteredProducts = MockProductDataSource.mockProducts.where((p) {
          final matchesName = p.name.toLowerCase().contains(q);
          final matchesCat = p.category.toLowerCase().contains(q);
          return matchesName || matchesCat;
        }).toList();
      }
    });
  }

  void _onSelectRecent(String query) {
    _searchController.text = query;
    _onSearchChanged(query);
  }

  void _onClearRecent() {
    setState(() {
      _recentSearches.clear();
    });
  }

  void _onAddToCart(ProductModel product) {
    context.read<CartBloc>().add(
      AddToCartEvent(
        CartItemEntity(
          id: '${product.id}_${product.sizes.first}',
          productId: product.id,
          name: product.name,
          price: product.price,
          imageUrl: product.imageUrl,
          size: product.sizes.first,
          quantity: 1,
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.darkSurface,
        content: Text(
          'Đã thêm ${product.name} (Size ${product.sizes.first}) vào giỏ!',
          style: const TextStyle(color: Colors.white),
        ),
        duration: const Duration(milliseconds: 900),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: Text(
          'TÌM KIẾM SẢN PHẨM',
          style: GoogleFonts.oswald(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: HomeSearchBarWidget(
              controller: _searchController,
              onChanged: _onSearchChanged,
              onClear: () {
                _searchController.clear();
                _onSearchChanged('');
              },
            ),
          ),
          const SizedBox(height: 16),

          if (_searchController.text.isEmpty && _recentSearches.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: RecentSearchesWidget(
                recentSearches: _recentSearches,
                onSelect: _onSelectRecent,
                onClearAll: _onClearRecent,
              ),
            ),

          if (_searchController.text.isEmpty && _recentSearches.isNotEmpty)
            const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _searchController.text.isEmpty ? 'GỢI Ý CHO BẠN' : 'KẾT QUẢ TÌM KIẾM',
                  style: GoogleFonts.oswald(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.0,
                  ),
                ),
                Text(
                  '${_filteredProducts.length} sản phẩm',
                  style: GoogleFonts.montserrat(
                    color: AppColors.textGray,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          if (_filteredProducts.isEmpty)
            Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  const Icon(Icons.search_off, size: 48, color: AppColors.textGray),
                  const SizedBox(height: 12),
                  Text(
                    'Không tìm thấy sản phẩm phù hợp',
                    style: GoogleFonts.oswald(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Hãy thử tìm bằng từ khóa khác hoặc kiểm tra lại chính tả.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: AppColors.textGray,
                    ),
                  ),
                ],
              ),
            )
          else
            ProductGridWidget(
              products: _filteredProducts,
              onAddToCart: _onAddToCart,
            ),
        ],
      ),
    );
  }
}
