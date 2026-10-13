# Đặc Tả API & Chiến Lược Kiểm Thử (API & Testing Specification)
## Dự án: sports-store-mobile

---
 
### 1. Cơ Sở Dữ Liệu Hệ Thống: Microsoft SQL Server (MSSQL)
- **Hệ quản trị CSDL**: Microsoft SQL Server.
- **Mô hình kết nối**: Ứng dụng Flutter Mobile kết nối tới Backend API (ví dụ: ASP.NET Core / Node.js / Spring Boot) qua giao thức HTTP/HTTPS RESTful (thư viện `Dio`), Backend chịu trách nhiệm truy vấn và thao tác trên cơ sở dữ liệu SQL Server.
- **Các bảng dữ liệu chính (Core Tables trong SQL Server)**:
  - `Users` (UserId [PK, uniqueidentifier/int], FullName, Email, PhoneNumber, PasswordHash, Role, CreatedAt)
  - `Addresses` (AddressId [PK], UserId [FK], RecipientName, Phone, ProvinceId, DistrictId, WardId, StreetDetails, IsDefault)
  - `Categories` (CategoryId [PK], Name, ImageUrl, IsActive)
  - `Products` (ProductId [PK], CategoryId [FK], Name, Description, Price [decimal(18,2)], StockQuantity, CreatedAt)
  - `ProductVariants` (VariantId [PK], ProductId [FK], Size, Sku, Stock)
  - `ProductImages` (ImageId [PK], ProductId [FK], ImageUrl, IsPrimary)
  - `Orders` (OrderId [PK], UserId [FK], AddressId [FK], TotalAmount [decimal(18,2)], PaymentMethod, OrderStatus, VoucherCode, CreatedAt)
  - `OrderItems` (OrderItemId [PK], OrderId [FK], ProductId [FK], Size, Quantity, UnitPrice [decimal(18,2)])
  - `Vouchers` (VoucherId [PK], Code, DiscountPercent, MaxDiscountAmount, MinOrderAmount, ExpireDate, IsActive)
  - `Reviews` (ReviewId [PK], ProductId [FK], UserId [FK], Rating [int], Comment [nvarchar(max)], CreatedAt)

---

### 2. Chuẩn Hóa API RESTful

- **Base URL**: `https://api.sportsstore.vn/api/v1`
- **Authentication**: Bearer Token trong Header:
  ```http
  Authorization: Bearer <access_token>
  ```
- **Định dạng phản hồi chuẩn (Standard JSON Response)**:
  ```json
  {
    "success": true,
    "statusCode": 200,
    "message": "Thành công",
    "data": { ... },
    "error": null
  }
  ```

---

### 2. Danh Sách Endpoint Chi Tiết Theo Tính Năng

#### 2.1. Xác thực & Tài khoản (Authentication)
| Method | Endpoint | Mô tả | Payload / Query |
| :--- | :--- | :--- | :--- |
| `POST` | `/auth/login` | Đăng nhập hệ thống | `{"emailOrPhone": "", "password": ""}` |
| `POST` | `/auth/register` | Đăng ký tài khoản | `{"fullName": "", "email": "", "phone": "", "password": ""}` |
| `POST` | `/auth/refresh-token` | Làm mới JWT token | `{"refreshToken": ""}` |
| `POST` | `/auth/forgot-password` | Yêu cầu khôi phục mật khẩu | `{"email": ""}` |

#### 2.2. Sản phẩm & Danh mục (Products & Categories)
| Method | Endpoint | Mô tả | Payload / Query |
| :--- | :--- | :--- | :--- |
| `GET` | `/categories` | Danh sách danh mục thể thao | N/A |
| `GET` | `/products` | Danh sách sản phẩm kèm lọc & phân trang | Query: `?page=1&limit=10&categoryId=...&minPrice=...&maxPrice=...&search=...&sort=price_asc` |
| `GET` | `/products/{id}` | Chi tiết sản phẩm & biến thể size | N/A |
| `POST` | `/admin/products` *(Admin)* | Tạo mới sản phẩm | FormData: `name`, `price`, `description`, `categoryId`, `sizes`, `images[]` |
| `PUT` | `/admin/products/{id}` *(Admin)* | Cập nhật sản phẩm | FormData tương tự |
| `DELETE` | `/admin/products/{id}` *(Admin)* | Xóa sản phẩm | N/A |
| `POST` | `/admin/categories` *(Admin)* | Thêm danh mục mới | `{"name": "", "imageUrl": ""}` |
| `PUT` | `/admin/categories/{id}` *(Admin)* | Cập nhật danh mục | `{"name": "", "imageUrl": ""}` |
| `DELETE` | `/admin/categories/{id}` *(Admin)* | Xóa danh mục | N/A |

