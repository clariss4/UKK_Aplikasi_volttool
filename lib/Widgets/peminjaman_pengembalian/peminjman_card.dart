// import 'package:flutter/material.dart';

// class PeminjamanCard extends StatelessWidget {
//   final String namaLengkap;
//   final String username;
//   final String petugas;
//   final String tanggalPinjam;
//   final String tanggalKembali;
//   final List<String> alatDipinjam;
//   final String kategori;
//   final String status;
//   final Color statusColor;

//   const PeminjamanCard({
//     Key? key,
//     required this.namaLengkap,
//     required this.username,
//     required this.petugas,
//     required this.tanggalPinjam,
//     required this.tanggalKembali,
//     required this.alatDipinjam,
//     required this.kategori,
//     required this.status,
//     required this.statusColor,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
//       ),
//       padding: const EdgeInsets.all(16),
//       margin: const EdgeInsets.only(bottom: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(namaLengkap, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 8),
//           Text('Username: $username', style: TextStyle(color: Colors.grey[700])),
//           Text('Petugas: $petugas', style: TextStyle(color: Colors.grey[700])),
//           Text('Tanggal pinjam: $tanggalPinjam', style: TextStyle(color: Colors.grey[700])),
//           Text('Tanggal pengembalian: $tanggalKembali', style: TextStyle(color: Colors.grey[700])),
//           const SizedBox(height: 12),
//           const Text('Alat yang dipinjam:', style: TextStyle(fontWeight: FontWeight.w600)),
//           ...alatDipinjam.map((alat) => Text(alat, style: TextStyle(color: Colors.grey[600]))),
//           const SizedBox(height: 12),
//           Text('Kategori: $kategori', style: TextStyle(color: Colors.grey[600])),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Text('Status:', style: const TextStyle(fontWeight: FontWeight.w600)),
//               const SizedBox(width: 8),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//                 decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(20)),
//                 child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
