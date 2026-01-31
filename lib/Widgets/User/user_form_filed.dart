// import 'package:flutter/material.dart';

// /// Reusable widget untuk form fields user
// class UserFormFields {
//   static const _primaryColor = Color(0xFFFF8C42);

//   /// Custom TextField untuk nama lengkap
//   static Widget buildNamaField({
//     required TextEditingController controller,
//     String? errorText,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Nama Lengkap',
//           style: TextStyle(fontWeight: FontWeight.w600),
//         ),
//         const SizedBox(height: 8),
//         TextField(
//           controller: controller,
//           decoration: _buildInputDecoration(
//             hintText: 'Masukkan nama lengkap',
//             errorText: errorText,
//           ),
//         ),
//       ],
//     );
//   }

//   /// Custom TextField untuk username
//   static Widget buildUsernameField({
//     required TextEditingController controller,
//     String? errorText,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Username',
//           style: TextStyle(fontWeight: FontWeight.w600),
//         ),
//         const SizedBox(height: 8),
//         TextField(
//           controller: controller,
//           decoration: _buildInputDecoration(
//             hintText: 'Username akan digunakan untuk login',
//             errorText: errorText,
//           ),
//         ),
//       ],
//     );
//   }

//   /// Custom TextField untuk password dengan show/hide
//   static Widget buildPasswordField({
//     required TextEditingController controller,
//     required bool obscureText,
//     required VoidCallback onToggleVisibility,
//     String label = 'Password*',
//     String hintText = 'Masukkan password minimal 8 karakter',
//     String? errorText,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(fontWeight: FontWeight.w600),
//         ),
//         const SizedBox(height: 8),
//         TextField(
//           controller: controller,
//           obscureText: obscureText,
//           decoration: _buildInputDecoration(
//             hintText: hintText,
//             errorText: errorText,
//             suffixIcon: IconButton(
//               icon: Icon(
//                 obscureText ? Icons.visibility_off : Icons.visibility,
//               ),
//               onPressed: onToggleVisibility,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   /// Custom Dropdown untuk role pengguna
//   static Widget buildRoleDropdown({
//     required String selectedRole,
//     required Function(String?) onChanged,
//     String? errorText,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Role pengguna',
//           style: TextStyle(fontWeight: FontWeight.w600),
//         ),
//         const SizedBox(height: 8),
//         DropdownButtonFormField<String>(
//           value: selectedRole,
//           decoration: _buildInputDecoration(
//             hintText: 'Pilih role',
//             errorText: errorText,
//           ),
//           items: const [
//             DropdownMenuItem(value: 'admin', child: Text('Admin')),
//             DropdownMenuItem(value: 'petugas', child: Text('Petugas')),
//             DropdownMenuItem(value: 'peminjam', child: Text('Peminjam')),
//           ],
//           onChanged: onChanged,
//         ),
//       ],
//     );
//   }

//   /// Custom Switch untuk status aktif/non-aktif
//   static Widget buildStatusSwitch({
//     required bool isActive,
//     required Function(bool) onChanged,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Status Pengguna',
//           style: TextStyle(fontWeight: FontWeight.w600),
//         ),
//         const SizedBox(height: 8),
//         Row(
//           children: [
//             const Text('Non Aktif'),
//             const SizedBox(width: 12),
//             Switch(
//               value: isActive,
//               activeColor: _primaryColor,
//               onChanged: onChanged,
//             ),
//             const SizedBox(width: 12),
//             const Text('Aktif'),
//           ],
//         ),
//       ],
//     );
//   }

//   /// Custom buttons untuk Batal dan Simpan
//   static Widget buildActionButtons({
//     required VoidCallback onCancel,
//     required VoidCallback onSave,
//     String cancelText = 'Batal',
//     String saveText = 'Simpan',
//   }) {
//     return Row(
//       children: [
//         Expanded(
//           child: OutlinedButton(
//             onPressed: onCancel,
//             style: OutlinedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(vertical: 14),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               side: BorderSide(color: Colors.grey[400]!),
//             ),
//             child: Text(
//               cancelText,
//               style: const TextStyle(
//                 fontSize: 16,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: ElevatedButton(
//             onPressed: onSave,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: _primaryColor,
//               padding: const EdgeInsets.symmetric(vertical: 14),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               elevation: 2,
//             ),
//             child: Text(
//               saveText,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   /// Helper: Build input decoration yang konsisten
//   static InputDecoration _buildInputDecoration({
//     required String hintText,
//     String? errorText,
//     Widget? suffixIcon,
//   }) {
//     return InputDecoration(
//       hintText: hintText,
//       hintStyle: TextStyle(color: Colors.grey[400]),
//       errorText: errorText,
//       suffixIcon: suffixIcon,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: BorderSide(color: Colors.grey[300]!),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: BorderSide(color: Colors.grey[300]!),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(
//           color: _primaryColor,
//           width: 2,
//         ),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(color: Colors.red, width: 1),
//       ),
//       focusedErrorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(color: Colors.red, width: 2),
//       ),
//       contentPadding: const EdgeInsets.symmetric(
//         horizontal: 16,
//         vertical: 12,
//       ),
//     );
//   }
// }