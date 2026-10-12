import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sports_store_mobile/core/constants/app_colors.dart';
import 'package:sports_store_mobile/core/utils/currency_formatter.dart';
import 'package:sports_store_mobile/features/product/domain/entities/product_entity.dart';
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<ProductEntity> mockProducts = [
    ProductEntity(
      id: 'P1',
      name: 'ULTRABOOST LIGHT 23',
      category: 'RUNNING',
      price: 4900000,
      imageUrl: 'https://assets.adidas.com/images/w_600,f_auto,q_auto/a225e6f3d82d4fb4bc00af6b0147fc5e_9366/Ultraboost_Light_Running_Shoes_White_HQ6351_01_standard.jpg',
      sizes: ['40', '41', '42', '43'],
      description: 'Đôi giày chạy bộ nhẹ nhất từ trước đến nay của chúng tôi, tạo ra nguồn năng lượng vô tận.',
    ),
    ProductEntity(
      id: 'P2',
      name: 'SAMBA OG CLASSIC',
      category: 'ORIGINALS',
      price: 2700000,
      imageUrl: 'https://assets.adidas.com/images/w_600,f_auto,q_auto/4e894c2b76dd4c8e9013aafc016047af_9366/Giay_Samba_OG_trang_B75806_01_00_standard.jpg',
      sizes: ['39', '40', '41', '42', '43'],
      description:
          'Huyền thoại phong cách đường phố đích thực, thiết kế da kinh điển.',
    ),
    ProductEntity(
      id: 'P3',
      name: 'PREDATOR ELITE FG',
      category: 'FOOTBALL',
      price: 6500000,
      imageUrl: 'https://assets.adidas.com/images/w_600,f_auto,q_auto/9d115469ad104f4c82c6b052011b1c67_9366/Giay_Predator_Elite_Firm_Ground_den_IF8867_01_standard.jpg',
      sizes: ['40', '41', '42', '42.5'],
      description: 'Tối ưu độ chính xác và lực sút trên sân cỏ tự nhiên.',
    ),
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SPORTS STORE'),
        actions: [
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
          // Banner Thể Thao Phong Cách Adidas
          Container(
            height: 220,
            width: double.infinity,
            color: AppColors.darkSurface,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.9),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  bottom: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        color: AppColors.neonVolt,
                        child: Text(
                          'BỘ SƯU TẬP 2026',
                          style: GoogleFonts.oswald(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'YOU GOT THIS.',
                        style: GoogleFonts.oswald(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        'Đánh thức đam mê thể thao chuẩn Việt Nam',
                        style: GoogleFonts.montserrat(
                          color: AppColors.textGray,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'SẢN PHẨM NỔI BẬT',
                    style: GoogleFonts.oswald(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Xem tất cả',
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
              ],
            ),
          ),

          // Danh Sách Sản Phẩm Card Grid
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: mockProducts.length,
            separatorBuilder: (_, _) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final product = mockProducts[index];
              return Container(
                padding: const EdgeInsets.all(12),
                color: AppColors.darkSurface,
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      color: Colors.black,
                      child: const Center(
                        child: Icon(
                          Icons.sports,
                          size: 40,
                          color: AppColors.textGray,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.category,
                            style: GoogleFonts.oswald(
                              color: AppColors.textGray,
                              fontSize: 11,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product.name,
                            style: GoogleFonts.oswald(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            CurrencyFormatter.formatVnd(product.price),
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.neonOrange,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 36),
                              backgroundColor: AppColors.white,
                              foregroundColor: AppColors.black,
                            ),
                            onPressed: () {
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
                            },
                            child: const Text('THÊM VÀO GIỎ'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
