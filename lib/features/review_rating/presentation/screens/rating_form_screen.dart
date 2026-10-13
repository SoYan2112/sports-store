import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/review_entity.dart';
import '../widgets/rating_stars_bar.dart';

class RatingFormScreen extends StatefulWidget {
  final String productId;
  final String productName;
  final String productCategory;
  final String selectedSize;
  final String? productImageUrl;

  const RatingFormScreen({
    super.key,
    required this.productId,
    required this.productName,
    this.productCategory = 'SPORTS RUNNING',
    this.selectedSize = '42',
    this.productImageUrl,
  });

  @override
  State<RatingFormScreen> createState() => _RatingFormScreenState();
}

class _RatingFormScreenState extends State<RatingFormScreen> {
  int _rating = 5;
  String _fitEvaluation = 'Chuẩn size';
  final TextEditingController _commentController = TextEditingController();
  final Set<String> _selectedTags = {};
  final List<String> _attachedImages = [
    'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
  ];
  bool _isSubmitting = false;

  static const List<String> _fitOptions = [
    'Hơi nhỏ/chật',
    'Chuẩn size',
    'Hơi rộng',
  ];

  static const List<String> _quickTags = [
    'Đế siêu êm ái',
    'Chất liệu cao cấp',
    'Form ôm chân',
    'Thoáng khí',
    'Độ bám sân tốt',
    'Giao hàng nhanh',
    'Đóng gói cẩn thận',
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  String _getRatingFeedback(int rating) {
    switch (rating) {
      case 1:
        return 'Rất thất vọng';
      case 2:
        return 'Chưa hài lòng';
      case 3:
        return 'Bình thường';
      case 4:
        return 'Hài lòng';
      case 5:
        return 'Tuyệt vời, chuẩn thể thao Adidas!';
      default:
        return '';
    }
  }

  void _addSampleImage() {
    if (_attachedImages.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.darkSurface,
          content: Text('Tối đa 5 hình ảnh cho mỗi đánh giá'),
        ),
      );
      return;
    }

