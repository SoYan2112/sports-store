---
name: git-commit-formatter
description: Sử dụng khi người dùng muốn gom code, stage file, tạo git commit hoặc push code lên nhánh.
---

Khi người dùng yêu cầu commit code, hãy thực hiện phân tích các file thay đổi (git diff) và tạo commit message theo chuẩn Conventional Commits.

Quy tắc bắt buộc:
1. Xác định loại thay đổi (type):
   - `feat:` Thêm chức năng mới[cite: 3].
   - `fix:` Sửa lỗi bug[cite: 3].
   - `chore:` Cấu hình, update thư viện, dọn dẹp[cite: 3].
   - `refactor:` Viết lại code nhưng không đổi logic.
2. Viết mô tả ngắn gọn, rõ ràng bằng tiếng Việt.
3. Không tự động push thẳng lên `develop` hoặc `main`. Chỉ commit vào nhánh `feature` hiện tại[cite: 3].

Ví dụ: `feat: Thêm chức năng thanh toán giỏ hàng`