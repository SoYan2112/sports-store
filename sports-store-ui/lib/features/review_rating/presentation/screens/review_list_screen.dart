import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/datasources/review_mock_data.dart';
import '../../domain/entities/review_entity.dart';
import '../widgets/rating_stars_bar.dart';
import '../widgets/review_card_widget.dart';
import 'rating_form_screen.dart';

class ReviewListScreen extends StatefulWidget {
  final String productId;
  final String productName;
  final String productCategory;
  final String? productImageUrl;

  const ReviewListScreen({
    super.key,
    this.productId = 'P1',
    this.productName = 'ULTRABOOST LIGHT 23',
    this.productCategory = 'SPORTS RUNNING',
    this.productImageUrl =
        'https://assets.adidas.com/images/w_600,f_auto,q_auto/a225e6f3d82d4fb4bc00af6b0147fc5e_9366/Ultraboost_Light_Running_Shoes_White_HQ6351_01_standard.jpg',
  });

  @override
  State<ReviewListScreen> createState() => _ReviewListScreenState();
}

class _ReviewListScreenState extends State<ReviewListScreen> {
  late ReviewSummaryEntity _summary;
  late List<ReviewEntity> _allReviews;
  String _selectedFilter = 'ALL'; // 'ALL', '5', '4', '3', '2', '1', 'WITH_IMAGE'
  String _sortBy = 'NEWEST'; // 'NEWEST', 'HIGHEST', 'LOWEST', 'HELPFUL'

  @override
  void initState() {
    super.initState();
    _summary = ReviewMockData.getSummaryForProduct(widget.productId);
    _allReviews = ReviewMockData.getReviewsForProduct(widget.productId);
  }

