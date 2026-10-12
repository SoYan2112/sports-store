import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/datasources/voucher_mock_data.dart';
import '../../domain/entities/voucher_entity.dart';
import '../widgets/voucher_card_widget.dart';

class DiscoverVouchersScreen extends StatefulWidget {
  final List<String> claimedCodes;
  final ValueChanged<VoucherEntity>? onVoucherClaimed;

  const DiscoverVouchersScreen({
    super.key,
    this.claimedCodes = const [],
    this.onVoucherClaimed,
  });

  @override
  State<DiscoverVouchersScreen> createState() => _DiscoverVouchersScreenState();
}

class _DiscoverVouchersScreenState extends State<DiscoverVouchersScreen> {
  late List<VoucherEntity> _allVouchers;
  late Set<String> _claimedCodeSet;
  String _selectedCategoryFilter = 'TẤT CẢ';

  final List<String> _categories = [
    'TẤT CẢ',
    'RUNNING',
    'FOOTBALL',
    'ORIGINALS',
    'TRAINING',
  ];

  @override
  void initState() {
    super.initState();
    _allVouchers = VoucherMockData.getDiscoverableVouchers();
    _claimedCodeSet = Set<String>.from(widget.claimedCodes);
  }

  List<VoucherEntity> get _filteredVouchers {
    if (_selectedCategoryFilter == 'TẤT CẢ') {
      return _allVouchers;
    }
    return _allVouchers.where((v) {
      final cat = (v.categoryName ?? '').toUpperCase();
      return cat.contains(_selectedCategoryFilter);
    }).toList();
  }

  void _claimVoucher(VoucherEntity voucher) {
    if (_claimedCodeSet.contains(voucher.code)) {
      _showToast('Voucher "${voucher.code}" đã có trong ví của bạn!');
      return;
    }

    setState(() {
      _claimedCodeSet.add(voucher.code);
    });

    final claimed = voucher.copyWith(isClaimed: true);
    widget.onVoucherClaimed?.call(claimed);

    _showToast('Đã lưu mã "${voucher.code}" vào ví của bạn thành công!');
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.success,
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayList = _filteredVouchers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TÌM THÊM VOUCHER'),
      ),
      body: CustomScrollView(
        slivers: [
          // Banner thông báo chiến dịch ưu đãi
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E1E1E), Color(0xFF2C2C2C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: const Border(left: BorderSide(color: AppColors.neonVolt, width: 4)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.campaign_outlined, color: AppColors.neonVolt, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ƯU ĐÃI THEO DÒNG SẢN PHẨM THỂ THAO',
                          style: GoogleFonts.oswald(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.neonVolt,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Khám phá & lưu mã giảm giá độc quyền dành riêng cho từng bộ môn thể thao. Nhấn "LƯU MÃ" để lưu vào ví cá nhân và tự động áp dụng khi thanh toán.',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: AppColors.white,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bộ lọc dòng sản phẩm (Category Chips)
          SliverToBoxAdapter(
            child: SizedBox(
              height: 40,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCategoryFilter == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategoryFilter = cat;
                        });
                      }
                    },
                    selectedColor: AppColors.neonVolt,
                    backgroundColor: AppColors.darkSurface,
                    labelStyle: GoogleFonts.oswald(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                      color: isSelected ? Colors.black : AppColors.textGray,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                      side: BorderSide(
                        color: isSelected ? AppColors.neonVolt : Colors.transparent,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 12),
          ),

          // Danh sách vouchers
          if (displayList.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Center(
                  child: Text(
                    'Không có voucher nào phù hợp',
                    style: GoogleFonts.montserrat(color: AppColors.textGray, fontSize: 14),
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final voucher = displayList[index];
                    final isClaimed = _claimedCodeSet.contains(voucher.code);

                    return VoucherCardWidget(
                      voucher: voucher,
                      isClaimed: isClaimed,
                      onClaim: () => _claimVoucher(voucher),
                    );
                  },
                  childCount: displayList.length,
                ),
              ),
            ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 32),
          ),
        ],
      ),
    );
  }
}
