# Bảng Phân Rã Công Việc Chi Tiết (Work Breakdown Structure - WBS)
## Dự án: sports-store-mobile

Bảng danh sách chi tiết các công việc, mã định danh, mô tả kỹ thuật, điều kiện nghiệm thu (Acceptance Criteria), mức độ ưu tiên và **Trạng thái thực tế**.

---

### Phase 1: Foundation & Authentication (Sprint 1) - TIẾN ĐỘ: 100% (6/6 Tasks)

| Task ID | Tên công việc | Mô tả kỹ thuật | Tiêu chí nghiệm thu (Acceptance Criteria) | Độ ưu tiên | Trạng thái |
| :--- | :--- | :--- | :--- | :--- | :---: |
| **TSK-01** | Khởi tạo Flutter, chia cấu trúc, config thư viện | Setup Clean Architecture (data/domain/presentation), tích hợp `flutter_bloc`, `dio`, `get_it`, `shared_preferences`, `intl`, `cached_network_image`. | - Dự án build chạy thành công trên emulator/thiết bị thật.<br>- Cấu trúc thư mục chuẩn hóa, không có warning lint. | P0 | **✅ Hoàn thành (11/10/2026)** |
| **TSK-02** | Xây dựng Design System & Theme Adidas | Định nghĩa ColorScheme (Black, White, Neon accents), Typography kiểu dáng thể thao, các Custom Widget tái sử dụng (`AppButton`, `AppTextField`, `ProductCardSkeleton`). | - Hỗ trợ Dark/Light Theme.<br>- Button và Input field phản hồi mượt mà khi focus/disabled. | P0 | **✅ Hoàn thành (11/10/2026)** |
| **TSK-03** | UI Đăng nhập, Đăng ký & Quên mật khẩu | Dựng giao diện 3 màn hình theo phong cách Adidas tối giản. Form validation (email chuẩn, mật khẩu >= 6 ký tự, SĐT VN). Bổ sung menu Đăng xuất. | - UI chuẩn responsive theo các kích thước màn hình.<br>- Báo lỗi form trực quan ngay dưới input field. | P1 | **✅ Hoàn thành (11/10/2026)** |
| **TSK-04** | Ghép API Đăng nhập/Đăng ký, Cache Token | Tạo `AuthRemoteDataSource`, `AuthRepository`, `AuthBloc`. Xử lý lưu AccessToken & RefreshToken vào `shared_preferences`. Tự động gắn Token vào header Dio. Hỗ trợ LogoutEvent xóa token. | - Đăng nhập thành công chuyển hướng vào Home.<br>- Khi tắt app mở lại tự động khôi phục phiên đăng nhập. | P0 | **✅ Hoàn thành (11/10/2026)** |
| **TSK-05** | UI Trang chủ (Home Screen) & Banner | Dựng màn hình Home với Carousel Banner tự động lướt, danh mục thể thao nhanh, khối Sản phẩm mới (New Arrivals), Best Seller. Fix tràn pixel (RenderFlex overflow). | - Banner vuốt mượt, hiển thị badge khuyến mãi.<br>- Không lỗi tràn pixel trên desktop/mobile. | P1 | **✅ Hoàn thành (11/10/2026)** |
| **TSK-06** | Thiết lập Unit Test & Test AuthBloc | Viết test cho `AuthBloc` (kiểm tra states: Initial, Loading, Success, Failure, Logout) và test hàm validate định dạng số điện thoại/email. | - Độ phủ test AuthBloc đạt 100% case thành công/thất bại.<br>- Lệnh `flutter test` chạy pass 100%. | P1 | **✅ Hoàn thành (11/10/2026)** |

---

### Phase 2: Catalog, Product Discovery & Cart (Sprint 2) - TIẾN ĐỘ: 33% (2/6 Tasks)

