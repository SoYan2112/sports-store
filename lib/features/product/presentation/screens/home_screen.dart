import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sports_store_mobile/core/constants/app_colors.dart';
import 'package:sports_store_mobile/features/product/domain/entities/product_entity.dart';
import 'package:sports_store_mobile/features/product/data/datasources/mock_product_data_source.dart';
import 'package:sports_store_mobile/features/product/data/models/product_model.dart';
import 'package:sports_store_mobile/features/product/presentation/widgets/category_filter_chips.dart';
import 'package:sports_store_mobile/features/product/presentation/widgets/promo_banner_widget.dart';
import 'package:sports_store_mobile/features/product/presentation/widgets/product_grid_widget.dart';
import 'package:sports_store_mobile/features/product/presentation/screens/product_search_screen.dart';
import 'package:sports_store_mobile/features/cart/domain/entities/cart_item_entity.dart';
import 'package:sports_store_mobile/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:sports_store_mobile/features/cart/presentation/bloc/cart_event.dart';
import 'package:sports_store_mobile/features/cart/presentation/bloc/cart_state.dart';
import 'package:sports_store_mobile/features/cart/presentation/screens/cart_screen.dart';
import 'package:sports_store_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sports_store_mobile/features/auth/presentation/bloc/auth_state.dart';
import 'package:sports_store_mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:sports_store_mobile/features/checkout_order/presentation/screens/order_history_screen.dart';
import 'package:sports_store_mobile/features/profile_address/presentation/screens/profile_hub_screen.dart';
import 'package:sports_store_mobile/features/profile_address/data/datasources/vietnam_address_local_data.dart';
import 'package:sports_store_mobile/features/voucher/presentation/screens/voucher_management_screen.dart';
import 'package:sports_store_mobile/features/review_rating/presentation/screens/my_reviews_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const List<ProductEntity> mockProducts = MockProductDataSource.mockProducts;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'TẤT CẢ';

  List<ProductModel> get _displayedProducts {
    if (_selectedCategory == 'TẤT CẢ') {
      return MockProductDataSource.mockProducts;
    }
    return MockProductDataSource.mockProducts
        .where((p) => p.category.toUpperCase() == _selectedCategory.toUpperCase())
        .toList();
  }

  void _showUserMenu(BuildContext context, String userName, String userEmail) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.black,
                      child: Icon(
                        Icons.person,
                        color: AppColors.neonVolt,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: GoogleFonts.oswald(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            userEmail,
                            style: GoogleFonts.montserrat(
                              fontSize: 13,
                              color: AppColors.textGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: AppColors.borderGray, height: 1),
                const SizedBox(height: 8),
                ListTile(
                  leading: const Icon(
                    Icons.person_outline,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Tài khoản & Hồ sơ cá nhân',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfileHubScreen(
                          provinces: VietnamAddressLocalData.getProvinces(),
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.receipt_long_outlined,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Đơn hàng của tôi',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const OrderHistoryScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.confirmation_number_outlined,
                    color: AppColors.neonVolt,
                  ),
                  title: Text(
                    'Kho Voucher giảm giá',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    color: AppColors.neonOrange,
                    child: Text(
                      '4 MÃ',
                      style: GoogleFonts.oswald(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const VoucherManagementScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.rate_review_outlined,
                    color: AppColors.neonVolt,
                  ),
                  title: Text(
                    'Đánh giá của tôi',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    color: AppColors.neonVolt,
                    child: Text(
                      '3 CHỜ ĐÁNH GIÁ',
                      style: GoogleFonts.oswald(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MyReviewsScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade900,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.logout, size: 18),
                  label: const Text('ĐĂNG XUẤT'),
                  onPressed: () {
                    Navigator.pop(bottomSheetContext);
                    context.read<AuthBloc>().add(LogoutEvent());
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: AppColors.darkSurface,
                        content: Text('Đã đăng xuất thành công!'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
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
          'Đã thêm ${product.name} (Size ${product.sizes.first}) vào giỏ hàng!',
          style: const TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = _displayedProducts;

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: const Text('ADIDAS VIỆT NAM'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Tìm kiếm sản phẩm',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProductSearchScreen()),
              );
            },
          ),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is Authenticated) {
                return IconButton(
                  icon: const Icon(
                    Icons.account_circle,
                    color: AppColors.neonVolt,
                  ),
                  tooltip: 'Tài khoản',
                  onPressed: () => _showUserMenu(
                    context,
                    state.user.fullName,
                    state.user.email,
                  ),
                );
              }
              return IconButton(
                icon: const Icon(Icons.person_outline),
                tooltip: 'Đăng nhập',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
              );
            },
          ),
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_bag_outlined),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CartScreen()),
                      );
                    },
                  ),
                  if (state.totalItemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.neonOrange,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${state.totalItemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          // 1. Promo Banner Hero
          const PromoBannerWidget(),
          const SizedBox(height: 16),

          // 2. Category Filter Chips (TẤT CẢ, RUNNING, FOOTBALL, ORIGINALS, ...)
          CategoryFilterChips(
            categories: MockProductDataSource.categories,
            selectedCategory: _selectedCategory,
            onSelected: (cat) {
              setState(() {
                _selectedCategory = cat;
              });
            },
          ),
          const SizedBox(height: 16),

          // 3. Section Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _selectedCategory == 'TẤT CẢ'
                        ? 'SẢN PHẨM NỔI BẬT'
                        : 'DANH MỤC: $_selectedCategory',
                    style: GoogleFonts.oswald(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${products.length} MÓN',
                  style: GoogleFonts.montserrat(
                    color: AppColors.textGray,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 4. Product Grid Layout (Compact, Balanced Spacing)
          ProductGridWidget(
            products: products,
            onAddToCart: _onAddToCart,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
