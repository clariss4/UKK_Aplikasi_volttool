// // ==================== FILE: lib/widgets/deactivate_confirm_dialog.dart ====================

// import 'package:flutter/material.dart';

// class DeactivateConfirmDialog extends StatelessWidget {
//   final String title;
//   final String message;
//   final String confirmLabel;

//   const DeactivateConfirmDialog({
//     Key? key,
//     required this.title,
//     required this.message,
//     required this.confirmLabel,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
//       backgroundColor: Colors.white,
//       insetPadding: const EdgeInsets.symmetric(horizontal: 40),
//       child: Padding(
//         padding: const EdgeInsets.all(28),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // ─── RED CIRCLE ICON ─────────────────────────────────────────
//             Container(
//               width: 56,
//               height: 56,
//               decoration: BoxDecoration(
//                 color: const Color(0xFFFFEBEE),
//                 shape: BoxShape.circle,
//               ),
//               child: Center(
//                 child: Container(
//                   width: 40,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     color: Colors.red[600],
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Center(
//                     child: Text(
//                       '!',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // ─── TITLE ───────────────────────────────────────────────────
//             Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 17,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 8),

//             // ─── MESSAGE ─────────────────────────────────────────────────
//             Text(
//               message,
//               style: const TextStyle(fontSize: 13, color: Colors.grey),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 24),

//             // ─── BUTTONS ─────────────────────────────────────────────────
//             Row(
//               children: [
//                 // Batal
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () => Navigator.pop(context, false),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(vertical: 11),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[100],
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Center(
//                         child: Text(
//                           'Batal',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey[600],
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 // Non Aktifkan
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () => Navigator.pop(context, true),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(vertical: 11),
//                       decoration: BoxDecoration(
//                         color: Colors.red[600],
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Center(
//                         child: Text(
//                           confirmLabel,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }