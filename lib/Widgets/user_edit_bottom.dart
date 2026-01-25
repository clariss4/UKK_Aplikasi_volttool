import 'package:apk_peminjaman/utils/validator.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';

/// Bottom sheet untuk edit user
class UserEditBottomSheet extends StatefulWidget {
  final User user;

  const UserEditBottomSheet({Key? key, required this.user}) : super(key: key);

  @override
  State<UserEditBottomSheet> createState() => _UserEditBottomSheetState();
}

class _UserEditBottomSheetState extends State<UserEditBottomSheet> {
  // Controllers
  late TextEditingController namaController;
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  // State
  String selectedRole = 'peminjam';
  bool isActive = false;
  bool showPassword = false;

  @override
  void initState() {
    super.initState();
    // Inisialisasi dengan data user yang akan diedit
    namaController = TextEditingController(text: widget.user.namaLengkap);
    usernameController = TextEditingController(text: widget.user.username);
    passwordController = TextEditingController(text: widget.user.password);
    selectedRole = widget.user.role;
    isActive = widget.user.isActive;
  }

  @override
  void dispose() {
    namaController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// Tampilkan snackbar error (merah)
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.close, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Handler ketika tombol Simpan ditekan
  void _handleSimpan() {
    // Validasi menggunakan validator
    final validation = UserValidators.validateEditUserForm(
      namaLengkap: namaController.text,
      username: usernameController.text,
      password: passwordController.text,
      role: selectedRole,
    );

    // Jika validasi gagal, tampilkan error pertama
    if (!validation['isValid']) {
      _showErrorSnackbar(validation['firstError']);
      return;
    }

    // TODO: Update ke database
    final userData = {
      'id': widget.user.id,
      'nama_lengkap': namaController.text,
      'username': usernameController.text,
      'password': passwordController.text,
      'role': selectedRole,
      'is_active': isActive,
    };

    // Tutup bottom sheet dan return data
    Navigator.pop(context, userData);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          _buildForm(),
        ],
      ),
    );
  }

  /// Build Header
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Perbarui Data',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Perbarui data pengguna',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  /// Build Form
  Widget _buildForm() {
    return Flexible(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nama Lengkap
            _buildTextField(
              label: 'Nama Lengkap',
              controller: namaController,
              hint: 'Masukkan nama lengkap',
            ),
            const SizedBox(height: 16),

            // Username
            _buildTextField(
              label: 'Username',
              controller: usernameController,
              hint: 'Username akan digunakan untuk login',
            ),
            const SizedBox(height: 16),

            // Password
            _buildPasswordField(),
            const SizedBox(height: 16),

            // Role
            _buildRoleDropdown(),
            const SizedBox(height: 16),

            // Status
            _buildStatusSwitch(),
            const SizedBox(height: 24),

            // Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFFF8C42), width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Password*',
            style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: passwordController,
          obscureText: !showPassword,
          decoration: InputDecoration(
            hintText: 'Masukkan password minimal 8 karakter',
            hintStyle: TextStyle(color: Colors.grey[400]),
            suffixIcon: IconButton(
              icon:
                  Icon(showPassword ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => showPassword = !showPassword),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFFF8C42), width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Role pengguna',
            style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedRole,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFFF8C42), width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          items: const [
            DropdownMenuItem(value: 'admin', child: Text('Admin')),
            DropdownMenuItem(value: 'petugas', child: Text('Petugas')),
            DropdownMenuItem(value: 'peminjam', child: Text('Peminjam')),
          ],
          onChanged: (value) => setState(() => selectedRole = value!),
        ),
      ],
    );
  }

  Widget _buildStatusSwitch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Status pengguna',
            style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('Non Aktif'),
            const SizedBox(width: 12),
            Switch(
              value: isActive,
              activeColor: const Color(0xFFFF8C42),
              onChanged: (value) => setState(() => isActive = value),
            ),
            const SizedBox(width: 12),
            const Text('Aktif'),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: BorderSide(color: Colors.grey[400]!),
            ),
            child: const Text(
              'Batal',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _handleSimpan,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF8C42),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
            ),
            child: const Text(
              'Simpan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}