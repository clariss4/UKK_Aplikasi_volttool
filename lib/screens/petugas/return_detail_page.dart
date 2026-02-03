import 'package:apk_peminjaman/Widgets/Petugas/pengembalian/condition_radio.dart';
import 'package:apk_peminjaman/Widgets/Petugas/pengembalian/damage_fine_ui.dart';
import 'package:apk_peminjaman/Widgets/Petugas/pengembalian/fine_summary_ui.dart';
import 'package:apk_peminjaman/Widgets/Petugas/pengembalian/late_final_ui.dart';
import 'package:apk_peminjaman/Widgets/Petugas/pengembalian/section_card.dart';
import 'package:flutter/material.dart';


class ReturnDetailPage extends StatefulWidget {
  const ReturnDetailPage({super.key});

  @override
  State<ReturnDetailPage> createState() => _ReturnDetailPageState();
}

class _ReturnDetailPageState extends State<ReturnDetailPage> {
  int condition = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F2EC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text('Detail Pengembalian'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionCard(title: 'Informasi Peminjam'),
          const SectionCard(title: 'Keterlambatan'),
          const SectionCard(title: 'Daftar Alat'),

          const SizedBox(height: 12),
          ConditionRadio(
            value: condition,
            onChanged: (v) => setState(() => condition = v),
          ),

          if (condition == 0) const LateFineUI(),
          if (condition == 1) const DamageFineUI(),

          const FineSummaryUI(),

          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Batal'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Konfirmasi Pengembalian'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
