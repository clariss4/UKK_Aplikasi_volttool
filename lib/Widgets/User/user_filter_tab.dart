import 'package:flutter/material.dart';

class UserFilterTabs extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChanged;

  const UserFilterTabs({
    Key? key,
    required this.selectedIndex,
    required this.onTabChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white70.withOpacity(0.4),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          _buildTabItem(index: 0, text: 'Admin'),
          _buildTabItem(index: 1, text: 'Petugas'),
          _buildTabItem(index: 2, text: 'Peminjam'),
        ],
      ),
    );
  }

  Widget _buildTabItem({required int index, required String text}) {
    final bool isActive = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabChanged(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFFB923C) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: isActive ? Colors.white : const Color(0xff2b2b2b),
              ),
            ),
          ),
        ),
      ),
    );
  }
}