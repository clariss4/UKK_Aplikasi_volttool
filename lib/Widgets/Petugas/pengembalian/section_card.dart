import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final Widget? child;

  const SectionCard({
    super.key,
    required this.title,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFFFFE3C5),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFFFB923C),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child ??
                const Text(
                  '—',
                  style: TextStyle(color: Colors.grey),
                ),
          ),
        ],
      ),
    );
  }
}
