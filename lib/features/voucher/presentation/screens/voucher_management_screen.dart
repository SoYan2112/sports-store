import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../cart/presentation/screens/cart_screen.dart';
import '../../data/datasources/voucher_mock_data.dart';
import '../../domain/entities/voucher_entity.dart';
import '../widgets/voucher_card_widget.dart';
import 'discover_vouchers_screen.dart';

class VoucherManagementScreen extends StatefulWidget {
  const VoucherManagementScreen({super.key});

  @override
  State<VoucherManagementScreen> createState() => _VoucherManagementScreenState();
}

class _VoucherManagementScreenState extends State<VoucherManagementScreen> {
  final TextEditingController _codeController = TextEditingController();
  int _selectedTabIndex = 0;
  bool _isInputExpanded = false;

  List<VoucherEntity> _availableVouchers = [];
  List<VoucherEntity> _expiredVouchers = [];

  @override
  void initState() {
    super.initState();
    _availableVouchers = VoucherMockData.getAvailableVouchers();
    _expiredVouchers = VoucherMockData.getExpiredOrUsedVouchers();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _redeemVoucherCode() {
    final code = _codeController.text.trim().toUpperCase();
    if (code.isEmpty) {
      _showToast('Vui lòng nhập mã voucher', isError: true);
      return;
    }

    // Kiểm tra xem đã có trong danh sách ví chưa
    final exists = _availableVouchers.any((v) => v.code == code);
    if (exists) {
      _showToast('Mã voucher "$code" đã có sẵn trong ví của bạn!', isError: true);
      return;
    }

    // Giả lập lưu mã mới thành công
    final newVoucher = VoucherEntity(
      id: 'V_${DateTime.now().millisecondsSinceEpoch}',
      code: code,
      title: 'ƯU ĐÃI ĐỘC QUYỀN $code - GIẢM 10%',
      description: 'Mã khuyến mãi cá nhân được kích hoạt thành công.',
      discountType: VoucherDiscountType.percentage,
      discountValue: 10,
      maxDiscountAmount: 100000,
      minOrderAmount: 800000,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 14)),
      usageLimit: 50,
      usedCount: 0,
      isClaimed: true,
    );

    setState(() {
      _availableVouchers.insert(0, newVoucher);
      _codeController.clear();
      _selectedTabIndex = 0; // Chuyển về tab ví của tôi
    });