| Task ID | Tên công việc | Mô tả kỹ thuật | Tiêu chí nghiệm thu (Acceptance Criteria) | Độ ưu tiên | Trạng thái |
| :--- | :--- | :--- | :--- | :--- | :---: |
| **TSK-07** | Ghép API Lấy danh sách Sản phẩm, Lọc, Phân trang | Viết `ProductBloc`. Gọi API danh sách sản phẩm, hỗ trợ phân trang (Infinite scroll khi cuộn tới cuối danh sách), debounce tìm kiếm 500ms. | - Kéo cuộn tải thêm không bị giật lag.<br>- Bộ lọc theo giá (VNĐ), theo giới tính (Nam/Nữ/Trẻ em) hoạt động chính xác. | P0 | ⏳ Đang làm |
| **TSK-08** | UI Tìm kiếm & Chi tiết Sản phẩm | Màn hình Search với lịch sử tìm kiếm gần nhất. Màn hình Chi tiết: Gallery ảnh zoom, bảng chọn Size giày thể thao, nút Thêm vào giỏ nổi bật. | - Chuyển đổi qua lại giữa các ảnh mượt mà.<br>- Bắt buộc chọn Size trước khi nhấn 'Thêm vào giỏ'. | P1 | ⏹ Chưa làm |
| **TSK-09** | UI Giỏ hàng & Danh sách Yêu thích | Dựng màn hình Cart với danh sách món đồ, tùy chọn số lượng (+/-), nút xóa item. Màn hình Wishlist hiển thị các sản phẩm đã thả tim. | - Trống giỏ hàng hiển thị empty state đẹp mắt kèm nút 'Tiếp tục mua sắm'.<br>- Thả tim cập nhật icon tức thì. | P1 | **✅ Hoàn thành (11/10/2026)** *(Đã làm trước phần CartScreen)* |
| **TSK-10** | Ghép API Giỏ hàng, Tính tổng tiền (State Management) | Viết `CartBloc`. Thêm sản phẩm, tăng/giảm số lượng, xóa sản phẩm. Tự động tính lại tổng tiền hàng theo VNĐ (áp dụng nguyên tắc immutable state). | - State giỏ hàng đồng bộ tức thì trên toàn ứng dụng (Badge số lượng trên AppBar).<br>- Tổng tiền tính chính xác từng đơn vị đồng. | P0 | **✅ Hoàn thành (11/10/2026)** *(Đã xong CartBloc & Test)* |
| **TSK-11** | Unit Test cho ProductBloc & CartBloc | Viết test kịch bản lọc sản phẩm, thêm trùng sản phẩm thì tăng quantity, xóa sản phẩm khỏi giỏ hàng. | - Đảm bảo các logic tính toán tổng tiền không xảy ra sai số.<br>- Đã pass 4/4 test cases của CartBloc. | P1 | ⏳ Đang làm *(Xong CartBloc, chờ ProductBloc)* |

---

### Phase 3: Profile, Vietnam Checkout, Voucher & Review (Sprint 3) - TIẾN ĐỘ: 50%

| Task ID | Tên công việc | Mô tả kỹ thuật | Tiêu chí nghiệm thu (Acceptance Criteria) | Độ ưu tiên | Trạng thái |
| :--- | :--- | :--- | :--- | :--- | :---: |
| **TSK-12** | UI Quản lý Hồ sơ cá nhân & Sổ địa chỉ | Màn hình Thông tin người dùng (Họ tên, SĐT, Avatar). Màn hình Sổ địa chỉ: Form chọn Tỉnh/Thành -> Quận/Huyện -> Phường/Xã chuẩn Việt Nam. | - Dropdown 3 cấp chọn địa giới hành chính VN mượt mà.<br>- Đánh dấu địa chỉ mặc định khi giao hàng. | P1 | ✅ Hoàn thành |
| **TSK-13** | Ghép API CRUD Sổ địa chỉ & Update Info | Gọi API cập nhật thông tin người dùng, thêm mới/chỉnh sửa/xóa địa chỉ nhận hàng. Lưu địa chỉ mặc định vào Cache/State. | - Dữ liệu địa chỉ được lưu trữ và hiển thị chính xác ở bước checkout.<br>- Xử lý validation số điện thoại nhận hàng VN. | P0 | ✅ Hoàn thành |
| **TSK-14** | UI Quản lý & Áp dụng Mã giảm giá | Màn hình danh sách voucher khuyến mãi thể thao. Input nhập mã code giảm giá ở màn hình Checkout, hiển thị số tiền được giảm. | - Kiểm tra điều kiện áp dụng voucher (giá trị đơn tối thiểu, hạn dùng).<br>- Trừ tiền trực tiếp vào hóa đơn tạm tính. | P1 | ✅ Hoàn thành (13/10/2026) |
| **TSK-15** | Ghép API Kiểm tra & Áp dụng Voucher | Viết `VoucherBloc`, gọi API xác thực mã giảm giá, trả về chiết khấu và cập nhật vào `CheckoutState`. | - Báo lỗi rõ ràng nếu mã hết hạn hoặc không đủ điều kiện.<br>- Khóa nút áp dụng khi chưa nhập mã. | P1 | ⏹ Chưa làm |
| **TSK-16** | UI Thanh toán & Lịch sử Đơn hàng (User) | Màn hình Checkout: Tóm tắt đơn, chọn địa chỉ nhận, phương thức thanh toán (COD hoặc VNPAY/MoMo). Màn hình Lịch sử đơn hàng có tab phân loại trạng thái. | - Giao diện thanh toán sang trọng, rõ ràng từng khoản phí.<br>- Lịch sử đơn hiển thị đầy đủ mã đơn, ngày mua, trạng thái. | P1 | ⏳ Đang làm *(Đã xong Lịch sử Đơn hàng & 5/5 Unit tests, chờ UI Checkout)* |
| **TSK-17** | Ghép API Tạo Đơn hàng (POST Order) | Viết `OrderBloc`, gửi payload đơn hàng lên server. Nếu chọn online payment: mở Webview hoặc deep-link VNPAY/MoMo để hoàn tất. | - Đặt hàng thành công tự động làm rỗng giỏ hàng.<br>- Điều hướng sang màn hình 'Đặt hàng thành công' với mã vận đơn. | P0 | ⏹ Chưa làm |
| **TSK-18** | UI Danh sách Đánh giá, Rating form & Ghép API Review | Hiển thị điểm số trung bình (sao 1-5) và danh sách phản hồi ở chi tiết sản phẩm. Form gửi đánh giá kèm bình luận cho người đã mua hàng. | - Người dùng chấm điểm sao từ 1 đến 5.<br>- Gửi đánh giá thành công thì danh sách review tự động cập nhật. | P2 | ⏳ Đang làm *(Đã xong UI Danh sách Đánh giá & Rating Form 13/10/2026, chờ Ghép API)* |

