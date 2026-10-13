# Báo Cáo Đối Soát & Chuẩn Hóa Kiến Trúc Toàn Diện
## Dự Án: sports-store-mobile (Adidas Style - Vietnam Standard)

---

### 1. Bảng So Sánh & Điểm Bất Đồng Bộ Ban Đầu (Gap Analysis)

| Hạng mục kiểm tra | Hiện trạng trong Plan (docs/) | Hiện trạng trong Skills (.agents/skills/) | Đánh giá mức độ đồng bộ | Giải pháp chuẩn hóa thống nhất |
| :--- | :--- | :--- | :--- | :--- |
| **State Management** | Thống nhất dùng **BLoC / Cubit** (`flutter_bloc`, `bloc_test`). | `feature-generator` tạo `providers/`, `flutter-apply-architecture` theo MVVM `ChangeNotifier`. | ❌ **Xung đột nghiêm trọng** | Chuẩn hóa 100% sang **BLoC / Cubit**. Loại bỏ hoàn toàn pattern Provider/ChangeNotifier. |
| **Cấu trúc thư mục** | **Feature-First Clean Architecture** (`lib/features/<module>/data`, `domain`, `presentation`). | `flutter-apply-architecture` theo Layer-First (`lib/data`, `lib/domain`, `lib/ui/features`). `feature-generator` đặt phẳng `lib/screens/`, `lib/models/`. | ❌ **Xung đột cấu trúc** | Chuẩn hóa **Feature-First Clean Architecture**: Mỗi tính năng độc lập tuyệt đối. |
| **Quy ước Git Branch** | Quy định `feature/TSK-[ID]-[tên]` | Quy định `feature/<tên-người-dùng>-<tên-module>` | ⚠️ **Chưa khớp format** | Thống nhất: `feature/<tên-người-dùng>/TSK-<id>-<tên-module>` (Ví dụ: `feature/dev1/TSK-04-auth-login`). |
| **Quy ước Commit** | Conventional Commits | Conventional Commits (có quy tắc tiếng Việt) |  **Đã đồng bộ** | Giữ nguyên: `feat:`, `fix:`, `chore:`, `refactor:` + tiếng Việt rõ nghĩa. |
| **Logging & Code Review** | Dùng `AppBlocObserver` để track state transitions | `code-reviewer` cấm cả `debugPrint()`, tách widget vào `lib/widgets/` phẳng | ⚠️ **Cần tinh chỉnh Clean** | Dùng `logger` + `AppBlocObserver`. Widget con đặt tại `features/<module>/presentation/widgets/` hoặc `core/widgets/`. |
| **Testing Strategy** | `bloc_test`, `mocktail`, `flutter_test` (Unit + Widget test) | `dart-add-unit-test` dùng `mockito`, `flutter-add-widget-test` chuẩn `WidgetTester` | ⚠️ **Lệch thư viện Mock** | Hỗ trợ chuẩn `mocktail` (Null-safety thuần không cần chạy `build_runner`) hoặc `mockito` tương thích. |

---

### 2. Bộ Quy Chuẩn Chuẩn Hóa Cho Dự Án (Golden Standards)

#### 2.1. Cấu trúc thư mục Feature-First Clean Architecture chuẩn:
```text
lib/
├── app/
│   ├── app.dart
│   ├── app_bloc_observer.dart
│   └── routes/
├── core/
│   ├── constants/
│   ├── errors/ (Failures & Exceptions)
│   ├── network/ (Dio client, Interceptors)
│   ├── theme/ (Adidas theme, Typography)
│   ├── utils/ (Format VNĐ, validate SĐT VN)
│   └── widgets/ (AppButton, AppTextField dùng chung toàn app)
└── features/
    └── <module_name>/ (auth, product, cart, order, profile, admin...)
        ├── data/
        │   ├── datasources/ (<module>_remote_datasource.dart)
        │   ├── models/ (<module>_model.dart)
        │   └── repositories/ (<module>_repository_impl.dart)
        ├── domain/
        │   ├── entities/ (<module>_entity.dart)
        │   ├── repositories/ (<module>_repository.dart)
        │   └── usecases/ (get_<module>_usecase.dart)
        └── presentation/
            ├── bloc/ (<module>_bloc.dart, <module>_event.dart, <module>_state.dart)
            ├── screens/ (<module>_screen.dart)
            └── widgets/ (Các widget con đặc thù của riêng module)
```

#### 2.2. Quy ước Git & Team Workflow:
- **Tên nhánh**: `feature/<tên-người-dùng>/TSK-<id>-<tên-module>`
- **Commit**: `type: TSK-<id> Mô tả thay đổi` (VD: `feat: TSK-04 Ghép API đăng nhập và lưu token SharedPreferences`)
- **Review**: Không dùng `print()`; widget dài >100 dòng tách vào `presentation/widgets/` của module; mọi PR phải chạy pass `flutter test`.
