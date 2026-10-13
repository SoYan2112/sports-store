class ReviewEntity {
  final String id;
  final String productId;
  final String userName;
  final String? userAvatar;
  final int rating; // 1 to 5
  final String comment;
  final DateTime createdAt;
  final String sizePurchased;
  final bool isVerifiedPurchase;
  final List<String> images;
  final int helpfulCount;
  final String fitEvaluation; // "Chuẩn size", "Hơi rộng", "Hơi ôm/chật"
  final bool isLikedByMe;

  final String? productName;
  final String? productImageUrl;

  const ReviewEntity({
    required this.id,
    required this.productId,
    required this.userName,
    this.userAvatar,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.sizePurchased,
    this.isVerifiedPurchase = true,
    this.images = const [],
    this.helpfulCount = 0,
    this.fitEvaluation = 'Chuẩn size',
    this.isLikedByMe = false,
    this.productName,
    this.productImageUrl,
  });

  ReviewEntity copyWith({
    String? id,
    String? productId,
    String? userName,
    String? userAvatar,
    int? rating,
    String? comment,
    DateTime? createdAt,
    String? sizePurchased,
    bool? isVerifiedPurchase,
    List<String>? images,
    int? helpfulCount,
    String? fitEvaluation,
    bool? isLikedByMe,
    String? productName,
    String? productImageUrl,
  }) {
    return ReviewEntity(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      sizePurchased: sizePurchased ?? this.sizePurchased,
      isVerifiedPurchase: isVerifiedPurchase ?? this.isVerifiedPurchase,
      images: images ?? this.images,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      fitEvaluation: fitEvaluation ?? this.fitEvaluation,
      isLikedByMe: isLikedByMe ?? this.isLikedByMe,
      productName: productName ?? this.productName,
      productImageUrl: productImageUrl ?? this.productImageUrl,
    );
  }
}

class PendingReviewItem {
  final String orderId;
  final String productId;
  final String productName;
  final String productCategory;
  final String productImageUrl;
  final String size;
  final DateTime deliveredDate;
  final double price;

  const PendingReviewItem({
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.productCategory,
    required this.productImageUrl,
    required this.size,
    required this.deliveredDate,
    required this.price,
  });
}

class ReviewSummaryEntity {
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingDistribution; // 5 -> 98, 4 -> 20, etc.

  const ReviewSummaryEntity({
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
  });

  double getPercentage(int star) {
    if (totalReviews == 0) return 0;
    final count = ratingDistribution[star] ?? 0;
    return count / totalReviews;
  }
}
