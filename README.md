#  Ứng dụng Máy Tính Nâng Cao (Flutter Advanced Calculator)

##  Mô tả dự án

Đây là ứng dụng máy tính đa chế độ được xây dựng bằng Flutter. Ứng dụng hỗ trợ các phép tính cơ bản, khoa học và lập trình với giao diện hiện đại và khả năng hiển thị kết quả theo thời gian thực.

Ứng dụng sử dụng Provider để quản lý trạng thái và được thiết kế theo hướng dễ mở rộng.

---

##  Tính năng chính

###  Chế độ cơ bản (Basic)

* Cộng, trừ, nhân, chia
* Hiển thị kết quả ngay khi nhập (preview)

###  Chế độ khoa học (Scientific)

* Các hàm: sin, cos, tan, log, ln, sqrt
* Hằng số: π, e
* Lũy thừa: x², x^y
* Chuyển đổi góc: DEG / RAD
* Tự động đóng ngoặc

###  Chế độ lập trình (Programmer)

* Hỗ trợ số hệ HEX
* Phép toán bit: AND, OR, XOR, <<, >>

###  Lịch sử

* Lưu các phép tính gần đây
* Nhấn để sử dụng lại phép tính

###  Bộ nhớ

* MC, MR, M+, M-

---

##  Ảnh minh họa / GIF

### Basic Mode

<img width="409" height="832" alt="Screenshot 2026-04-23 214357" src="https://github.com/user-attachments/assets/5da621e3-3795-4202-80e1-eaa3bc1e55f8" />

### Scientific Mode

<img width="401" height="839" alt="Screenshot 2026-04-23 214510" src="https://github.com/user-attachments/assets/5bd57594-fa58-417d-9a1f-e48d0525104c" />


### Programmer Mode

<img width="406" height="834" alt="Screenshot 2026-04-23 214525" src="https://github.com/user-attachments/assets/80b763f1-ea27-422f-8335-debbb1afd16a" />


### Demo

flutter_advanced_calculator_letruongtruonghuy/screenshots at main · TruongHuy9/flutter_advanced_calculator_letruongtruonghuy
---

## Sơ đồ kiến trúc

Xem chi tiết tại: `docs/ARCHITECTURE.md`

---

## Hướng dẫn cài đặt

```bash
git clone https://github.com/your-repo/flutter_advanced_calculator.git
cd flutter_advanced_calculator
flutter pub get
flutter run
```

---

## Hướng dẫn kiểm thử

Chạy test:

```bash
flutter test
```

Chi tiết test xem tại: `docs/TESTING.md`

---

##  Hạn chế hiện tại (Known Limitations)

* Một số biểu thức sai có thể gây lỗi
* Chế độ lập trình chỉ hỗ trợ HEX
* UI có thể bị tràn khi nhập biểu thức quá dài

---

##  Hướng phát triển (Future Improvements)

* Cải thiện parser xử lý biểu thức
* Hỗ trợ hoàn chỉnh nhân ngầm
* Thêm chuyển đổi hệ số (BIN, DEC, HEX)
* Nâng cấp UI/UX và animation
* Bổ sung thêm test case
* Xử lý lỗi tốt hơn

---
