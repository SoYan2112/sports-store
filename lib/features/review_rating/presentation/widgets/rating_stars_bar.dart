import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class RatingStarsBar extends StatelessWidget {
  final int rating;
  final double starSize;
  final ValueChanged<int>? onRatingChanged;
  final Color activeColor;
  final Color inactiveColor;

  const RatingStarsBar({
    super.key,
    required this.rating,
    this.starSize = 18,
    this.onRatingChanged,
    this.activeColor = AppColors.neonVolt,
    this.inactiveColor = AppColors.textGray,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        final isFilled = starIndex <= rating;

        return GestureDetector(
          onTap: onRatingChanged != null ? () => onRatingChanged!(starIndex) : null,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: onRatingChanged != null ? 6 : 1),
            child: Icon(
              isFilled ? Icons.star : Icons.star_border,
              size: starSize,
              color: isFilled ? activeColor : inactiveColor.withValues(alpha: 0.4),
            ),
          ),
        );
      }),
    );
  }
}
