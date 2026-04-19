import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../providers/history_provider.dart';
import '../screens/history_screen.dart';
import '../screens/settings_screen.dart';

class RightNavigation extends StatelessWidget {
  const RightNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _iconButton(
            context,
            icon: Icons.history,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            ),
          ),
          _divider(),
          _iconButton(
            context,
            icon: Icons.delete_sweep_outlined,
            isDestructive: true,
            onTap: () {
               // Gọi hàm xóa lịch sử
               Provider.of<HistoryProvider>(context, listen: false).clearHistory();
               ScaffoldMessenger.of(context).showSnackBar(
                 const SnackBar(content: Text("History Cleared"), duration: Duration(milliseconds: 500)),
               );
            },
          ),
          _divider(),
          _iconButton(
            context,
            icon: Icons.settings_outlined,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 20,
      width: 1,
      color: Colors.grey.withOpacity(0.3),
    );
  }

  Widget _iconButton(BuildContext context, {required IconData icon, required VoidCallback onTap, bool isDestructive = false}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Icon(
            icon,
            size: 22,
            color: isDestructive ? AppColors.lightAccent : Colors.white70,
          ),
        ),
      ),
    );
  }
}