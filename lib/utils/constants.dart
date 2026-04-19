import 'package:flutter/material.dart';

class AppColors {
  // -------- Light Theme (Phong cách sạch sẽ, hiện đại) --------
  // Nền xám xanh rất nhạt, tạo cảm giác cao cấp hơn trắng tinh
  static const Color lightPrimary = Color(0xFFF1F5F9);    
  // Màu trắng cho các khối (Container/Display)
  static const Color lightSecondary = Color(0xFFFFFFFF);  
  // Màu xanh dương đậm làm điểm nhấn
  static const Color lightAccent = Color(0xFF2563EB);     

  // -------- Dark Theme (Phong cách Deep Midnight/Slate) --------
  // Nền xanh đen đậm (Slate 900) - Rất dịu mắt ban đêm
  static const Color darkPrimary = Color(0xFF0F172A);     
  // Nền các khối/nút (Slate 800) - Nổi bật nhẹ trên nền chính
  static const Color darkSecondary = Color(0xFF1E293B);   
  // Màu xanh Cyan sáng (Sky 400) - Tạo cảm giác công nghệ
  static const Color darkAccent = Color(0xFF38BDF8);      

  // -------- Common Colors --------
  static const Color textWhite = Colors.white;
  // Màu chữ phụ cho Dark mode (Xám bạc), không dùng trắng tinh gây chói
  static const Color dTextWhite = Color(0xFF94A3B8); 
  
  // -------- Button Colors (Mapping cho giao diện mặc định) --------
  
  // 1. Nút Số: Màu trùng với màu phụ của Dark Theme (Slate 800)
  static const Color btnNumber = Color(0xFF1E293B); 
  
  // 2. Nút Chức năng (C, %, ...): Màu sáng hơn nút số một chút (Slate 700)
  static const Color btnFunction = Color(0xFF334155); 
  
  // 3. Nút Toán tử (+, -, =, ...): Màu Cam Hổ Phách (Amber 500)
  // Màu này tạo độ tương phản cực tốt trên nền xanh đen, nhìn rất nổi bật
  static const Color btnOperator = Color(0xFFF59E0B); 
}