#### 2.3. Giỏ hàng & Thanh toán Đơn hàng (Cart & Order)
| Method | Endpoint | Mô tả | Payload / Query |
| :--- | :--- | :--- | :--- |
| `GET` | `/cart` | Lấy giỏ hàng người dùng | N/A |
| `POST` | `/cart/items` | Thêm vào giỏ hàng | `{"productId": "...", "size": "42", "quantity": 1}` |
| `PUT` | `/cart/items/{id}` | Cập nhật số lượng | `{"quantity": 2}` |
| `DELETE` | `/cart/items/{id}` | Xóa sản phẩm khỏi giỏ | N/A |
| `POST` | `/orders` | Đặt hàng mới | `{"shippingAddressId": "...", "paymentMethod": "COD" | "VNPAY", "voucherCode": "SPORTS20", "note": ""}` |
| `GET` | `/orders` | Lịch sử đơn hàng của user | Query: `?status=ALL|PENDING|SHIPPING|DELIVERED` |
| `GET` | `/orders/{id}` | Chi tiết đơn hàng | N/A |
| `GET` | `/admin/orders` *(Admin)* | Danh sách toàn bộ đơn hàng | Query: `?status=...&date=...` |
| `PATCH` | `/admin/orders/{id}/status` *(Admin)* | Cập nhật trạng thái duyệt đơn | `{"status": "CONFIRMED" | "SHIPPING" | "COMPLETED" | "CANCELLED"}` |

#### 2.4. Hồ sơ, Địa chỉ Việt Nam, Voucher & Đánh giá
| Method | Endpoint | Mô tả | Payload / Query |
| :--- | :--- | :--- | :--- |
| `GET` | `/user/profile` | Thông tin người dùng hiện tại | N/A |
| `PUT` | `/user/profile` | Cập nhật thông tin cá nhân | `{"fullName": "", "phone": "", "avatarUrl": ""}` |
| `GET` | `/user/addresses` | Danh sách sổ địa chỉ nhận hàng | N/A |
| `POST` | `/user/addresses` | Thêm mới địa chỉ Việt Nam | `{"recipientName": "", "phoneNumber": "", "provinceId": "", "districtId": "", "wardId": "", "streetDetails": "", "isDefault": true}` |
| `PUT` | `/user/addresses/{id}` | Cập nhật địa chỉ | Payload tương tự |
| `DELETE` | `/user/addresses/{id}` | Xóa địa chỉ | N/A |
| `POST` | `/vouchers/validate` | Kiểm tra và áp dụng mã voucher | `{"code": "ADIDASVN100", "orderValue": 1500000}` |
| `GET` | `/products/{id}/reviews` | Lấy danh sách đánh giá sản phẩm | Query: `?page=1&limit=10` |
| `POST` | `/products/{id}/reviews` | Gửi đánh giá và chấm điểm sao | `{"rating": 5, "comment": "Giày chạy rất êm, chuẩn form Việt Nam", "images": []}` |

---

### 3. Kế Hoạch & Tiêu Chuẩn Kiểm Thử (Testing Strategy)

#### 3.1. Phân loại Kiểm thử
1. **Unit Test (Kiểm thử đơn vị)**:
   - Tập trung vào **BLoC / Cubit**: Kiểm tra sự chuyển biến trạng thái (state transitions) khi nhận các sự kiện (Events) bằng thư viện `bloc_test`.
   - **Repository & UseCases**: Sử dụng `mocktail` để giả lập `RemoteDataSource` và kiểm tra logic xử lý ngoại lệ (Exception to Failure).
   - **Utils & Helpers**: Kiểm thử các hàm format tiền tệ VNĐ (`formatVndCurrency`), validate số điện thoại Việt Nam, logic tính chiết khấu voucher.
2. **Widget Test (Kiểm thử giao diện & Tương tác)**:
   - Đảm bảo các component then chốt (`ProductCard`, `AppButton`, `CartItemWidget`, `LoginForm`) hiển thị đúng thông tin khi nhận props/state.
   - Kiểm tra hành vi nhấn nút (Tap), gõ phím (Enter text), hiển thị loading indicator và xử lý báo lỗi form validation.

#### 3.2. Mẫu Mã Nguồn Unit Test Chuẩn (Ví dụ cho CartBloc)
```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Giả lập MockCartRepository
class MockCartRepository extends Mock implements CartRepository {}

void main() {
  late CartBloc cartBloc;
  late MockCartRepository mockCartRepository;

  setUp(() {
    mockCartRepository = MockCartRepository();
    cartBloc = CartBloc(cartRepository: mockCartRepository);
  });

  tearDown(() {
    cartBloc.close();
  });

  group('CartBloc - Tính tổng tiền & Thêm sản phẩm', () {
    final tItem = CartItemEntity(productId: 'P1', name: 'Ultraboost Light', price: 2000000, quantity: 1, size: '42');

    blocTest<CartBloc, CartState>(
      'emit [CartLoading, CartLoaded] với tổng tiền chính xác khi thêm sản phẩm thành công',
      build: () {
        when(() => mockCartRepository.addToCart(tItem))
            .thenAnswer((_) async => [tItem]);
        return cartBloc;
      },
      act: (bloc) => bloc.add(AddToCartEvent(item: tItem)),
      expect: () => [
        isA<CartLoading>(),
        isA<CartLoaded>().having((state) => state.totalPrice, 'totalPrice', 2000000),
      ],
    );
  });
}
```

#### 3.3. Quy định Tiêu chuẩn Độ phủ (Coverage Thresholds)
- Mọi logic tính toán tiền tệ và giỏ hàng phải có Unit Test đạt **100% độ phủ nhánh (Branch coverage)**.
- Toàn bộ các BLoC cốt lõi (`AuthBloc`, `ProductBloc`, `CartBloc`, `OrderBloc`) phải có test case bao quát ít nhất 2 kịch bản: **Thành công (Success State)** và **Thất bại/Lỗi mạng (Failure State)**.
- Chạy lệnh kiểm thử tự động trước mỗi lần tạo Pull Request:
  ```bash
  flutter test --coverage
  ```
