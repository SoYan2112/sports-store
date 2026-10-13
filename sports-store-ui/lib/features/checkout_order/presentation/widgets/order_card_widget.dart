import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_status.dart';
import 'order_status_badge.dart';
import '../screens/order_detail_screen.dart';
import '../../../review_rating/presentation/screens/rating_form_screen.dart';

class OrderCardWidget extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback? onCancel;

  const OrderCardWidget({
    super.key,
    required this.order,
    this.onCancel,
  });

  void _showCancelConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.darkSurface,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          title: Text(
            'HỦY ĐƠN HÀNG',
            style: GoogleFonts.oswald(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: Colors.white,
            ),
          ),
          content: Text(
            'Bạn có chắc chắn muốn hủy đơn hàng #${order.id} không?',
            style: GoogleFonts.montserrat(color: AppColors.textGray, fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'QUAY LẠI',
                style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                onCancel?.call();
              },
              child: const Text('XÁC NHẬN HỦY'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OrderDetailScreen(
          order: order,
          onCancel: onCancel,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy • HH:mm');
    final formattedDate = dateFormat.format(order.createdAt);

    return InkWell(
      onTap: () => _navigateToDetail(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.15)),
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#${order.id}',
                      style: GoogleFonts.oswald(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formattedDate,
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: AppColors.textGray,
                      ),
                    ),
                  ],
                ),
                OrderStatusBadge(status: order.status),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFF222222)),

          // Items List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: order.items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = order.items[index];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Product Thumbnail
                  Container(
                    width: 64,
                    height: 64,
                    color: Colors.black,
                    child: CachedNetworkImage(
                      imageUrl: item.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white),
                        ),
                      ),
                      errorWidget: (_, _, _) => const Icon(
                        Icons.sports,
                        color: AppColors.textGray,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Product Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.oswald(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Size: ${item.size}  •  SL: x${item.quantity}',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: AppColors.textGray,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          CurrencyFormatter.formatVnd(item.price),
                          style: GoogleFonts.montserrat(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          const Divider(height: 1, color: Color(0xFF222222)),

          // Shipping address & Payment
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textGray),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    order.shippingAddress,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: AppColors.textGray,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFF222222)),

          // Total & Actions
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TỔNG THANH TOÁN (${order.items.fold(0, (sum, i) => sum + i.quantity)} MÓN)',
                      style: GoogleFonts.oswald(
                        fontSize: 11,
                        color: AppColors.textGray,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      CurrencyFormatter.formatVnd(order.totalAmount),
                      style: GoogleFonts.montserrat(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.neonVolt,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    if (order.status == OrderStatus.pending) ...[
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: const BorderSide(color: AppColors.error),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        ),
                        onPressed: () => _showCancelConfirmDialog(context),
                        child: Text(
                          'HỦY ĐƠN',
                          style: GoogleFonts.oswald(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (order.status == OrderStatus.delivered && order.items.isNotEmpty) ...[
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.neonVolt,
                          foregroundColor: Colors.black,
                          minimumSize: const Size(96, 36),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        ),
                        icon: const Icon(Icons.star_outline, size: 16),
                        label: Text(
                          'ĐÁNH GIÁ',
                          style: GoogleFonts.oswald(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          final item = order.items.first;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RatingFormScreen(
                                productId: item.productId,
                                productName: item.name,
                                productCategory: 'Giày thể thao',
                                productImageUrl: item.imageUrl,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                    ],
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.white,
                        side: const BorderSide(color: AppColors.white),
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                      onPressed: () => _navigateToDetail(context),
                      child: Text(
                        'CHI TIẾT',
                        style: GoogleFonts.oswald(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}
