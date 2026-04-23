#  Kiểm thử hệ thống

##  Chạy test

```bash
flutter test
```

---

##  Các test case chính

### 1. Tự động đóng ngoặc

Input:

```
(2+3
```

Expected:

```
5
```

---

### 2. Tính toán cơ bản

Input:

```
2+3*4
```

Expected:

```
14
```

---

### 3. Hàm lượng giác (DEG)

Input:

```
sin(90)
```

Expected:

```
1
```

---

### 4. HEX + Bitwise

Input:

```
0xFF AND 0x0F
```

Expected:

```
0x0F
```

---

### 5. Preview kết quả

* Khi nhập: `9*9`
* Kết quả hiển thị ngay: `81` (chưa cần bấm =)

---

##  Ghi chú

* Các test tập trung vào logic trong `CalculatorProvider`
* UI không được test trong phạm vi này

---
