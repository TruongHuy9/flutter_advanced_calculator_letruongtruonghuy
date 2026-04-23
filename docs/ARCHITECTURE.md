#  Kiến trúc hệ thống

##  Mô hình kiến trúc

Ứng dụng sử dụng kiến trúc phân tầng kết hợp với Provider để quản lý trạng thái.

##  Sơ đồ tổng quan

```
UI (Giao diện)
   ↓
Provider (Quản lý state)
   ↓
Logic xử lý (Calculator Engine)
   ↓
Dữ liệu (History, Settings)
```

---

##  Các thành phần

###  UI Layer

* CalculatorScreen
* Các keypad (Basic, Scientific, Programmer)
* Settings Screen

###  Provider Layer

* CalculatorProvider
* HistoryProvider
* ThemeProvider

###  Logic Layer

* Xử lý biểu thức (math_expressions)
* Phép toán bit (programmer mode)
* Bộ nhớ (memory)

###  Data Layer

* SharedPreferences (lưu setting)
* Danh sách lịch sử

---
