
// import 'package:apk_peminjaman/Widgets/peminjaman_pengembalian/pengembalian_card.dart';
// import 'package:apk_peminjaman/Widgets/peminjaman_pengembalian/perbarui_pengembalian_dialog.dart';
// import 'package:flutter/material.dart';

// class PengembalianList extends StatelessWidget {
//   const PengembalianList({Key? key}) : super(key: key);

//   void _showPerbaruiDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return const PerbaruiPengembalianDialog();
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       children: [
//         PengembalianCard(
//           namaLengkap: 'Clarissa Aurelia Qurnia Putri',
//           username: 'clarissa456@volttool.com',
//           petugas: 'Sintia wiwik dwi',
//           tanggalPinjam: '10/01/2026 - 12/01/2026',
//           dikembalikan: '14-01-2026',
//           kondisi: 'Baik',
//           denda: null,
//           status: 'Terlambat',
//           statusColor: Colors.red[300]!,
//           onEditPressed: () => _showPerbaruiDialog(context),
//         ),
//         const SizedBox(height: 16),
//         PengembalianCard(
//           namaLengkap: 'Clarissa Aurelia Qurnia Putri',
//           username: 'clarissa456@volttool.com',
//           petugas: 'Sintia wiwik dwi',
//           tanggalPinjam: '10/01/2026 - 12/01/2026',
//           dikembalikan: '12-01-2026',
//           kondisi: 'Baik',
//           denda: null,
//           status: 'Dikembalikan',
//           statusColor: Colors.green[300]!,
//           onEditPressed: () => _showPerbaruiDialog(context),
//         ),
//         // Tambahkan card lainnya sesuai kebutuhan
//       ],
//     );
//   }
// }
