import 'package:apk_peminjaman/models/user.dart';
import 'package:apk_peminjaman/utils/validator.dart';
import 'package:flutter/material.dart';

enum UserFormMode { add, edit }

class UserFormDialog extends StatefulWidget {
  final UserFormMode mode;
  final User? user;

  const UserFormDialog({Key? key, required this.mode, this.user})
      : super(key: key);

  @override
  State<UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<UserFormDialog> {
  // Controllers
  late TextEditingController namaController;
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  // State
  String selectedRole = 'peminjam';
  bool isActive = false;
  bool showPassword = false;
  bool showConfirmPassword = false;

  @override
void initState() {
  super.initState();
  // Inisialisasi controller
  namaController = TextEditingController(text: widget.user?.namaLengkap ?? '');
  usernameController = TextEditingController(text: widget.user?.username ?? '');
  
  // Password tidak diisi saat edit, kosongkan
  passwordController = TextEditingController();
  confirmPasswordController = TextEditingController();
  
  selectedRole = widget.user?.role ?? 'peminjam';
  isActive = widget.user?.isActive ?? false;
}


  @override
  void dispose() {
    namaController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.close, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _handleSimpan() {
    // Validasi
    final validation = widget.mode == UserFormMode.add
        ? UserValidators.validateAddUserForm(
            namaLengkap: namaController.text,
            username: usernameController.text,
            password: passwordController.text,
            confirmPassword: confirmPasswordController.text,
            role: selectedRole,
          )
        : UserValidators.validateEditUserForm(
            namaLengkap: namaController.text,
            username: usernameController.text,
            password: passwordController.text,
            role: selectedRole,
          );

    if (!validation['isValid']) {
      _showErrorSnackbar(validation['firstError']);
      return;
    }

    // Return data
    final userData = {
      'id': widget.user?.id ?? DateTime.now().toString(),
      'nama_lengkap': namaController.text,
      'username': usernameController.text,
      'password': passwordController.text,
      'role': selectedRole,
      'is_active': isActive,
    };

    Navigator.pop(context, userData);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.mode == UserFormMode.add ? 'Tambah Pengguna' : 'Edit Pengguna',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              widget.mode == UserFormMode.add
                  ? 'Tambahkan pengguna baru'
                  : 'Perbarui data pengguna',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            _buildTextField('Nama Lengkap', namaController, 'Masukkan nama lengkap'),
            const SizedBox(height: 16),
            _buildTextField('Username', usernameController, 'Username untuk login'),
            const SizedBox(height: 16),
            _buildPasswordField('Password*', passwordController, showPassword,
                () => setState(() => showPassword = !showPassword)),
            if (widget.mode == UserFormMode.add) ...[
              const SizedBox(height: 16),
              _buildPasswordField('Konfirmasi Password*', confirmPasswordController,
                  showConfirmPassword, () => setState(() => showConfirmPassword = !showConfirmPassword),
                  hint: 'Masukkan password ulang'),
            ],
            const SizedBox(height: 16),
            _buildRoleDropdown(),
            const SizedBox(height: 16),
            _buildStatusSwitch(),
            const SizedBox(height: 32),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint) {
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
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFFF8C42), width: 2)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller,
      bool obscureText, VoidCallback onToggle,
      {String hint = 'Masukkan password minimal 8 karakter'}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            suffixIcon: IconButton(
              icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
              onPressed: onToggle,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFFF8C42), width: 2)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Role pengguna', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedRole,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFFF8C42), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
        const Text('Status pengguna', style: TextStyle(fontWeight: FontWeight.w600)),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              side: BorderSide(color: Colors.grey[400]!),
            ),
            child: const Text('Batal', style: TextStyle(fontSize: 16, color: Colors.black)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _handleSimpan,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF8C42),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 2,
            ),
            child: const Text('Simpan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}
