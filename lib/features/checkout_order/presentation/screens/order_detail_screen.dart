import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../cart/domain/entities/cart_item_entity.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../../../cart/presentation/screens/cart_screen.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_status.dart';
import '../widgets/order_status_badge.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback? onCancel;

  const OrderDetailScreen({
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
                Navigator.pop(dialogContext); // Đóng dialog
                Navigator.pop(context); // Quay về màn hình danh sách đơn
                onCancel?.call();
              },
              child: const Text('XÁC NHẬN HỦY'),
            ),
          ],
        );
      },
    );
  }

  void _reorderItems(BuildContext context) {
    final cartBloc = context.read<CartBloc>();
    for (final item in order.items) {
      cartBloc.add(
        AddToCartEvent(
          CartItemEntity(
            id: '${item.productId}_${item.size}',
            productId: item.productId,
            name: item.name,
            price: item.price,
            imageUrl: item.imageUrl,
            size: item.size,
            quantity: item.quantity,
          ),
        ),
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.neonVolt,
        content: Text(
          'Đã thêm các món vào giỏ hàng!',
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        duration: const Duration(seconds: 2),
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CartScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy • HH:mm');
    final formattedDate = dateFormat.format(order.createdAt);

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        title: Text(
          'CHI TIẾT ĐƠN HÀNG',
          style: GoogleFonts.oswald(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status & Order ID Header Card
            _buildStatusHeader(formattedDate),

            const SizedBox(height: 12),

            // Tracking Step Progress Timeline
            _buildTimelineTracker(),

            const SizedBox(height: 12),

            // Shipping Address & Tracking Number
            _buildShippingInfo(context),

            const SizedBox(height: 12),

            // Items List
            _buildProductsList(),

            const SizedBox(height: 12),

            // Payment method
            _buildPaymentInfo(),

            const SizedBox(height: 12),

            // Financial Summary
            _buildPaymentSummary(),
          ],
        ),
      ),
      bottomSheet: _buildBottomActionBar(context),
    );
  }

  Widget _buildStatusHeader(String formattedDate) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: AppColors.darkSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MÃ ĐƠN: #${order.id}',
                style: GoogleFonts.oswald(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Colors.white,
                ),
              ),
              OrderStatusBadge(status: order.status),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Thời gian đặt: $formattedDate',
            style: GoogleFonts.montserrat(
              fontSize: 13,
              color: AppColors.textGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineTracker() {
    if (order.status == OrderStatus.cancelled) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        color: AppColors.darkSurface,
        child: Row(
          children: [
            const Icon(Icons.cancel, color: AppColors.error, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ĐƠN HÀNG ĐÃ BỊ HỦY',
                    style: GoogleFonts.oswald(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.error,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Đơn hàng này đã kết thúc và không còn hiệu lực giao dịch.',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: AppColors.textGray,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final steps = [
      {'title': 'Đã đặt hàng', 'active': true},
      {
        'title': 'Đang đóng gói',
        'active': order.status == OrderStatus.shipping ||
            order.status == OrderStatus.delivered
      },
      {
        'title': 'Đang giao',
        'active': order.status == OrderStatus.shipping ||
            order.status == OrderStatus.delivered
      },
      {'title': 'Hoàn thành', 'active': order.status == OrderStatus.delivered},
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      color: AppColors.darkSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TIẾN TRÌNH VẬN CHUYỂN',
            style: GoogleFonts.oswald(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: List.generate(steps.length, (index) {
              final step = steps[index];
              final isActive = step['active'] as bool;
              final isLast = index == steps.length - 1;

              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isActive ? AppColors.neonVolt : Colors.black,
                              border: Border.all(
                                color: isActive
                                    ? AppColors.neonVolt
                                    : AppColors.borderGray.withValues(alpha: 0.4),
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              isActive ? Icons.check : Icons.circle,
                              size: isActive ? 16 : 8,
                              color: isActive ? Colors.black : AppColors.textGray,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            step['title'] as String,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              fontSize: 10,
                              fontWeight:
                                  isActive ? FontWeight.bold : FontWeight.normal,
                              color: isActive ? Colors.white : AppColors.textGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 16,
                        height: 2,
                        color: (steps[index + 1]['active'] as bool)
                            ? AppColors.neonVolt
                            : AppColors.borderGray.withValues(alpha: 0.3),
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingInfo(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: AppColors.darkSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: AppColors.neonVolt, size: 20),
              const SizedBox(width: 8),
              Text(
                'ĐỊA CHỈ NHẬN HÀNG',
                style: GoogleFonts.oswald(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${order.recipientName}  •  ${order.recipientPhone}',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            order.shippingAddress,
            style: GoogleFonts.montserrat(
              fontSize: 13,
              color: AppColors.textGray,
              height: 1.4,
            ),
          ),
          if (order.trackingNumber != null) ...[
            const SizedBox(height: 12),
            const Divider(color: Color(0xFF222222), height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.local_shipping_outlined, color: AppColors.textGray, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Mã vận đơn: ',
                  style: GoogleFonts.montserrat(color: AppColors.textGray, fontSize: 13),
                ),
                Text(
                  order.trackingNumber!,
                  style: GoogleFonts.oswald(
                    color: AppColors.neonVolt,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: order.trackingNumber!));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Đã sao chép mã vận đơn'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: Icon(Icons.copy, size: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProductsList() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: AppColors.darkSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SẢN PHẨM (${order.items.length})',
            style: GoogleFonts.oswald(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: order.items.length,
            separatorBuilder: (_, _) => const Divider(
              color: Color(0xFF222222),
              height: 24,
            ),
            itemBuilder: (context, index) {
              final item = order.items[index];
              final itemTotal = item.price * item.quantity;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 72,
                    height: 72,
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
                        size: 32,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: GoogleFonts.oswald(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Size: ${item.size}  •  Số lượng: x${item.quantity}',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: AppColors.textGray,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              CurrencyFormatter.formatVnd(item.price),
                              style: GoogleFonts.montserrat(
                                fontSize: 13,
                                color: AppColors.textGray,
                              ),
                            ),
                            Text(
                              CurrencyFormatter.formatVnd(itemTotal),
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: AppColors.darkSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PHƯƠNG THỨC THANH TOÁN',
            style: GoogleFonts.oswald(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                order.paymentMethod.contains('VNPAY')
                    ? Icons.qr_code_2_rounded
                    : Icons.money_rounded,
                color: AppColors.neonVolt,
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                order.paymentMethod,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: AppColors.darkSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CHI TIẾT THANH TOÁN',
            style: GoogleFonts.oswald(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 14),
          _buildSummaryRow(
            'Tổng tiền hàng',
            CurrencyFormatter.formatVnd(order.totalAmount),
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Phí vận chuyển',
            order.shippingFee == 0 ? 'MIỄN PHÍ' : CurrencyFormatter.formatVnd(order.shippingFee),
            valueColor: order.shippingFee == 0 ? AppColors.neonVolt : Colors.white,
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Giảm giá khuyến mãi',
            '- 0 ₫',
            valueColor: AppColors.textGray,
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFF222222), height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TỔNG THANH TOÁN',
                style: GoogleFonts.oswald(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  color: Colors.white,
                ),
              ),
              Text(
                CurrencyFormatter.formatVnd(order.totalAmount + order.shippingFee),
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonVolt,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(fontSize: 13, color: AppColors.textGray),
        ),
        Text(
          value,
          style: GoogleFonts.montserrat(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor ?? Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActionBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        border: Border(
          top: BorderSide(
            color: AppColors.borderGray.withValues(alpha: 0.15),
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (order.status == OrderStatus.pending) ...[
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    minimumSize: const Size(0, 48),
                  ),
                  onPressed: () => _showCancelConfirmDialog(context),
                  child: Text(
                    'HỦY ĐƠN HÀNG',
                    style: GoogleFonts.oswald(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            if (order.status == OrderStatus.delivered ||
                order.status == OrderStatus.cancelled) ...[
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.black,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    minimumSize: const Size(0, 48),
                  ),
                  onPressed: () => _reorderItems(context),
                  child: Text(
                    'MUA LẠI ĐƠN NÀY',
                    style: GoogleFonts.oswald(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.headset_mic_outlined, size: 18),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  minimumSize: const Size(0, 48),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Hotline hỗ trợ CSKH: 1900 6868 (8:00 - 22:00)'),
                    ),
                  );
                },
                label: Text(
                  'HỖ TRỢ',
                  style: GoogleFonts.oswald(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

