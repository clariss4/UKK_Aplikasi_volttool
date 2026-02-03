import 'package:flutter/material.dart';

class LateFineUI extends StatelessWidget {
  const LateFineUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFB923C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Denda Keterlambatan\n3 hari x 2.000 = Rp 6.000',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