    _showToast('Áp dụng & lưu voucher "$code" thành công vào ví!');
  }

  void _openDiscoverVouchersScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DiscoverVouchersScreen(
          claimedCodes: _availableVouchers.map((v) => v.code).toList(),
          onVoucherClaimed: (newVoucher) {
            setState(() {
              if (!_availableVouchers.any((v) => v.code == newVoucher.code)) {
                _availableVouchers.insert(0, newVoucher);
              }
            });
          },
        ),
      ),
    );
  }

  void _showToast(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError ? AppColors.error : AppColors.success,
        content: Text(
          message,
          style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KHO VOUCHER'),
      ),
      body: CustomScrollView(
        slivers: [
          // Thanh 2 hành động nhanh: Nhập mã voucher & Mở màn hình Tìm thêm voucher
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.black,
              child: Row(
                children: [
                  // Nút mở trượt ô nhập mã voucher (ô vuông đồng bộ với bên Tìm thêm voucher)
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isInputExpanded ? const Color(0xFF2A2A2A) : AppColors.darkSurface,
                        foregroundColor: _isInputExpanded ? AppColors.neonVolt : AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                          side: BorderSide(
                            color: _isInputExpanded ? AppColors.neonVolt : Colors.white24,
                            width: 1.5,
                          ),
                        ),
                        minimumSize: const Size(100, 44),
                      ),
                      onPressed: () {
                        setState(() {
                          _isInputExpanded = !_isInputExpanded;
                        });
                      },
                      icon: Icon(
                        _isInputExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: _isInputExpanded ? AppColors.neonVolt : AppColors.white,
                        size: 20,
                      ),
                      label: Text(
                        'NHẬP MÃ VOUCHER',
                        style: GoogleFonts.oswald(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                          color: _isInputExpanded ? AppColors.neonVolt : AppColors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Nút điều hướng sang MÀN HÌNH RIÊNG "TÌM THÊM VOUCHER" (ô vuông)
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:AppColors.darkSurface,
                        foregroundColor:AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                          side: BorderSide(
                            color: Colors.white24,
                            width: 1.5,
                          ),
                        ),
                        minimumSize: const Size(100, 44),
                      ),
                      onPressed: _openDiscoverVouchersScreen,
                      icon: const Icon(
                        Icons.confirmation_number_outlined,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: Text(
                        'TÌM THÊM VOUCHER',
                        style: GoogleFonts.oswald(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Phần trượt từ trên xuống khi bấm "NHẬP MÃ VOUCHER"
          SliverToBoxAdapter(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _isInputExpanded
                  ? Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.zero,
                        border: Border.all(color: AppColors.neonVolt, width: 1.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.confirmation_number_outlined, color: AppColors.neonVolt, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'NHẬP MÃ ƯU ĐÃI ĐỂ LƯU VÀO VÍ',
                                style: GoogleFonts.oswald(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.neonVolt,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
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
                                      hintText: 'Nhập mã (VD: SPORT2026)',
                                      hintStyle: GoogleFonts.montserrat(color: AppColors.textGray, fontSize: 13),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                                      prefixIcon: const Icon(Icons.loyalty_outlined, color: AppColors.textGray, size: 20),
                                      filled: true,
                                      fillColor: Colors.black,
                                      border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                height: 48,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.neonVolt,
                                    foregroundColor: AppColors.black,
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero,
                                    ),
                                    minimumSize: const Size(80, 48),
                                  ),
                                  onPressed: _redeemVoucherCode,
                                  child: Text(
                                    'ÁP DỤNG',
                                    style: GoogleFonts.oswald(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),

          // Thanh chuyển 2 Tabs phong cách thể thao Adidas
          SliverToBoxAdapter(
            child: Container(
              color: Colors.black,
              child: Row(
                children: [
                  _buildTabItem(title: 'VOUCHER CỦA TÔI (${_availableVouchers.length})', index: 0),
                  _buildTabItem(title: 'ĐÃ DÙNG / HẾT HẠN (${_expiredVouchers.length})', index: 1),
                ],
              ),
            ),
          ),

          // Nội dung 2 tabs: Tab 0 (Ví của tôi) hoặc Tab 1 (Hết hạn)
          ...(_selectedTabIndex == 0 ? _availableVouchers : _expiredVouchers).isEmpty
              ? [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 48),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.confirmation_number_outlined, size: 64, color: AppColors.textGray),
                          const SizedBox(height: 12),
                          Text(
                            _selectedTabIndex == 0
                                ? 'Ví của bạn chưa có mã giảm giá nào'
                                : 'Không có mã giảm giá nào đã hết hạn',
                            style: GoogleFonts.montserrat(color: AppColors.textGray, fontSize: 14),
                          ),
                          if (_selectedTabIndex == 0) ...[
                            const SizedBox(height: 16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.neonVolt,
                                foregroundColor: Colors.black,
                                minimumSize: const Size(160, 42),
                              ),
                              onPressed: _openDiscoverVouchersScreen,
                              child: Text(
                                'TÌM THÊM VOUCHER',
                                style: GoogleFonts.oswald(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ]
              : [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final vouchers = _selectedTabIndex == 0 ? _availableVouchers : _expiredVouchers;
                          final voucher = vouchers[index];
                          return VoucherCardWidget(
                            voucher: voucher,
                            onUseNow: _selectedTabIndex == 0
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => const CartScreen()),
                                    );
                                  }
                                : null,
                          );
                        },
                        childCount: (_selectedTabIndex == 0 ? _availableVouchers : _expiredVouchers).length,
                      ),
                    ),
                  ),
                ],

          const SliverToBoxAdapter(
            child: SizedBox(height: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({required String title, required int index}) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AppColors.neonVolt : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: GoogleFonts.oswald(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: isSelected ? AppColors.neonVolt : AppColors.textGray,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
