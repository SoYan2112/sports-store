import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/voucher_entity.dart';

class VoucherCardWidget extends StatelessWidget {
  final VoucherEntity voucher;
  final bool isSelectable;
  final bool isSelected;
  final double? currentOrderTotal;
  final VoidCallback? onSelect;
  final VoidCallback? onUseNow;
  final VoidCallback? onClaim;
  final bool isClaimed;

  const VoucherCardWidget({
    super.key,
    required this.voucher,
    this.isSelectable = false,
    this.isSelected = false,
    this.currentOrderTotal,
    this.onSelect,
    this.onUseNow,
    this.onClaim,
    this.isClaimed = false,
  });

  bool get _isUsable {
    if (voucher.isExpired) return false;
    if (currentOrderTotal != null) {
      return voucher.isValidForOrder(currentOrderTotal!);
    }
    return true;
  }

  void _copyVoucherCode(BuildContext context) {
    Clipboard.setData(ClipboardData(text: voucher.code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.darkSurface,
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.neonVolt, size: 20),
            const SizedBox(width: 10),
            Text(
              'Đã sao chép mã "${voucher.code}"',
              style: GoogleFonts.montserrat(color: AppColors.white),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showVoucherTerms(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        final dateFormat = DateFormat('dd/MM/yyyy');
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ĐIỀU KIỆN MÃ GIẢM GIÁ',
                      style: GoogleFonts.oswald(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                        letterSpacing: 1,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textGray),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  color: Colors.black,
                  child: Row(
                    children: [
                      const Icon(Icons.confirmation_number_outlined, color: AppColors.neonVolt),
                      const SizedBox(width: 12),
                      Text(
                        voucher.code,
                        style: GoogleFonts.oswald(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.neonVolt,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildTermRow('Ưu đãi', voucher.title),
                _buildTermRow(
                  'Giá trị đơn tối thiểu',
                  CurrencyFormatter.formatVnd(voucher.minOrderAmount),
                ),
                if (voucher.maxDiscountAmount != null)
                  _buildTermRow(
                    'Mức giảm tối đa',
                    CurrencyFormatter.formatVnd(voucher.maxDiscountAmount!),
                  ),
                _buildTermRow(
                  'Hạn sử dụng',
                  'Đến ${dateFormat.format(voucher.endDate)}',
                ),
                _buildTermRow('Phạm vi áp dụng', voucher.description),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('ĐÃ HIỂU'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTermRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: GoogleFonts.montserrat(color: AppColors.textGray, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.montserrat(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final isUsable = _isUsable;
    final progress = (voucher.usedCount / voucher.usageLimit).clamp(0.0, 1.0);

    return Opacity(
      opacity: isUsable ? 1.0 : 0.55,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          border: Border.all(
            color: isSelected
                ? AppColors.neonVolt
                : (isUsable ? AppColors.white.withValues(alpha: 0.15) : AppColors.textGray.withValues(alpha: 0.2)),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cột bên trái: Badge loại giảm giá
            Container(
              width: 90,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
              color: isUsable ? Colors.black : Colors.black54,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      voucher.discountType == VoucherDiscountType.freeShipping
                          ? Icons.local_shipping
                          : Icons.sports_score,
                      color: isUsable ? AppColors.neonVolt : AppColors.textGray,
                      size: 26,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      voucher.discountType == VoucherDiscountType.freeShipping
                          ? 'FREE SHIP'
                          : (voucher.discountType == VoucherDiscountType.percentage
                              ? '-${voucher.discountValue.toInt()}%'
                              : '-${(voucher.discountValue / 1000).toInt()}K'),
                      style: GoogleFonts.oswald(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isUsable ? AppColors.white : AppColors.textGray,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ADIDAS VN',
                      style: GoogleFonts.oswald(
                        fontSize: 10,
                        color: AppColors.textGray,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),

              // Vạch ngăn cách răng cưa / nét đứt
              Container(
                width: 1,
                color: AppColors.black,
              ),

              // Cột nội dung chính
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (voucher.categoryName != null) ...[
                        Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(color: AppColors.neonVolt, width: 0.8),
                          ),
                          child: Text(
                            voucher.categoryName!,
                            style: GoogleFonts.oswald(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.neonVolt,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            color: isUsable ? AppColors.neonOrange : AppColors.textGray,
                            child: Text(
                              voucher.code,
                              style: GoogleFonts.oswald(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const Spacer(),
                          if (isSelectable)
                            GestureDetector(
                              onTap: isUsable ? onSelect : null,
                              child: Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected ? AppColors.neonVolt : AppColors.textGray,
                                    width: 2,
                                  ),
                                  color: isSelected ? AppColors.neonVolt : Colors.transparent,
                                ),
                                child: isSelected
                                    ? const Icon(Icons.check, size: 14, color: Colors.black)
                                    : null,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        voucher.title,
                        style: GoogleFonts.oswald(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                          letterSpacing: 0.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Đơn tối thiểu: ${CurrencyFormatter.formatVnd(voucher.minOrderAmount)}',
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          color: isUsable ? AppColors.textGray : AppColors.error,
                          fontWeight: isUsable ? FontWeight.normal : FontWeight.w600,
                        ),
                      ),
                      if (voucher.isExpired)
                        Text(
                          'Đã hết hạn vào ${dateFormat.format(voucher.endDate)}',
                          style: GoogleFonts.montserrat(fontSize: 11, color: AppColors.error),
                        )
                      else
                        Text(
                          'HSD: Đến ${dateFormat.format(voucher.endDate)}',
                          style: GoogleFonts.montserrat(fontSize: 11, color: AppColors.textGray),
                        ),
                      const SizedBox(height: 8),

                      // Thanh tiến trình số lượng voucher
                      if (!voucher.isExpired) ...[
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  backgroundColor: Colors.black,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    progress > 0.8 ? AppColors.error : AppColors.neonVolt,
                                  ),
                                  minHeight: 4,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Đã dùng ${(progress * 100).toInt()}%',
                              style: GoogleFonts.montserrat(
                                fontSize: 10,
                                color: AppColors.textGray,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],

                      // Hàng nút điều kiện & thao tác
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => _showVoucherTerms(context),
                            child: Text(
                              'Điều kiện >',
                              style: GoogleFonts.montserrat(
                                fontSize: 11,
                                color: AppColors.textGray,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          if (!isSelectable)
                            Row(
                              children: [
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    side: const BorderSide(color: AppColors.textGray),
                                    minimumSize: const Size(60, 28),
                                  ),
                                  onPressed: () => _copyVoucherCode(context),
                                  child: Text(
                                    'SAO CHÉP',
                                    style: GoogleFonts.oswald(fontSize: 11, color: AppColors.white),
                                  ),
                                ),
                                if (onClaim != null) ...[
                                  const SizedBox(width: 6),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isClaimed ? AppColors.darkSurface : AppColors.neonVolt,
                                      foregroundColor: isClaimed ? AppColors.textGray : Colors.black,
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      minimumSize: const Size(60, 28),
                                    ),
                                    onPressed: isClaimed ? null : onClaim,
                                    child: Text(
                                      isClaimed ? 'ĐÃ LƯU ✓' : 'LƯU MÃ',
                                      style: GoogleFonts.oswald(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: isClaimed ? AppColors.textGray : Colors.black,
                                      ),
                                    ),
                                  ),
                                ] else if (onUseNow != null && isUsable) ...[
                                  const SizedBox(width: 6),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.white,
                                      foregroundColor: AppColors.black,
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      minimumSize: const Size(60, 28),
                                    ),
                                    onPressed: onUseNow,
                                    child: Text(
                                      'DÙNG NGAY',
                                      style: GoogleFonts.oswald(fontSize: 11),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
