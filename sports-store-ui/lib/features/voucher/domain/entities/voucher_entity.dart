enum VoucherDiscountType {
  percentage,
  fixedAmount,
  freeShipping,
}

class VoucherEntity {
  final String id;
  final String code;
  final String title;
  final String description;
  final VoucherDiscountType discountType;
  final double discountValue; // % or VNĐ amount
  final double? maxDiscountAmount; // Tối đa VNĐ (nếu là %)
  final double minOrderAmount; // Đơn tối thiểu VNĐ
  final DateTime startDate;
  final DateTime endDate;
  final int usageLimit;
  final int usedCount;
  final bool isClaimed;
  final String? categoryName;

  const VoucherEntity({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.discountType,
    required this.discountValue,
    this.maxDiscountAmount,
    required this.minOrderAmount,
    required this.startDate,
    required this.endDate,
    this.usageLimit = 100,
    this.usedCount = 20,
    this.isClaimed = true,
    this.categoryName,
  });

  bool get isExpired => DateTime.now().isAfter(endDate);

  bool isValidForOrder(double orderTotal) {
    if (isExpired) return false;
    return orderTotal >= minOrderAmount;
  }

  String getValidityError(double orderTotal) {
    if (isExpired) return 'Mã giảm giá đã hết hạn sử dụng';
    if (orderTotal < minOrderAmount) {
      return 'Đơn hàng chưa đạt giá trị tối thiểu';
    }
    return '';
  }

  double calculateDiscount(double orderTotal) {
    if (!isValidForOrder(orderTotal)) return 0;

    switch (discountType) {
      case VoucherDiscountType.percentage:
        final rawDiscount = orderTotal * (discountValue / 100.0);
        if (maxDiscountAmount != null && rawDiscount > maxDiscountAmount!) {
          return maxDiscountAmount!;
        }
        return rawDiscount;
      case VoucherDiscountType.fixedAmount:
        return discountValue > orderTotal ? orderTotal : discountValue;
      case VoucherDiscountType.freeShipping:
        return discountValue; // Giá trị miễn phí vận chuyển (VD: 30.000 ₫)
    }
  }

  VoucherEntity copyWith({
    String? id,
    String? code,
    String? title,
    String? description,
    VoucherDiscountType? discountType,
    double? discountValue,
    double? maxDiscountAmount,
    double? minOrderAmount,
    DateTime? startDate,
    DateTime? endDate,
    int? usageLimit,
    int? usedCount,
    bool? isClaimed,
    String? categoryName,
  }) {
    return VoucherEntity(
      id: id ?? this.id,
      code: code ?? this.code,
      title: title ?? this.title,
      description: description ?? this.description,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      maxDiscountAmount: maxDiscountAmount ?? this.maxDiscountAmount,
      minOrderAmount: minOrderAmount ?? this.minOrderAmount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      usageLimit: usageLimit ?? this.usageLimit,
      usedCount: usedCount ?? this.usedCount,
      isClaimed: isClaimed ?? this.isClaimed,
      categoryName: categoryName ?? this.categoryName,
    );
  }
}
