import 'package:flutter/material.dart';

class RequestCard extends StatelessWidget {
  const RequestCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= NAMA =================
          const Text(
            'Clarissa Aurelia QP',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),

          const SizedBox(height: 8),

          // ================= DIVIDER =================
          const Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),

          const SizedBox(height: 10),

          // ================= TANGGAL =================
          const Text(
            '30 Jan 2026 - 01 Feb 2026',
            style: TextStyle(fontSize: 11.5, color: Color(0xFF6B7280)),
          ),

          const SizedBox(height: 4),

          // ================= TOTAL ALAT =================
          const Text(
            'Total Alat: 2',
            style: TextStyle(fontSize: 11.5, color: Color(0xFF374151)),
          ),

          const SizedBox(height: 12),

          // ================= STATUS + BUTTON =================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // STATUS (TEKS, BUKAN CHIP)
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 11.5, color: Color(0xFF374151)),
                  children: [
                    TextSpan(text: 'Status: '),
                    TextSpan(
                      text: 'Menunggu',
                      style: TextStyle(
                        color: Color(0xFFFB923C),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
