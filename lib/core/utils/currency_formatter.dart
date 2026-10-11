import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _vndFormat = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '₫',
    decimalDigits: 0,
  );

  /// Format số tiền sang chuẩn Việt Nam (VD: 1.950.000 ₫)
  static String formatVnd(num amount) {
    return _vndFormat.format(amount).trim();
  }
}
