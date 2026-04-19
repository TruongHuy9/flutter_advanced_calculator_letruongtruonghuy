import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/calculator_provider.dart';
import '../providers/history_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // --- Local State ---
  bool _hapticFeedback = true;
  bool _soundEffects = false;
  double _decimalPrecision = 5.0;

  @override
  Widget build(BuildContext context) {
    // 1. Lấy các Provider cần thiết
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text("Cài đặt", style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- PHẦN 1: GIAO DIỆN ---
          _buildSectionHeader("Giao diện"),
          _buildSwitchTile(
            title: "Dark Mode",
            subtitle: "Sử dụng giao diện tối",
            // Lấy giá trị thực từ ThemeProvider
            value: themeProvider.isDarkMode,
            onChanged: (val) {
              // Gọi hàm đổi theme toàn ứng dụng
              themeProvider.toggleTheme(val);
            },
            icon: Icons.dark_mode_outlined,
          ),

          const SizedBox(height: 24),

          // --- PHẦN 2: TÍNH TOÁN ---
          _buildSectionHeader("Tính toán"),

          // Slider độ chính xác
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Độ chính xác thập phân",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      "${_decimalPrecision.toInt()} số",
                      style: const TextStyle(
                        color: AppColors.lightAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Slider(
                value: _decimalPrecision,
                min: 0,
                max: 10,
                divisions: 10,
                activeColor: AppColors.lightAccent,
                inactiveColor: AppColors.darkSecondary,
                onChanged: (val) {
                  setState(() => _decimalPrecision = val);
                  // TODO: Cập nhật vào CalculatorProvider nếu muốn format số ngay
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // --- PHẦN 3: HỆ THỐNG ---
          _buildSectionHeader("Hệ thống"),
          _buildSwitchTile(
            title: "Rung phản hồi",
            subtitle: "Rung nhẹ khi nhấn phím",
            value: _hapticFeedback,
            onChanged: (val) => setState(() => _hapticFeedback = val),
            icon: Icons.feedback_outlined,
          ),
          _buildSwitchTile(
            title: "Âm thanh",
            subtitle: "Phát âm thanh khi nhấn phím",
            value: _soundEffects,
            onChanged: (val) => setState(() => _soundEffects = val),
            icon: Icons.volume_up_outlined,
          ),

          const SizedBox(height: 24),

          // --- PHẦN 4: DỮ LIỆU ---
          _buildSectionHeader("Dữ liệu"),
          ListTile(
            onTap: () {
              _showClearDialog(context);
            },
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.delete_forever, color: Colors.red),
            ),
            title: const Text(
              "Xóa lịch sử",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            subtitle: const Text(
              "Lịch sử tính toán của bạn sẽ bị xóa",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  // --- Các Widget Helper (Giữ nguyên) ---

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 16),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: AppColors.lightAccent,
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    String? subtitle,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.darkSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        activeColor: AppColors.lightAccent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        secondary: Icon(icon, color: Colors.white70),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              )
            : null,
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildOptionTile({
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.darkSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: Colors.white70),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.darkPrimary,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey.shade800),
          ),
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.lightAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkSecondary,
        title: const Text(
          "Xóa dữ liệu?",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "Bạn có chắc muốn xóa toàn bộ lịch sử tính toán? Hành động này không thể hoàn tác.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Hủy", style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              // Gọi hàm xóa trong HistoryProvider
              Provider.of<HistoryProvider>(
                context,
                listen: false,
              ).clearHistory();
              Navigator.pop(ctx);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Đã xóa lịch sử"),
                  backgroundColor: AppColors.lightAccent,
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: const Text(
              "Xóa vĩnh viễn",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}