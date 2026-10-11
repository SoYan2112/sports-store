# Phân Công Nhiệm Vụ 5 Thành Viên (Team Assignment & Matrix)
## Dự án: sports-store-mobile

Phân công theo mô hình **Feature / Domain Owner**: Mỗi thành viên chịu trách nhiệm End-to-End cho mảng tính năng của mình (từ UI, BLoC State Management, Tích hợp API đến Unit Test), đồng thời hỗ trợ kiểm thử chéo (Cross-testing) và Code Review.

---

### Tổng quan Vai trò 5 Thành viên

| Thành viên | Vai trò chính (Domain Owner) | Trách nhiệm cốt lõi |
| :--- | :--- | :--- |
| **Thành viên 1 (Lead Dev)** | **Core Foundation & Authentication** | Setup dự án, Clean Architecture, Network/Dio Interceptors, Auth (Login/Register/Token Cache), CI/CD & Build APK |
| **Thành viên 2 (Dev 2)** | **Product Catalog & Discovery** | Giao diện phong cách Adidas, Danh sách Sản phẩm, Lọc đa tiêu chí, Phân trang vô tận, Chi tiết sản phẩm & Tìm kiếm |
| **Thành viên 3 (Dev 3)** | **Cart, Checkout & Vietnam Payment** | Giỏ hàng (CartBloc), Tính tổng tiền VNĐ, Checkout, Tích hợp COD & Cổng thanh toán (VNPAY/MoMo), Đặt hàng |
| **Thành viên 4 (Dev 4)** | **Profile, Vietnam Address & Retention** | Sổ địa chỉ 3 cấp Việt Nam, Thông tin cá nhân, Hệ thống Voucher/Mã giảm giá, Đánh giá & Rating sản phẩm |
| **Thành viên 5 (Dev 5)** | **Admin Operations & QA/Testing** | Phân hệ Admin (Quản lý Sản phẩm, Danh mục, Duyệt đơn), Widget Test, Audit lỗi và tối ưu hiệu năng toàn app |

---

### Phân công Chi tiết Theo Từng Sprint

#### 1. Thành viên 1: Core Foundation & Auth
- **Sprint 1**:
  - `TSK-01`: Khởi tạo mã nguồn Flutter, chia cấu trúc Clean Architecture, cấu hình thư viện (`bloc`, `dio`, `get_it`, `shared_preferences`).
  - `TSK-03`: UI Đăng nhập, Đăng ký & Quên mật khẩu.
  - `TSK-04`: Ghép API Đăng nhập/Đăng ký, Cache Access/Refresh Token vào SharedPreferences.
  - `TSK-06`: Viết Unit Test cho AuthBloc và các Validator form.
- **Sprint 2**:
  - Hỗ trợ Member 2 & 3 cấu hình Base Repository, Token Refresh Interceptor tự động khi gọi API Cart/Product.
  - Quản lý phiên làm việc, tự động Logout khi token hết hạn.
- **Sprint 3**:
  - Phối hợp Member 3 xử lý bảo mật cho API thanh toán Order.
  - Rà soát Code Review toàn bộ PRs của Sprint 1 & 2.
- **Sprint 4**:
  - `TSK-24`: Build APK release và Android AppBundle (AAB), cấu hình ProGuard, tối ưu kích thước gói cài đặt.

---

#### 2. Thành viên 2: Product Catalog & Discovery
- **Sprint 1**:
  - `TSK-02`: Phối hợp Member 1 hoàn thiện Theme Adidas (Typography thể thao, ColorScheme, Buttons, Badges).
  - `TSK-05`: Dựng UI Trang chủ (Home Screen) với Banner Slider, Khối danh mục thể thao, Khối sản phẩm hot.
- **Sprint 2**:
  - `TSK-07`: Ghép API Lấy danh sách Sản phẩm, Lọc theo giá/kích thước/giới tính, phân trang vô tận (Infinite Scroll).
  - `TSK-08`: UI Tìm kiếm (Search debounce) & Màn hình Chi tiết sản phẩm (Gallery ảnh, chọn size, bảng quy đổi size VN).
  - `TSK-11`: Viết Unit Test cho ProductBloc.
- **Sprint 3**:
  - Tích hợp tính năng Thả tim / Wishlist cho sản phẩm.
  - Liên kết với tính năng hiển thị Đánh giá & Rating (hợp tác với Member 4).
- **Sprint 4**:
  - Tối ưu bộ nhớ cache hình ảnh sản phẩm (`CachedNetworkImage`).
  - Fix lỗi giao diện và hỗ trợ Member 5 hoàn thiện Widget Test.

---

#### 3. Thành viên 3: Cart, Checkout & Payment
- **Sprint 1**:
  - Chuẩn bị Data Model & Entity cho CartItem, Order, PaymentMethod.
  - Thiết kế Custom Widget cho các thẻ hiển thị món hàng trong giỏ.
