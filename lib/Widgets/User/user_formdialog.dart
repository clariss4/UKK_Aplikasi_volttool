import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../controllers/user_controller.dart';
import 'form_fields/user_text_field.dart';
import 'form_fields/user_password_field.dart';
import 'form_fields/user_role_dropdown.dart';
import 'form_fields/user_status_switch.dart';
import 'form_fields/form_action_button.dart';

enum UserFormMode { add, edit }

class UserFormDialog extends StatefulWidget {
  final UserFormMode mode;
  final User? user;
  final UserController controller;

  const UserFormDialog({
    Key? key,
    required this.mode,
    this.user,
    required this.controller,
  }) : super(key: key);

  @override
  State<UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<UserFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController namaController;
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  String selectedRole = 'peminjam';
  bool isActive = true;
  bool showPassword = false;
  bool showConfirmPassword = false;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(
      text: widget.user?.namaLengkap ?? '',
    );
    usernameController = TextEditingController(
      text: widget.user?.username ?? '',
    );
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    if (widget.user != null) {
      selectedRole = widget.user!.role;
      isActive = widget.user!.isActive;
    } else {
      selectedRole = 'peminjam';
      isActive = true;
    }
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

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _handleSimpan() async {
    setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);

    if (!_formKey.currentState!.validate()) {
      _showErrorSnackbar('Mohon perbaiki kesalahan pada form');
      return;
    }

    if (widget.mode == UserFormMode.add) {
      if (passwordController.text != confirmPasswordController.text) {
        _showErrorSnackbar('Password dan konfirmasi password tidak sama');
        return;
      }
    }

    final usernameExists = await widget.controller.isUsernameExists(
      usernameController.text.trim(),
      excludeId: widget.user?.id,
    );

    if (usernameExists) {
      _showErrorSnackbar('Username sudah digunakan');
      return;
    }

    setState(() => _isSaving = true);

    try {
      final userData = <String, dynamic>{
        'nama_lengkap': namaController.text.trim(),
        'username': usernameController.text.trim(),
        'role': selectedRole,
        'is_active': isActive,
      };

      if (passwordController.text.isNotEmpty) {
        userData['password'] = passwordController.text;
      }

      if (widget.mode == UserFormMode.add) {
        await widget.controller.insertUser(userData);
      } else {
        await widget.controller.updateUser(widget.user!.id, userData);
      }

      if (!mounted) return;

      // ✅ RETURN TRUE
      Navigator.pop(context, true);

      _showSuccessSnackbar(
        widget.mode == UserFormMode.add
            ? 'Berhasil menambahkan pengguna baru'
            : 'Berhasil memperbarui pengguna',
      );
    } catch (e) {
      if (!mounted) return;

      setState(() => _isSaving = false);

      _showErrorSnackbar(e.toString().replaceAll('Exception: ', ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: AbsorbPointer(
        absorbing: _isSaving,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            autovalidateMode: _autovalidateMode,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.mode == UserFormMode.add
                      ? 'Tambah Pengguna'
                      : 'Edit Pengguna',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.mode == UserFormMode.add
                      ? 'Tambahkan pengguna baru'
                      : 'Perbarui data pengguna',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),

                UserTextField(
                  label: 'Nama Lengkap',
                  controller: namaController,
                  hint: 'Masukkan nama lengkap',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama lengkap tidak boleh kosong';
                    }
                    if (value.trim().length < 3) {
                      return 'Nama lengkap minimal 3 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                UserTextField(
                  label: 'Username',
                  controller: usernameController,
                  hint: 'Username untuk login',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Username tidak boleh kosong';
                    }
                    if (value.trim().length < 4) {
                      return 'Username minimal 4 karakter';
                    }
                    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                      return 'Username hanya boleh huruf, angka, dan underscore';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                UserPasswordField(
                  label: widget.mode == UserFormMode.add
                      ? 'Password'
                      : 'Password (Opsional)',
                  controller: passwordController,
                  obscureText: showPassword,
                  onToggle: () => setState(() => showPassword = !showPassword),
                  hint: widget.mode == UserFormMode.edit
                      ? 'Kosongkan jika tidak ingin mengubah password'
                      : 'Masukkan password minimal 8 karakter',
                  validator: (value) {
                    if (widget.mode == UserFormMode.add) {
                      if (value == null || value.isEmpty) {
                        return 'Password tidak boleh kosong';
                      }
                      if (value.length < 8) {
                        return 'Password minimal 8 karakter';
                      }
                    } else {
                      if (value != null &&
                          value.isNotEmpty &&
                          value.length < 8) {
                        return 'Password minimal 8 karakter';
                      }
                    }
                    return null;
                  },
                ),

                if (widget.mode == UserFormMode.add) ...[
                  const SizedBox(height: 16),
                  UserPasswordField(
                    label: 'Konfirmasi Password',
                    controller: confirmPasswordController,
                    obscureText: showConfirmPassword,
                    onToggle: () => setState(
                      () => showConfirmPassword = !showConfirmPassword,
                    ),
                    hint: 'Masukkan password ulang',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Konfirmasi password tidak boleh kosong';
                      }
                      if (value != passwordController.text) {
                        return 'Password tidak sama';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 16),

                UserRoleDropdown(
                  selectedRole: selectedRole,
                  onChanged: (value) => setState(() => selectedRole = value!),
                ),
                const SizedBox(height: 16),

                UserStatusSwitch(
                  isActive: isActive,
                  onChanged: (value) => setState(() => isActive = value),
                ),
                const SizedBox(height: 32),

                FormActionButtons(
                  isSaving: _isSaving,
                  onCancel: () => Navigator.pop(context),
                  onSave: _handleSimpan,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
