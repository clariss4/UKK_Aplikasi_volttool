import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color labelColor;
  final Color valueColor;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.backgroundColor,
    this.labelColor = const Color(0xfffaf8f7),
    this.valueColor = const Color(0xfffaf8f7),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(fontSize: 12, color: labelColor)),
            ],
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(icon, color: Colors.orange),
          ),
        ],
      ),
    );
  }
}
