# Kế hoạch Lộ trình 4 Phase (4 Sprints - 8 Tuần)
## Dự án: sports-store-mobile

Lộ trình dự án được phân chia thành 4 Sprint (mỗi Sprint kéo dài 2 tuần), bảo đảm tiến độ phát triển song song của 5 thành viên không bị tắc nghẽn dependency.

---

### Sprint 1 (Tuần 1 - Tuần 2): Khởi tạo Nền tảng, Core Design System & Authentication
- **Trọng tâm**: Chuẩn hóa nền tảng kỹ thuật, thiết kế bộ UI Component phong cách Adidas, cơ chế bảo mật xác thực (Auth) và danh mục dữ liệu nền.
- **Tiến độ**: **100% HOÀN THÀNH (6/6 Tasks: TSK-01, TSK-02, TSK-03, TSK-04, TSK-05, TSK-06)**
- **Kết quả nghiệm thu**:
  - Repo Flutter Clean Architecture hoàn thiện, thư viện cấu hình chuẩn, không có lỗi lint/analyze.
  - Luồng Authentication: Đăng ký, Đăng nhập, Quên mật khẩu, Đăng xuất, Lưu trữ JWT Token vào Cache `shared_preferences`.
  - UI Core: Trang chủ (Home Banner, Sản phẩm nổi bật, Khuyến mãi), nút truy cập giỏ hàng & tài khoản.
  - Unit Test `AuthBloc` và `CartBloc` đạt 100% pass (8/8 test cases).

---

### Sprint 2 (Tuần 3 - Tuần 4): Luồng Mua sắm (Catalog, Tìm kiếm, Giỏ hàng & Danh sách Yêu thích)
- **Trọng tâm**: Trải nghiệm duyệt và chọn mua hàng hóa.
- **Tiến độ**: **33% (2/6 Tasks: Đã xong TSK-09, TSK-10)**
- **Mục tiêu đạt được**:
  - `TSK-07` *(Đang làm)*: Tích hợp API Lấy danh sách sản phẩm, phân trang vô tận (Infinite Scroll), tìm kiếm debounce và lọc đa tiêu chí (Size, Thương hiệu, Mức giá VNĐ, Giới tính).
  - `TSK-08`: Chi tiết sản phẩm (Product Detail Page): Gallery ảnh nhiều góc chụp, chọn size giày/áo, bảng quy đổi kích cỡ chuẩn VN, chọn số lượng.
  - `TSK-09` *(Đã xong)*: UI Giỏ hàng (CartScreen) hiển thị danh sách, nút tăng giảm số lượng (+/-).
  - `TSK-10` *(Đã xong)*: Quản lý trạng thái Giỏ hàng (CartBloc): Thêm vào giỏ, cập nhật số lượng, xóa sản phẩm, tính tổng tiền tức thì theo VNĐ.
  - `TSK-11` *(Đang làm)*: Đã hoàn thành 4 test cases cho CartBloc, chờ ghép thêm ProductBloc test.

---

### Sprint 3 (Tuần 5 - Tuần 6): Thanh toán (Checkout), Đơn hàng, Sổ địa chỉ VN & Voucher/Review
- **Trọng tâm**: Hoàn tất phễu chuyển đổi mua hàng và tính năng giữ chân khách hàng (Retention).
- **Tiến độ**: **0% (Chưa bắt đầu)**
- **Mục tiêu đạt được (Milestone 3)**:
  - Quản lý Hồ sơ cá nhân (Profile) & Sổ địa chỉ Việt Nam (3 cấp: Tỉnh/Thành -> Quận/Huyện -> Phường/Xã).
  - Áp dụng Voucher / Mã giảm giá: Kiểm tra tính hợp lệ của mã, trừ tiền trực tiếp trên đơn hàng.
  - Đặt hàng & Thanh toán (POST Order): Lựa chọn COD hoặc Cổng thanh toán trực tuyến (VNPAY / MoMo).
  - Lịch sử Đơn hàng (Order History): Theo dõi trạng thái đơn (Chờ xác nhận, Đang giao, Đã giao, Đã hủy).
  - Đánh giá & Nhận xét sản phẩm (Review & Rating): Xem danh sách đánh giá của khách, form gửi đánh giá kèm ảnh và số sao.

---

### Sprint 4 (Tuần 7 - Tuần 8): Phân hệ Quản trị (Admin), Tối ưu hiệu năng, Testing Toàn diện & Đóng gói Build
- **Trọng tâm**: Quản trị vận hành cho cửa hàng thể thao, kiểm thử độ phủ cao và xuất bản ứng dụng.
- **Tiến độ**: **0% (Chưa bắt đầu)**
- **Mục tiêu đạt được (Milestone 4)**:
  - Phân hệ Admin:
    - Quản lý Sản phẩm: Danh sách, Tìm kiếm, Form Thêm mới / Cập nhật / Xóa sản phẩm (Upload ảnh, quản lý biến thể size).
    - Quản lý Danh mục (Categories): Thêm/Sửa/Xóa phân loại thể thao (Bóng đá, Chạy bộ, Gym, Thời trang đường phố).
    - Quản lý Đơn hàng: Xem đơn đặt của khách, cập nhật trạng thái duyệt đơn (Xác nhận, Đang đóng gói, Đang giao hàng, Hoàn tất).
  - Viết Unit Test, Widget Test cho các BLoC và màn hình chính.
  - Fix bugs, kiểm tra rò rỉ bộ nhớ, tối ưu cache hình ảnh (CachedNetworkImage).
  - Đóng gói ứng dụng: Build APK và AppBundle (Android) sẵn sàng phát hành.