- **Sprint 2**:
  - `TSK-09`: Dựng UI Giỏ hàng (Cart Screen) & Danh sách Yêu thích (Wishlist Screen).
  - `TSK-10`: Xây dựng `CartBloc`, ghép API Giỏ hàng, tính tổng tiền tự động theo VNĐ, kiểm soát số lượng món.
  - `TSK-11`: Viết Unit Test cho CartBloc (các trường hợp tính tiền, áp mã, tăng/giảm số lượng).
- **Sprint 3**:
  - `TSK-16`: Dựng UI Thanh toán (Checkout Screen) & UI Lịch sử Đơn hàng (Order History).
  - `TSK-17`: Ghép API Tạo Đơn hàng (POST Order), tích hợp phương thức COD và Cổng thanh toán trực tuyến (VNPAY/MoMo sandbox).
- **Sprint 4**:
  - Kiểm thử luồng giao dịch thanh toán, bắt các ngoại lệ hủy đơn/thanh toán thất bại.
  - Tối ưu trải nghiệm đặt hàng 1-chạm.

---

#### 4. Thành viên 4: Profile, Vietnam Address, Voucher & Review
- **Sprint 1**:
  - Chuẩn bị dữ liệu danh mục hành chính 3 cấp Việt Nam (Tỉnh/Thành -> Quận/Huyện -> Phường/Xã) dạng JSON offline hoặc API.
  - Thiết kế Custom UI Dropdown / BottomSheet chọn địa chỉ chuẩn UX di động Việt Nam.
- **Sprint 2**:
  - Chuẩn bị Data Model cho Voucher và Đánh giá (Review).
  - Hỗ trợ Member 2 xây dựng UI tab Đánh giá ở chi tiết sản phẩm.
- **Sprint 3**:
  - `TSK-12`: Dựng UI Quản lý Hồ sơ cá nhân & Sổ địa chỉ 3 cấp Việt Nam.
  - `TSK-13`: Ghép API CRUD Sổ địa chỉ & Cập nhật thông tin User.
  - `TSK-14`: Dựng UI Quản lý & Áp dụng Mã giảm giá (Voucher).
  - `TSK-15`: Ghép API Kiểm tra & Áp dụng Voucher (tính chiết khấu đưa vào đơn hàng của Member 3).
  - `TSK-18`: UI Danh sách Đánh giá, Rating form & Ghép API Gửi Đánh giá/Lấy Review.
- **Sprint 4**:
  - Viết Unit Test cho `VoucherBloc` và `AddressBloc`.
  - Fix bugs liên quan đến định dạng số điện thoại và thông tin nhận hàng.

---

#### 5. Thành viên 5: Admin Operations & QA/Testing
- **Sprint 1**:
  - Nghiên cứu setup môi trường kiểm thử tự động, cấu hình Mocktail và Mockito.
  - Viết bộ test case checklist cho toàn bộ ứng dụng.
- **Sprint 2**:
  - Thiết kế cấu trúc giao diện phân hệ Admin (Role-based check: chỉ tài khoản có role Admin mới truy cập được).
  - Thực hiện kiểm thử thủ công và tự động cho Sprint 1 & 2.
- **Sprint 3**:
  - Kiểm thử tích hợp phễu đặt hàng: từ chọn sản phẩm -> giỏ hàng -> áp mã voucher -> chọn địa chỉ VN -> thanh toán.
  - Báo cáo lỗi (Bug tracking) và phân loại độ ưu tiên cho các thành viên khắc phục.
- **Sprint 4**:
  - `TSK-19`: UI Danh sách Sản phẩm (Admin) & Form Thêm/Sửa sản phẩm kèm chọn ảnh và size.
  - `TSK-20`: UI Quản lý Danh mục (Category) & Ghép API CRUD Danh mục.
  - `TSK-21`: Ghép API Thêm/Xóa/Sửa Sản phẩm (Upload ảnh Multipart).
  - `TSK-22`: UI Danh sách Đơn hàng & Ghép API Cập nhật trạng thái duyệt đơn.
  - `TSK-23`: Viết Widget Test cho các màn hình trọng yếu (ProductCard, CartItem, LoginForm, CheckoutSummary).
  - Phối hợp Member 1 rà soát toàn bộ bug list trước khi đóng gói Release.

---

### Quy Trình Git & Phối Hợp Làm Việc (Workflow Rules)
1. **Quy tắc phân nhánh (Branching Convention)**:
   - Nhánh chính: `main` (mã nguồn ổn định phát hành), `develop` (mã nguồn tích hợp của các sprint).
   - Nhánh tính năng: `feature/TSK-[ID]-[ten-tinh-nang]` (Ví dụ: `feature/TSK-04-auth-api`).
   - Nhánh sửa lỗi: `bugfix/TSK-[ID]-[ten-loi]`.
2. **Quy tắc Pull Request (PR)**:
   - Mỗi PR phải đính kèm mã Task ID tương ứng.
   - Bắt buộc có ít nhất **1 thành viên khác duyệt (Code Review)** trước khi merge vào `develop`.
   - Tất cả các lệnh `flutter test` và `flutter analyze` phải pass 100% không có lỗi nghiêm trọng.