---

### Phase 4: Admin Features, Comprehensive Testing & Build (Sprint 4) - TIẾN ĐỘ: 0%

| Task ID | Tên công việc | Mô tả kỹ thuật | Tiêu chí nghiệm thu (Acceptance Criteria) | Độ ưu tiên | Trạng thái |
| :--- | :--- | :--- | :--- | :--- | :---: |
| **TSK-19** | UI Danh sách Sản phẩm (Admin) & Form Thêm/Sửa | Giao diện quản lý hàng hóa dành cho Admin: Bảng sản phẩm, form nhập tên, giá, chọn ảnh, kích thước, mô tả, tồn kho. | - Cho phép chọn nhiều ảnh từ thiết bị.<br>- Kiểm tra hợp lệ các trường giá và số lượng tồn kho. | P1 | ⏹ Chưa làm |
| **TSK-20** | UI Quản lý Danh mục (Category) & Ghép API CRUD | Quản lý các nhóm thể thao (Running, Football, Basketball, Training). Form thêm/sửa/xóa danh mục sản phẩm. | - Xóa danh mục có cảnh báo xác nhận an toàn.<br>- Dữ liệu cập nhật real-time trên giao diện. | P1 | ⏹ Chưa làm |
| **TSK-21** | Ghép API Thêm/Xóa/Sửa Sản phẩm & Danh mục | Viết `AdminProductBloc`, tích hợp Multipart Request upload ảnh sản phẩm lên server, gọi API CRUD. | - Upload ảnh thành công, hiển thị thanh tiến trình.<br>- Thông báo Snackbar/Toast thành công bằng tiếng Việt. | P0 | ⏹ Chưa làm |
| **TSK-22** | UI Danh sách Đơn hàng & Ghép API Cập nhật Trạng thái | Màn hình admin xem toàn bộ đơn khách đặt, bộ lọc theo trạng thái đơn. Nút thao tác chuyển trạng thái (Duyệt đơn, Đang giao, Đã giao). | - Cập nhật trạng thái đơn lập tức phản hồi về phía người mua.<br>- Có bộ lọc đơn theo ngày và theo trạng thái. | P0 | ⏹ Chưa làm |
| **TSK-23** | Viết Widget Test cho các màn hình trọng yếu | Viết Widget Test cho ProductCard, CartItem, LoginForm, CheckoutSummaryWidget. | - Kiểm tra các hành vi bấm nút, hiển thị dữ liệu chính xác khi nhận mock state.<br>- Chạy mượt mà trên CI/CD test suite. | P1 | ⏹ Chưa làm |
| **TSK-24** | Build APK/AppBundle & Fix Bugs | Kiểm tra toàn bộ luồng app (End-to-End), sửa lỗi tràn pixel (RenderFlex overflow), fix rò rỉ bộ nhớ, cấu hình ProGuard, build file APK release và Android App Bundle (AAB). | - Xuất ra file `app-release.apk` và `app-release.aab` không lỗi.<br>- Khởi động ứng dụng trên thiết bị thật mượt mà dưới 2 giây. | P0 | ⏹ Chưa làm |
