class ApiEndpoints {
  // Kết nối Backend SQL Server
  static const String baseUrl = 'https://api.sportsstore.vn/api/v1';
  
  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh-token';
  static const String forgotPassword = '/auth/forgot-password';

  // Products & Categories
  static const String categories = '/categories';
  static const String products = '/products';
  
  // Cart & Order
  static const String cart = '/cart';
  static const String orders = '/orders';
  
  // Profile & Address VN
  static const String userProfile = '/user/profile';
  static const String userAddresses = '/user/addresses';
  static const String vouchers = '/vouchers';
  
  // Admin
  static const String adminProducts = '/admin/products';
  static const String adminOrders = '/admin/orders';
}
