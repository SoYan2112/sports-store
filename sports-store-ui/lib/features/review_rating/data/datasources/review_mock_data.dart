import 'package:sports_store_mobile/features/review_rating/domain/entities/review_entity.dart';

class ReviewMockData {
  static ReviewSummaryEntity getSummaryForProduct(String productId) {
    return const ReviewSummaryEntity(
      averageRating: 4.8,
      totalReviews: 128,
      ratingDistribution: {
        5: 104,
        4: 18,
        3: 4,
        2: 1,
        1: 1,
      },
    );
  }

  static List<ReviewEntity> getReviewsForProduct(String productId) {
    final now = DateTime.now();
    return [
      ReviewEntity(
        id: 'R1',
        productId: productId,
        userName: 'Trần Hoàng Nhật',
        userAvatar: null,
        rating: 5,
        comment:
            'Giày Ultraboost Light chạy cực kỳ êm và nảy, form ôm chân chuẩn thể thao. Đã test cự ly 10km sáng nay, đệm boost trả lực cực tốt. Đóng gói hộp Adidas nguyên seal rất cẩn thận!',
        createdAt: now.subtract(const Duration(days: 2)),
        sizePurchased: 'Size 42 - Trắng / Core Black',
        isVerifiedPurchase: true,
        fitEvaluation: 'Chuẩn size',
        helpfulCount: 24,
        images: [
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
          'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=400',
        ],
      ),
      ReviewEntity(
        id: 'R2',
        productId: productId,
        userName: 'Ngô Nhất Quý',
        userAvatar: null,
        rating: 5,
        comment:
            'Chất lượng hoàn thiện đỉnh cao của Adidas. Da lộn và upper vải dệt thoáng khí, đi mùa hè Hà Nội không bị hầm bí chân. Giao hàng hỏa tốc trong 24h rất ưng ý.',
        createdAt: now.subtract(const Duration(days: 5)),
        sizePurchased: 'Size 41 - Cloud White',
        isVerifiedPurchase: true,
        fitEvaluation: 'Chuẩn size',
        helpfulCount: 15,
        images: [
          'https://images.unsplash.com/photo-1520256862855-398228c41684?w=400',
        ],
      ),
      ReviewEntity(
        id: 'R3',
        productId: productId,
        userName: 'Nguyễn Hoài Ân',
        userAvatar: null,
        rating: 4,
        comment:
            'Form giày đẹp, phối đồ thể thao hay dạo phố đều chất. Ai chân bè nên tăng 0.5 size so với bình thường để chạy bộ đường dài thoải mái hơn nhé.',
        createdAt: now.subtract(const Duration(days: 10)),
        sizePurchased: 'Size 39 - Wonder Blue',
        isVerifiedPurchase: true,
        fitEvaluation: 'Hơi ôm/chật',
        helpfulCount: 8,
        images: [],
      ),
      ReviewEntity(
        id: 'R4',
        productId: productId,
        userName: 'Nguyễn Minh Nhật',
        userAvatar: null,
        rating: 5,
        comment:
            'Mua đợt áp mã voucher ADICLUB15 giảm được 150k quá hời. Đồ chính hãng có tem phân phối đầy đủ, quét mã QR ra thông tin chuẩn.',
        createdAt: now.subtract(const Duration(days: 15)),
        sizePurchased: 'Size 43 - Core Black',
        isVerifiedPurchase: true,
        fitEvaluation: 'Chuẩn size',
        helpfulCount: 6,
        images: [
          'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=400',
        ],
      ),
      ReviewEntity(
        id: 'R5',
        productId: productId,
        userName: 'Thái San Yo',
        userAvatar: null,
        rating: 3,
        comment:
            'Giày đẹp nhưng đế Continental bám bụi khá nhanh, cần vệ sinh thường xuyên. Nhân viên tư vấn chọn size nhiệt tình.',
        createdAt: now.subtract(const Duration(days: 22)),
        sizePurchased: 'Size 42 - Solar Red',
        isVerifiedPurchase: true,
        fitEvaluation: 'Chuẩn size',
        helpfulCount: 2,
        images: [],
      ),
    ];
  }

  /// Danh sách sản phẩm từ các đơn hàng đã nhận mà người dùng CHƯA ĐÁNH GIÁ
  static List<PendingReviewItem> getMyPendingReviews() {
    final now = DateTime.now();
    return [
      PendingReviewItem(
        orderId: 'ORD-8230',
        productId: 'PROD_01',
        productName: 'GIÀY ULTRABOOST LIGHT 23',
        productCategory: 'Giày Chạy Bộ Nam / Nữ',
        productImageUrl:
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
        size: '42',
        deliveredDate: now.subtract(const Duration(days: 2)),
        price: 3200000,
      ),
      PendingReviewItem(
        orderId: 'ORD-8104',
        productId: 'PROD_03',
        productName: 'GIÀY BÓNG ĐÁ PREDATOR ELITE FG',
        productCategory: 'Giày Đá Bóng Sân Cỏ Tự Nhiên',
        productImageUrl:
            'https://images.unsplash.com/photo-1511556532299-8f662fc26c06?w=400',
        size: '41',
        deliveredDate: now.subtract(const Duration(days: 5)),
        price: 4500000,
      ),
      PendingReviewItem(
        orderId: 'ORD-7952',
        productId: 'PROD_02',
        productName: 'GIÀY ADIDAS SAMBA CLASSIC OG',
        productCategory: 'Thời Trang Đường Phố Originals',
        productImageUrl:
            'https://images.unsplash.com/photo-1520256862855-398228c41684?w=400',
        size: '42',
        deliveredDate: now.subtract(const Duration(days: 9)),
        price: 2400000,
      ),
    ];
  }

  /// Danh sách đánh giá mà người dùng ĐÃ ĐÁNH GIÁ
  static List<ReviewEntity> getMySubmittedReviews() {
    final now = DateTime.now();
    return [
      ReviewEntity(
        id: 'MY_REV_01',
        productId: 'PROD_04',
        productName: 'GIÀY CHẠY BỘ ADIZERO ADIOS PRO 3',
        productImageUrl:
            'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=400',
        userName: 'Tôi (Trần Hoàng Nhật)',
        rating: 5,
        comment:
            'Đôi giày đua tuyệt nhất từng đi! Đệm Lightstrike Pro siêu nảy, thanh carbon EnergyRods hỗ trợ bước chạy mượt mà. Đã hoàn thành cự ly Half Marathon 21km với thành tích cá nhân mới.',
        createdAt: now.subtract(const Duration(days: 12)),
        sizePurchased: 'Size 42 - Solar Orange',
        isVerifiedPurchase: true,
        fitEvaluation: 'Chuẩn size',
        helpfulCount: 18,
        images: [
          'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=400',
        ],
      ),
      ReviewEntity(
        id: 'MY_REV_02',
        productId: 'PROD_05',
        productName: 'ÁO ĐẤU BÓNG ĐÁ ADIDAS TIRO 24',
        productImageUrl:
            'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=400',
        userName: 'Tôi (Trần Hoàng Nhật)',
        rating: 5,
        comment:
            'Vải Aeroready thấm hút mồ hôi cực nhanh, đá bóng trời nắng gắt không bị bết dính. Form áo thể thao vừa vặn, logo ba sọc in nhiệt sắc nét.',
        createdAt: now.subtract(const Duration(days: 25)),
        sizePurchased: 'Size L - Black / White',
        isVerifiedPurchase: true,
        fitEvaluation: 'Chuẩn size',
        helpfulCount: 9,
        images: [],
      ),
    ];
  }
}
