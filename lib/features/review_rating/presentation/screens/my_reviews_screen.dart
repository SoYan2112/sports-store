import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../data/datasources/review_mock_data.dart';
import '../../domain/entities/review_entity.dart';
import '../widgets/rating_stars_bar.dart';
import 'rating_form_screen.dart';

class MyReviewsScreen extends StatefulWidget {
  const MyReviewsScreen({super.key});

  @override
  State<MyReviewsScreen> createState() => _MyReviewsScreenState();
}

class _MyReviewsScreenState extends State<MyReviewsScreen> {
  int _selectedTabIndex = 0; // 0: Chưa đánh giá, 1: Đã đánh giá

  late List<PendingReviewItem> _pendingReviews;
  late List<ReviewEntity> _submittedReviews;

  @override
  void initState() {
    super.initState();
    _pendingReviews = ReviewMockData.getMyPendingReviews();
    _submittedReviews = ReviewMockData.getMySubmittedReviews();
  }

  void _onReviewSubmitted(PendingReviewItem pendingItem, ReviewEntity newReview) {
    setState(() {
      _pendingReviews.removeWhere((item) =>
          item.orderId == pendingItem.orderId &&
          item.productId == pendingItem.productId);
      _submittedReviews.insert(0, newReview);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.neonVolt,
        content: Text(
          'Cảm ơn bạn! Đã ghi nhận đánh giá cho "${pendingItem.productName}"',
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalReviewsCount = _submittedReviews.length;

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        title: Text(
          'ĐÁNH GIÁ CỦA TÔI',
          style: GoogleFonts.oswald(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          // Thẻ Thông tin cá nhân & Thống kê tổng số đánh giá
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: AppColors.darkSurface,
              border: Border(
                bottom: BorderSide(color: Color(0xFF222222), width: 1),
              ),
            ),
            child: Row(
              children: [
                // Bên trái: Avatar & Tên tài khoản
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.neonVolt, width: 2),
                    color: Colors.black,
                  ),
                  child: const Center(
                    child: Text(
                      'N',
                      style: TextStyle(
                        color: AppColors.neonVolt,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trần Hoàng Nhật',
                        style: GoogleFonts.oswald(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            color: AppColors.neonVolt,
                            child: Text(
                              'ADICLUB VIP',
                              style: GoogleFonts.oswald(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Thành viên tích cực',
                            style: GoogleFonts.montserrat(
                              fontSize: 11,
                              color: AppColors.textGray,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Bên phải: Khối thống kê tổng đánh giá (Số ở trên, Chữ ở dưới)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(
                      color: AppColors.borderGray.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$totalReviewsCount',
                        style: GoogleFonts.oswald(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.neonVolt,
                          height: 1.1,
                        ),
                      ),
                      Text(
                        'Đánh giá',
                        style: GoogleFonts.montserrat(
                          fontSize: 11,
                          color: AppColors.textGray,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2 Tabs trạng thái thể thao (Chưa đánh giá / Đã đánh giá)
          Container(
            color: Colors.black,
            child: Row(
              children: [
                _buildTabItem(
                  title: 'CHƯA ĐÁNH GIÁ (${_pendingReviews.length})',
                  index: 0,
                ),
                _buildTabItem(
                  title: 'ĐÃ ĐÁNH GIÁ (${_submittedReviews.length})',
                  index: 1,
                ),
              ],
            ),
          ),

          // Nội dung tương ứng 2 Tab
          Expanded(
            child: _selectedTabIndex == 0
                ? _buildPendingReviewsList()
                : _buildSubmittedReviewsList(),
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
              letterSpacing: 1,
              color: isSelected ? AppColors.neonVolt : AppColors.textGray,
            ),
          ),
        ),
      ),
    );
  }

  /// Danh sách sản phẩm mua mà CHƯA ĐÁNH GIÁ
  Widget _buildPendingReviewsList() {
    final dateFormat = DateFormat('dd/MM/yyyy');

    if (_pendingReviews.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline,
                size: 64, color: AppColors.neonVolt),
            const SizedBox(height: 12),
            Text(
              'BẠN ĐÃ ĐÁNH GIÁ HẾT CÁC ĐƠN HÀNG!',
              style: GoogleFonts.oswald(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Không có sản phẩm nào đang chờ đánh giá.',
              style: GoogleFonts.montserrat(
                  color: AppColors.textGray, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _pendingReviews.length,
      itemBuilder: (context, index) {
        final item = _pendingReviews[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: AppColors.darkSurface,
            border:
                Border.all(color: AppColors.borderGray.withValues(alpha: 0.15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header thẻ: Mã đơn & Ngày nhận
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ĐƠN HÀNG #${item.orderId}',
                      style: GoogleFonts.oswald(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: AppColors.textGray,
                      ),
                    ),
                    Text(
                      'Đã nhận: ${dateFormat.format(item.deliveredDate)}',
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        color: AppColors.neonVolt,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFF222222)),

              // Chi tiết sản phẩm & Nút Đánh giá
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ảnh thumbnail sản phẩm
                    Container(
                      width: 76,
                      height: 76,
                      color: Colors.black,
                      child: CachedNetworkImage(
                        imageUrl: item.productImageUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, _) => const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
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

                    // Thông tin & Nút hành động
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName,
                            style: GoogleFonts.oswald(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Phân loại: Size ${item.size}',
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
                              fontWeight: FontWeight.bold,
                              color: AppColors.neonOrange,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Nút bấm Đánh giá
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.neonVolt,
                                foregroundColor: Colors.black,
                                minimumSize: const Size(120, 34),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 6),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                              icon: const Icon(Icons.star, size: 15),
                              label: Text(
                                'ĐÁNH GIÁ',
                                style: GoogleFonts.oswald(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              onPressed: () async {
                                final result = await Navigator.push<ReviewEntity>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => RatingFormScreen(
                                      productId: item.productId,
                                      productName: item.productName,
                                      productCategory: item.productCategory,
                                      productImageUrl: item.productImageUrl,
                                    ),
                                  ),
                                );

                                if (result != null) {
                                  _onReviewSubmitted(item, result);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Danh sách các đánh giá mà người dùng ĐÃ ĐÁNH GIÁ
  Widget _buildSubmittedReviewsList() {
    final dateFormat = DateFormat('dd/MM/yyyy');

    if (_submittedReviews.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.rate_review_outlined,
                size: 64, color: AppColors.textGray),
            const SizedBox(height: 12),
            Text(
              'BẠN CHƯA CÓ ĐÁNH GIÁ NÀO',
              style: GoogleFonts.oswald(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Hãy đánh giá các sản phẩm đã mua để nhận điểm Adiclub!',
              style: GoogleFonts.montserrat(
                  color: AppColors.textGray, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _submittedReviews.length,
      itemBuilder: (context, index) {
        final review = _submittedReviews[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: AppColors.darkSurface,
            border:
                Border.all(color: AppColors.borderGray.withValues(alpha: 0.15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thông tin sản phẩm đã đánh giá
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    if (review.productImageUrl != null)
                      Container(
                        width: 50,
                        height: 50,
                        color: Colors.black,
                        child: CachedNetworkImage(
                          imageUrl: review.productImageUrl!,
                          fit: BoxFit.cover,
                          errorWidget: (_, _, _) => const Icon(
                            Icons.sports,
                            color: AppColors.textGray,
                          ),
                        ),
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review.productName ?? 'SẢN PHẨM ADIDAS CHÍNH HÃNG',
                            style: GoogleFonts.oswald(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            review.sizePurchased,
                            style: GoogleFonts.montserrat(
                              fontSize: 11,
                              color: AppColors.textGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      color: const Color(0xFF1B5E20),
                      child: Text(
                        'ĐÃ ĐÁNH GIÁ',
                        style: GoogleFonts.oswald(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFF222222)),

              // Chi tiết đánh giá đã viết
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hàng sao & Ngày đánh giá
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RatingStarsBar(
                          rating: review.rating,
                          starSize: 16,
                        ),
                        Text(
                          dateFormat.format(review.createdAt),
                          style: GoogleFonts.montserrat(
                            fontSize: 11,
                            color: AppColors.textGray,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Nhãn độ vừa vặn
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(
                            color: AppColors.borderGray.withValues(alpha: 0.2)),
                      ),
                      child: Text(
                        'Độ vừa vặn: ${review.fitEvaluation}',
                        style: GoogleFonts.montserrat(
                          fontSize: 11,
                          color: AppColors.neonVolt,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Nhận xét
                    Text(
                      review.comment,
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),

                    // Ảnh đính kèm (nếu có)
                    if (review.images.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        children: review.images.map((imgUrl) {
                          return Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white24),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: imgUrl,
                              fit: BoxFit.cover,
                              errorWidget: (_, _, _) => const Icon(
                                Icons.broken_image,
                                color: AppColors.textGray,
                                size: 20,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
