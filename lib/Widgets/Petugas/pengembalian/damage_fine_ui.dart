import 'package:flutter/material.dart';

class DamageFineUI extends StatelessWidget {
  const DamageFineUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFB923C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Denda Rusak', style: TextStyle(color: Colors.white)),
          const SizedBox(height: 8),
          DropdownButtonFormField(
            items: const [
              DropdownMenuItem(value: 5, child: Text('5%')),
              DropdownMenuItem(value: 10, child: Text('10%')),
              DropdownMenuItem(value: 20, child: Text('20%')),
            ],
            onChanged: (_) {},
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
