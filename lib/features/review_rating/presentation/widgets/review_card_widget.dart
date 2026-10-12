import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/review_entity.dart';
import 'rating_stars_bar.dart';

class ReviewCardWidget extends StatefulWidget {
  final ReviewEntity review;

  const ReviewCardWidget({super.key, required this.review});

  @override
  State<ReviewCardWidget> createState() => _ReviewCardWidgetState();
}

class _ReviewCardWidgetState extends State<ReviewCardWidget> {
  late bool _isLiked;
  late int _helpfulCount;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.review.isLikedByMe;
    _helpfulCount = widget.review.helpfulCount;
  }

  void _toggleHelpful() {
    setState(() {
      _isLiked = !_isLiked;
      _helpfulCount += _isLiked ? 1 : -1;
    });
  }

  void _showImagePreview(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            InteractiveViewer(
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => const Center(
                  child: Icon(Icons.broken_image, color: AppColors.textGray, size: 64),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final review = widget.review;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Người đánh giá & Verified badge
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.black,
                child: Text(
                  review.userName.isNotEmpty ? review.userName[0].toUpperCase() : 'U',
                  style: GoogleFonts.oswald(
                    color: AppColors.neonVolt,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: GoogleFonts.oswald(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    if (review.isVerifiedPurchase)
                      Row(
                        children: [
                          const Icon(Icons.verified, color: AppColors.neonVolt, size: 13),
                          const SizedBox(width: 4),
                          Text(
                            'Đã mua hàng chính hãng',
                            style: GoogleFonts.montserrat(
                              fontSize: 11,
                              color: AppColors.neonVolt,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
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
          const SizedBox(height: 10),

          // Sao đánh giá & Độ vừa vặn
          Row(
            children: [
              RatingStarsBar(rating: review.rating, starSize: 15),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                color: Colors.black,
                child: Text(
                  'Form: ${review.fitEvaluation}',
                  style: GoogleFonts.montserrat(
                    fontSize: 11,
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Phân loại size đã mua
          Text(
            review.sizePurchased,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              color: AppColors.textGray,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 10),

          // Nội dung nhận xét
          Text(
            review.comment,
            style: GoogleFonts.montserrat(
              fontSize: 13.5,
              color: AppColors.white,
              height: 1.4,
            ),
          ),

          // Hình ảnh đính kèm (nếu có)
          if (review.images.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 72,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: review.images.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final imgUrl = review.images[index];
                  return GestureDetector(
                    onTap: () => _showImagePreview(context, imgUrl),
                    child: ClipRRect(
                      borderRadius: BorderRadius.zero,
                      child: Container(
                        width: 72,
                        height: 72,
                        color: Colors.black,
                        child: Image.network(
                          imgUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const Icon(
                            Icons.sports_basketball,
                            color: AppColors.textGray,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],

          const SizedBox(height: 12),
          const Divider(color: AppColors.borderGray, height: 1, thickness: 0.1),
          const SizedBox(height: 8),

          // Nút Đánh giá này hữu ích
          Row(
            children: [
              Text(
                'Nhận xét này có hữu ích không?',
                style: GoogleFonts.montserrat(
                  fontSize: 11.5,
                  color: AppColors.textGray,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: _toggleHelpful,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        _isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                        size: 15,
                        color: _isLiked ? AppColors.neonVolt : AppColors.textGray,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Hữu ích ($_helpfulCount)',
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          color: _isLiked ? AppColors.neonVolt : AppColors.textGray,
                          fontWeight: _isLiked ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