  List<ReviewEntity> get _filteredReviews {
    List<ReviewEntity> list = List.from(_allReviews);

    // Lọc theo tag
    if (_selectedFilter == '5') {
      list = list.where((r) => r.rating == 5).toList();
    } else if (_selectedFilter == '4') {
      list = list.where((r) => r.rating == 4).toList();
    } else if (_selectedFilter == '3') {
      list = list.where((r) => r.rating == 3).toList();
    } else if (_selectedFilter == '2') {
      list = list.where((r) => r.rating == 2).toList();
    } else if (_selectedFilter == '1') {
      list = list.where((r) => r.rating == 1).toList();
    } else if (_selectedFilter == 'WITH_IMAGE') {
      list = list.where((r) => r.images.isNotEmpty).toList();
    }

    // Sắp xếp
    if (_sortBy == 'NEWEST') {
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else if (_sortBy == 'HIGHEST') {
      list.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (_sortBy == 'LOWEST') {
      list.sort((a, b) => a.rating.compareTo(b.rating));
    } else if (_sortBy == 'HELPFUL') {
      list.sort((a, b) => b.helpfulCount.compareTo(a.helpfulCount));
    }

    return list;
  }

  Future<void> _openRatingForm() async {
    final result = await Navigator.push<ReviewEntity>(
      context,
      MaterialPageRoute(
        builder: (_) => RatingFormScreen(
          productId: widget.productId,
          productName: widget.productName,
          productCategory: widget.productCategory,
          productImageUrl: widget.productImageUrl,
          selectedSize: '42',
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _allReviews.insert(0, result);
        // Cập nhật summary
        final newTotal = _summary.totalReviews + 1;
        final newDist = Map<int, int>.from(_summary.ratingDistribution);
        newDist[result.rating] = (newDist[result.rating] ?? 0) + 1;
        final totalScore = newDist.entries.fold<int>(0, (sum, e) => sum + (e.key * e.value));
        final newAvg = totalScore / newTotal;

        _summary = ReviewSummaryEntity(
          averageRating: double.parse(newAvg.toStringAsFixed(1)),
          totalReviews: newTotal,
          ratingDistribution: newDist,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayedReviews = _filteredReviews;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ĐÁNH GIÁ SẢN PHẨM'),
      ),
      body: Column(
        children: [
          // Thẻ tóm tắt sản phẩm
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.black,
            child: Row(
              children: [
                if (widget.productImageUrl != null)
                  Container(
                    width: 44,
                    height: 44,
                    color: AppColors.darkSurface,
                    child: Image.network(
                      widget.productImageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Icon(Icons.sports, color: AppColors.textGray),
                    ),
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.productName,
                        style: GoogleFonts.oswald(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                          letterSpacing: 0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.productCategory,
                        style: GoogleFonts.montserrat(
                          fontSize: 11,
                          color: AppColors.textGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: CustomScrollView(
              slivers: [
                // Khối Tổng quan điểm số và phân bố sao
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.darkSurface,
                      border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.15)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Cột điểm số to
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _summary.averageRating.toStringAsFixed(1),
                              style: GoogleFonts.oswald(
                                fontSize: 44,
                                fontWeight: FontWeight.w900,
                                color: AppColors.white,
                                height: 1,
                              ),
                            ),
                            const SizedBox(height: 6),
                            RatingStarsBar(
                              rating: _summary.averageRating.round(),
                              starSize: 16,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${_summary.totalReviews} đánh giá',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                color: AppColors.textGray,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 24),

                        // Thanh phân bố mức độ sao (5 -> 1 sao)
                        Expanded(
                          child: Column(
                            children: List.generate(5, (index) {
                              final star = 5 - index;
                              final count = _summary.ratingDistribution[star] ?? 0;
                              final percentage = _summary.getPercentage(star);

                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  children: [
                                    Text(
                                      '$star',
                                      style: GoogleFonts.oswald(
                                        fontSize: 12,
                                        color: AppColors.textGray,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.star, size: 12, color: AppColors.textGray),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.zero,
                                        child: LinearProgressIndicator(
                                          value: percentage,
                                          backgroundColor: Colors.black,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            star >= 4 ? AppColors.neonVolt : AppColors.neonOrange,
                                          ),
                                          minHeight: 6,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      width: 24,
                                      child: Text(
                                        '$count',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 11,
                                          color: AppColors.textGray,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bộ lọc Chips và Sắp xếp
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Filter Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            _buildFilterChip('Tất cả (${_allReviews.length})', 'ALL'),
                            _buildFilterChip('5 sao (${_countRating(5)})', '5'),
                            _buildFilterChip('4 sao (${_countRating(4)})', '4'),
                            _buildFilterChip('3 sao (${_countRating(3)})', '3'),
                            _buildFilterChip('Có ảnh (${_countWithImages()})', 'WITH_IMAGE'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Sắp xếp
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'HIỂN THỊ ${displayedReviews.length} ĐÁNH GIÁ',
                              style: GoogleFonts.oswald(
                                fontSize: 13,
                                color: AppColors.textGray,
                                letterSpacing: 0.5,
                              ),
                            ),
                            DropdownButton<String>(
                              value: _sortBy,
                              dropdownColor: AppColors.darkSurface,
                              underline: const SizedBox(),
                              icon: const Icon(Icons.sort, color: AppColors.white, size: 18),
                              style: GoogleFonts.oswald(
                                fontSize: 13,
                                color: AppColors.white,
                                letterSpacing: 0.5,
                              ),
                              items: const [
                                DropdownMenuItem(value: 'NEWEST', child: Text('MỚI NHẤT')),
                                DropdownMenuItem(value: 'HIGHEST', child: Text('ĐÁNH GIÁ CAO')),
                                DropdownMenuItem(value: 'LOWEST', child: Text('ĐÁNH GIÁ THẤP')),
                                DropdownMenuItem(value: 'HELPFUL', child: Text('HỮU ÍCH NHẤT')),
                              ],
                              onChanged: (val) {
                                if (val != null) setState(() => _sortBy = val);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),

                // Danh sách reviews
                if (displayedReviews.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Center(
                        child: Column(
                          children: [
                            const Icon(Icons.rate_review_outlined, size: 48, color: AppColors.textGray),
                            const SizedBox(height: 12),
                            Text(
                              'Chưa có đánh giá nào phù hợp với bộ lọc',
                              style: GoogleFonts.montserrat(color: AppColors.textGray),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => ReviewCardWidget(review: displayedReviews[index]),
                        childCount: displayedReviews.length,
                      ),
                    ),
                  ),

                // Khoảng đệm dưới cùng cho nút Bottom
                const SliverToBoxAdapter(
                  child: SizedBox(height: 80),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.black,
          border: Border(top: BorderSide(color: AppColors.borderGray, width: 0.2)),
        ),
        child: SafeArea(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.black,
            ),
            icon: const Icon(Icons.rate_review, size: 20),
            label: const Text('VIẾT ĐÁNH GIÁ SẢN PHẨM'),
            onPressed: _openRatingForm,
          ),
        ),
      ),
    );
  }

  int _countRating(int star) {
    return _allReviews.where((r) => r.rating == star).length;
  }

  int _countWithImages() {
    return _allReviews.where((r) => r.images.isNotEmpty).length;
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: AppColors.white,
        backgroundColor: AppColors.darkSurface,
        labelStyle: GoogleFonts.oswald(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.black : AppColors.textGray,
          letterSpacing: 0.5,
        ),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        side: BorderSide(
          color: isSelected ? AppColors.white : AppColors.borderGray.withValues(alpha: 0.2),
        ),
        onSelected: (_) {
          setState(() => _selectedFilter = value);
        },
      ),
    );
  }
}