    setState(() {
      _attachedImages.add(
        'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=400',
      );
    });
  }

  void _removeImage(int index) {
    setState(() {
      _attachedImages.removeAt(index);
    });
  }

  Future<void> _submitReview() async {
    final comment = _commentController.text.trim();
    if (_rating < 1) {
      _showError('Vui lòng chọn số sao đánh giá');
      return;
    }

    if (comment.isEmpty) {
      _showError('Vui lòng chia sẻ cảm nhận của bạn về sản phẩm');
      return;
    }

    setState(() => _isSubmitting = true);

    // Giả lập gửi đánh giá lên API Backend
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    final newReview = ReviewEntity(
      id: 'R_${DateTime.now().millisecondsSinceEpoch}',
      productId: widget.productId,
      userName: 'Bạn (Người mua)',
      rating: _rating,
      comment: _selectedTags.isNotEmpty
          ? '${_selectedTags.map((t) => '#$t').join(' ')}\n$comment'
          : comment,
      createdAt: DateTime.now(),
      sizePurchased: 'Size ${widget.selectedSize} - Chính hãng',
      isVerifiedPurchase: true,
      fitEvaluation: _fitEvaluation,
      images: List.from(_attachedImages),
      helpfulCount: 0,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppColors.success,
        content: Text('Gửi đánh giá thành công! Cảm ơn bạn đã đóng góp.'),
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.pop(context, newReview);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.error,
        content: Text(
          message,
          style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VIẾT ĐÁNH GIÁ SẢN PHẨM'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thẻ tóm tắt sản phẩm
            Container(
              padding: const EdgeInsets.all(14),
              color: AppColors.darkSurface,
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    color: Colors.black,
                    child: widget.productImageUrl != null
                        ? Image.network(
                            widget.productImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const Icon(
                              Icons.sports_basketball,
                              color: AppColors.textGray,
                            ),
                          )
                        : const Icon(Icons.sports, color: AppColors.textGray),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.productCategory,
                          style: GoogleFonts.oswald(
                            fontSize: 11,
                            color: AppColors.textGray,
                            letterSpacing: 1,
                          ),
                        ),
                        Text(
                          widget.productName,
                          style: GoogleFonts.oswald(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Kích cỡ đã mua: Size ${widget.selectedSize}',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: AppColors.neonVolt,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Phần 1: Chấm điểm sao
            Text(
              '1. BẠN ĐÁNH GIÁ SẢN PHẨM NÀY MẤY SAO?',
              style: GoogleFonts.oswald(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Column(
                children: [
                  RatingStarsBar(
                    rating: _rating,
                    starSize: 38,
                    onRatingChanged: (newRating) {
                      setState(() => _rating = newRating);
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getRatingFeedback(_rating),
                    style: GoogleFonts.oswald(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neonVolt,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Phần 2: Đánh giá độ vừa vặn (Fit rating)
            Text(
              '2. ĐỘ VỪA VẶN CỦA GIÀY/ÁO SO VỚI BẠN?',
              style: GoogleFonts.oswald(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: _fitOptions.map((fit) {
                final isSelected = _fitEvaluation == fit;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: isSelected ? AppColors.white : Colors.transparent,
                        foregroundColor: isSelected ? Colors.black : AppColors.white,
                        side: BorderSide(
                          color: isSelected ? AppColors.white : AppColors.textGray.withValues(alpha: 0.3),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        setState(() => _fitEvaluation = fit);
                      },
                      child: Text(
                        fit,
                        style: GoogleFonts.oswald(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Phần 3: Gắn thẻ nhận xét nhanh
            Text(
              '3. ĐẶC ĐIỂM NỔI BẬT (CHỌN NHANH)',
              style: GoogleFonts.oswald(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _quickTags.map((tag) {
                final isSelected = _selectedTags.contains(tag);
                return FilterChip(
                  label: Text(tag),
                  selected: isSelected,
                  selectedColor: AppColors.neonVolt,
                  backgroundColor: AppColors.darkSurface,
                  labelStyle: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.black : AppColors.white,
                  ),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  side: BorderSide(
                    color: isSelected ? AppColors.neonVolt : AppColors.borderGray.withValues(alpha: 0.2),
                  ),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedTags.add(tag);
                      } else {
                        _selectedTags.remove(tag);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Phần 4: Nhận xét chi tiết
            Text(
              '4. CHIA SẺ TRẢI NGHIỆM CHI TIẾT',
              style: GoogleFonts.oswald(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _commentController,
              maxLines: 5,
              maxLength: 500,
              style: GoogleFonts.montserrat(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText:
                    'Chất lượng sản phẩm thế nào? Cảm giác đi êm không? Bạn có gợi ý gì cho người mua sau không?',
                hintStyle: GoogleFonts.montserrat(color: AppColors.textGray, fontSize: 13),
              ),
            ),
            const SizedBox(height: 16),

            // Phần 5: Thêm ảnh thực tế
            Text(
              '5. HÌNH ẢNH THỰC TẾ (${_attachedImages.length}/5)',
              style: GoogleFonts.oswald(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 76,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  // Nút bấm thêm ảnh
                  GestureDetector(
                    onTap: _addSampleImage,
                    child: Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        color: AppColors.darkSurface,
                        border: Border.all(
                          color: AppColors.textGray.withValues(alpha: 0.4),
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add_a_photo_outlined, color: AppColors.white, size: 22),
                          const SizedBox(height: 4),
                          Text(
                            'THÊM ẢNH',
                            style: GoogleFonts.oswald(fontSize: 10, color: AppColors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Danh sách ảnh đã chọn
                  ...List.generate(_attachedImages.length, (index) {
                    final img = _attachedImages[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            width: 76,
                            height: 76,
                            color: Colors.black,
                            child: Image.network(
                              img,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => const Icon(
                                Icons.sports_score,
                                color: AppColors.textGray,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              color: Colors.black.withValues(alpha: 0.7),
                              child: const Icon(Icons.close, color: Colors.white, size: 16),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Nút bấm gửi đánh giá
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitReview,
              child: _isSubmitting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                    )
                  : const Text('GỬI ĐÁNH GIÁ & NHẬN ĐIỂM THƯỞNG'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
