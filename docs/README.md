# Thư Mục Tài Liệu Dự Án `sports-store-mobile`
## Hệ Thống Tài Liệu Kế Hoạch & Phân Rã Task (Team 5 Thành Viên)

Chào mừng bạn đến với bộ tài liệu kỹ thuật và kế hoạch triển khai cho ứng dụng di động **Sports Store Mobile** (Phong cách Adidas - Chuẩn hóa Việt Nam).

---

### Danh Mục Tài Liệu (Documentation Index)

1. [00_OVERVIEW_AND_ARCHITECTURE.md](file:///C:/Users/SAN%20YO/.gemini/antigravity-ide/scratch/sports-store-mobile/docs/00_OVERVIEW_AND_ARCHITECTURE.md)
   - Tổng quan dự án, ngôn ngữ thiết kế Adidas DNA.
   - Các điểm cải biến chuẩn hóa thị trường Việt Nam (Tiền tệ VNĐ, Sổ địa chỉ 3 cấp, Cổng thanh toán COD/VNPAY/MoMo).
   - Tech stack: Flutter, BLoC/Cubit, Dio, Clean Architecture (Feature-first).

2. [01_PHASE_ROADMAP.md](file:///C:/Users/SAN%20YO/.gemini/antigravity-ide/scratch/sports-store-mobile/docs/01_PHASE_ROADMAP.md)
   - Lộ trình 4 Sprint (8 tuần làm việc chuẩn Scrum, 2 tuần/Sprint).
   - Mục tiêu và mốc bàn giao (Milestones) cụ thể cho từng Sprint từ Sprint 1 đến Sprint 4.

3. [02_TASK_BREAKDOWN_WBS.md](file:///C:/Users/SAN%20YO/.gemini/antigravity-ide/scratch/sports-store-mobile/docs/02_TASK_BREAKDOWN_WBS.md)
   - Bảng phân rã công việc chi tiết (WBS) gồm 24 tasks (`TSK-01` đến `TSK-24`).
   - Bao gồm mã định danh, mô tả kỹ thuật, độ ưu tiên (P0, P1, P2) và tiêu chí nghiệm thu (Acceptance Criteria).

4. [03_MEMBER_ASSIGNMENT.md](file:///C:/Users/SAN%20YO/.gemini/antigravity-ide/scratch/sports-store-mobile/docs/03_MEMBER_ASSIGNMENT.md)
   - Phân chia trách nhiệm cho 5 thành viên theo mô hình **Feature/Domain Owner**.
   - Phân bổ chi tiết nhiệm vụ của từng thành viên qua 4 Sprint.
   - Quy ước Git Workflow (Branching Convention, Pull Request, Code Review).

5. [04_API_AND_TESTING_SPEC.md](file:///C:/Users/SAN%20YO/.gemini/antigravity-ide/scratch/sports-store-mobile/docs/04_API_AND_TESTING_SPEC.md)
   - Đặc tả danh sách API RESTful đầy đủ cho toàn bộ tính năng User & Admin.
   - Kế hoạch Unit Test & Widget Test, chuẩn kiểm thử `bloc_test`, `mocktail` và mẫu mã nguồn test case.

---

### Hướng Dẫn Sao Chép Vào Thư Mục Làm Việc D:\PRM\sports-store-main
Nếu bạn muốn sao chép toàn bộ thư mục `docs` này sang thư mục dự án `D:\PRM\sports-store-main\docs`, bạn có thể chạy lệnh sau trong PowerShell:

```powershell
New-Item -ItemType Directory -Force -Path "D:\PRM\sports-store-main\docs"
Copy-Item -Path "C:\Users\SAN YO\.gemini\antigravity-ide\scratch\sports-store-mobile\docs\*" -Destination "D:\PRM\sports-store-main\docs" -Recurse -Force
```
