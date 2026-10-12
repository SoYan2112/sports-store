enum OrderStatus {
  all('Tất cả'),
  pending('Chờ xác nhận'),
  shipping('Đang giao'),
  delivered('Hoàn thành'),
  cancelled('Đã hủy');

  final String label;
  const OrderStatus(this.label);

  static OrderStatus fromString(String value) {
    return OrderStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => OrderStatus.pending,
    );
  }
}

