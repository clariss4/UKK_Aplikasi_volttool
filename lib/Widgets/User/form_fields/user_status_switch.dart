import 'package:flutter/material.dart';

class UserStatusSwitch extends StatelessWidget {
  final bool isActive;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  const UserStatusSwitch({
    Key? key,
    required this.isActive,
    required this.onChanged,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Status Pengguna',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              Text(
                'Non Aktif',
                style: TextStyle(
                  color: isActive ? Colors.grey[600] : Colors.black,
                  fontWeight: isActive ? FontWeight.normal : FontWeight.w600,
                ),
              ),
              const SizedBox(width: 12),
              Switch(
                value: isActive,
                activeColor: const Color(0xFFFB923C),
                onChanged: enabled ? onChanged : null,
              ),
              const SizedBox(width: 12),
              Text(
                'Aktif',
                style: TextStyle(
                  color: isActive ? Colors.black : Colors.grey[600],
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 