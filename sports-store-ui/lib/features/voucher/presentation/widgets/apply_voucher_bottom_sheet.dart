import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../data/datasources/voucher_mock_data.dart';
import '../../domain/entities/voucher_entity.dart';
import 'voucher_card_widget.dart';

class ApplyVoucherBottomSheet extends StatefulWidget {
  final double orderTotal;
  final VoucherEntity? initialSelectedVoucher;

  const ApplyVoucherBottomSheet({
    super.key,
    required this.orderTotal,
    this.initialSelectedVoucher,
  });

  /// Static helper mở modal chọn voucher và trả về voucher đã chọn
  static Future<VoucherEntity?> show({
    required BuildContext context,
    required double orderTotal,
    VoucherEntity? currentVoucher,
  }) {
    return showModalBottomSheet<VoucherEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => ApplyVoucherBottomSheet(
        orderTotal: orderTotal,
        initialSelectedVoucher: currentVoucher,
      ),
    );
  }

  @override
  State<ApplyVoucherBottomSheet> createState() => _ApplyVoucherBottomSheetState();
}

class _ApplyVoucherBottomSheetState extends State<ApplyVoucherBottomSheet> {
  final TextEditingController _codeController = TextEditingController();
  late List<VoucherEntity> _vouchers;
  VoucherEntity? _selectedVoucher;
  String _inputError = '';

  @override
  void initState() {
    super.initState();
    _vouchers = VoucherMockData.getAvailableVouchers();
    _selectedVoucher = widget.initialSelectedVoucher;
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _applyManualCode() {
    final code = _codeController.text.trim().toUpperCase();
    if (code.isEmpty) {
      setState(() {
        _inputError = 'Vui lòng nhập mã giảm giá';
      });
      return;
    }

    // Tìm voucher khớp mã
    final matched = _vouchers.cast<VoucherEntity?>().firstWhere(
      (v) => v?.code.toUpperCase() == code,
      orElse: () => null,
    );

    if (matched == null) {
      setState(() {
        _inputError = 'Mã giảm giá không tồn tại hoặc đã hết hạn';
      });
      return;
    }

    if (!matched.isValidForOrder(widget.orderTotal)) {
      final needed = matched.minOrderAmount - widget.orderTotal;
      setState(() {
        _inputError = 'Chưa đủ điều kiện: Cần mua thêm ${CurrencyFormatter.formatVnd(needed)}';
      });
      return;
    }

    setState(() {
      _selectedVoucher = matched;
      _inputError = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final discountAmount = _selectedVoucher != null
        ? _selectedVoucher!.calculateDiscount(widget.orderTotal)
        : 0.0;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ÁP DỤNG MÃ GIẢM GIÁ',
                    style: GoogleFonts.oswald(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: AppColors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textGray),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(color: AppColors.borderGray, height: 1, thickness: 0.2),

            // Nhập mã voucher trực tiếp
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: TextField(
                            controller: _codeController,
                            textCapitalization: TextCapitalization.characters,
                            style: GoogleFonts.oswald(
                              fontSize: 14,
                              letterSpacing: 1.5,
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Nhập mã voucher (VD: ADICLUB15)',
                              hintStyle: GoogleFonts.montserrat(
                                color: AppColors.textGray,
                                fontSize: 13,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                              prefixIcon: const Icon(
                                Icons.discount_outlined,
                                color: AppColors.textGray,
                                size: 20,
                              ),
                            ),
                            onChanged: (_) {
                              if (_inputError.isNotEmpty) {
                                setState(() => _inputError = '');
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.white,
                            foregroundColor: AppColors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            minimumSize: const Size(80, 48),
                          ),
                          onPressed: _applyManualCode,
                          child: const Text('ÁP DỤNG'),
                        ),
                      ),
                    ],
                  ),
                  if (_inputError.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      _inputError,
                      style: GoogleFonts.montserrat(
                        color: AppColors.error,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Tiêu đề danh sách voucher
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'MÃ GIẢM GIÁ KHẢ DỤNG',
                      style: GoogleFonts.oswald(
                        fontSize: 13,
                        color: AppColors.textGray,
                        letterSpacing: 0.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Đơn: ${CurrencyFormatter.formatVnd(widget.orderTotal)}',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: AppColors.neonVolt,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Danh sách vouchers
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                itemCount: _vouchers.length,
                itemBuilder: (context, index) {
                  final voucher = _vouchers[index];
                  final isSelected = _selectedVoucher?.id == voucher.id;

                  return VoucherCardWidget(
                    voucher: voucher,
                    isSelectable: true,
                    isSelected: isSelected,
                    currentOrderTotal: widget.orderTotal,
                    onSelect: () {
                      setState(() {
                        if (isSelected) {
                          _selectedVoucher = null;
                        } else {
                          _selectedVoucher = voucher;
                          _inputError = '';
                        }
                      });
                    },
                  );
                },
              ),
            ),

            // Khối Bottom xác nhận
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.black,
                border: Border(top: BorderSide(color: AppColors.borderGray, width: 0.2)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ƯU ĐÃI TIẾT KIỆM ĐƯỢC',
                            style: GoogleFonts.oswald(
                              color: AppColors.textGray,
                              fontSize: 12,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            '-${CurrencyFormatter.formatVnd(discountAmount)}',
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: discountAmount > 0
                                  ? AppColors.neonVolt
                                  : AppColors.white,
                            ),
                          ),
                        ],
                      ),
                      if (_selectedVoucher != null)
                        TextButton(
                          onPressed: () {
                            setState(() => _selectedVoucher = null);
                          },
                          child: Text(
                            'HỦY DÙNG',
                            style: GoogleFonts.oswald(
                              color: AppColors.error,
                              fontSize: 13,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, _selectedVoucher);
                    },
                    child: Text(
                      _selectedVoucher != null
                          ? 'XÁC NHẬN ÁP DỤNG (${_selectedVoucher!.code})'
                          : 'ĐÓNG',
                    ),
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
