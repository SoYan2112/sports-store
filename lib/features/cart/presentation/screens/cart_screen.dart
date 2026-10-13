import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';

import 'package:sports_store_mobile/features/voucher/domain/entities/voucher_entity.dart';
import 'package:sports_store_mobile/features/voucher/presentation/widgets/apply_voucher_bottom_sheet.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  VoucherEntity? _appliedVoucher;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GIỎ HÀNG'),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_bag_outlined, size: 80, color: AppColors.textGray),
                  const SizedBox(height: 16),
                  Text(
                    'GIỎ HÀNG CỦA BẠN ĐANG TRỐNG',
                    style: GoogleFonts.oswald(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Hãy chọn cho mình đôi giày thể thao yêu thích!',
                    style: GoogleFonts.montserrat(color: AppColors.textGray),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      foregroundColor: AppColors.black,
                      minimumSize: const Size(200, 48),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('TIẾP TỤC MUA SẮM'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      color: AppColors.darkSurface,
                      child: Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            color: Colors.black,
                            child: const Icon(Icons.sports, color: AppColors.textGray),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: GoogleFonts.oswald(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Size: ${item.size}',
                                  style: GoogleFonts.montserrat(
                                    color: AppColors.textGray,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  CurrencyFormatter.formatVnd(item.price),
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.neonOrange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove, size: 18),
                                onPressed: () {
                                  context.read<CartBloc>().add(
                                        UpdateQuantityEvent(item.id, item.quantity - 1),
                                      );
                                },
                              ),
                              Text(
                                '${item.quantity}',
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add, size: 18),
                                onPressed: () {
                                  context.read<CartBloc>().add(
                                        UpdateQuantityEvent(item.id, item.quantity + 1),
                                      );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Khối Áp dụng Mã giảm giá (Voucher)
              InkWell(
                onTap: () async {
                  final result = await ApplyVoucherBottomSheet.show(
                    context: context,
                    orderTotal: state.totalAmount.toDouble(),
                    currentVoucher: _appliedVoucher,
                  );
                  if (mounted) {
                    setState(() {
                      _appliedVoucher = result;
                    });
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.darkSurface,
                    border: Border.all(
                      color: _appliedVoucher != null
                          ? AppColors.neonVolt
                          : AppColors.borderGray.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.confirmation_number_outlined,
                        color: _appliedVoucher != null ? AppColors.neonVolt : AppColors.textGray,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _appliedVoucher != null
                                  ? 'MÃ GIẢM GIÁ: ${_appliedVoucher!.code}'
                                  : 'MÃ GIẢM GIÁ / VOUCHER ADIDAS',
                              style: GoogleFonts.oswald(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: _appliedVoucher != null
                                    ? AppColors.neonVolt
                                    : AppColors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              _appliedVoucher != null
                                  ? 'Đã giảm: -${CurrencyFormatter.formatVnd(_appliedVoucher!.calculateDiscount(state.totalAmount.toDouble()))}'
                                  : 'Chọn hoặc nhập mã để nhận chiết khấu',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                color: _appliedVoucher != null
                                    ? AppColors.white
                                    : AppColors.textGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        _appliedVoucher != null ? 'THAY ĐỔI >' : 'CHỌN MÃ >',
                        style: GoogleFonts.oswald(
                          fontSize: 12,
                          color: AppColors.textGray,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Checkout Box
              Builder(
                builder: (context) {
                  final discount = _appliedVoucher != null
                      ? _appliedVoucher!.calculateDiscount(state.totalAmount.toDouble())
                      : 0.0;
                  final finalAmount = (state.totalAmount - discount).clamp(0.0, double.infinity);

                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: AppColors.darkSurface,
                      border: Border(top: BorderSide(color: AppColors.borderGray, width: 0.1)),
                    ),
                    child: SafeArea(
                      child: Column(
                        children: [
                          if (discount > 0) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'TIỀN HÀNG GỐC',
                                  style: GoogleFonts.oswald(
                                    color: AppColors.textGray,
                                    fontSize: 12,
                                    letterSpacing: 1,
                                  ),
                                ),
                                Text(
                                  CurrencyFormatter.formatVnd(state.totalAmount),
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    color: AppColors.textGray,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'GIẢM GIÁ VOUCHER (${_appliedVoucher!.code})',
                                  style: GoogleFonts.oswald(
                                    color: AppColors.neonVolt,
                                    fontSize: 12,
                                    letterSpacing: 1,
                                  ),
                                ),
                                Text(
                                  '-${CurrencyFormatter.formatVnd(discount)}',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.neonVolt,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Divider(color: AppColors.borderGray, height: 1, thickness: 0.1),
                            const SizedBox(height: 8),
                          ],
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'TỔNG THANH TOÁN',
                                style: GoogleFonts.oswald(
                                  color: AppColors.textGray,
                                  fontSize: 14,
                                  letterSpacing: 1,
                                ),
                              ),
                              Text(
                                CurrencyFormatter.formatVnd(finalAmount),
                                style: GoogleFonts.montserrat(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: AppColors.success,
                                  content: Text(
                                    'Tiến hành thanh toán đơn ${CurrencyFormatter.formatVnd(finalAmount)} (COD / VNPAY)...',
                                  ),
                                ),
                              );
                            },
                            child: const Text('TIẾN HÀNH THANH TOÁN (COD / VNPAY)'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
