/// Fungsi-fungsi validasi untuk form pengguna
class UserValidators {
  /// Validasi nama lengkap
  /// Return: null jika valid, string error jika tidak valid
  static String? validateNamaLengkap(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama lengkap harus diisi';
    }
    if (value.trim().length < 3) {
      return 'Nama lengkap minimal 3 karakter';
    }
    return null;
  }

  /// Validasi username
  /// Return: null jika valid, string error jika tidak valid
  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username harus diisi';
    }
    if (value.trim().length < 4) {
      return 'Username minimal 4 karakter';
    }
    // Cek apakah hanya mengandung huruf, angka, underscore, dan titik
    final validChars = RegExp(r'^[a-zA-Z0-9_.]+$');
    if (!validChars.hasMatch(value.trim())) {
      return 'Username hanya boleh berisi huruf, angka, underscore, dan titik';
    }
    return null;
  }

  /// Validasi password
  /// Return: null jika valid, string error jika tidak valid
  static String? validatePassword(String? value, {bool isRequired = true}) {
    if (isRequired) {
      if (value == null || value.isEmpty) {
        return 'Password harus diisi';
      }
    } else {
      // Jika tidak required dan kosong, return null (valid)
      if (value == null || value.isEmpty) {
        return null;
      }
    }

    if (value!.length < 8) {
      return 'Password minimal 8 karakter';
    }
    return null;
  }

  /// Validasi konfirmasi password
  /// Return: null jika valid, string error jika tidak valid
  static String? validateConfirmPassword(
    String? password,
    String? confirmPassword,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Konfirmasi password harus diisi';
    }
    if (password != confirmPassword) {
      return 'Password tidak cocok';
    }
    return null;
  }

  /// Validasi role
  /// Return: null jika valid, string error jika tidak valid
  static String? validateRole(String? value) {
    if (value == null || value.isEmpty) {
      return 'Role harus dipilih';
    }
    final validRoles = ['admin', 'petugas', 'peminjam'];
    if (!validRoles.contains(value)) {
      return 'Role tidak valid';
    }
    return null;
  }

  /// Check apakah form valid (untuk form tambah user)
  /// Return: Map dengan status dan pesan error
  static Map<String, dynamic> validateAddUserForm({
    required String namaLengkap,
    required String username,
    required String password,
    required String confirmPassword,
    required String role,
  }) {
    final errors = <String, String>{};

    final namaError = validateNamaLengkap(namaLengkap);
    if (namaError != null) errors['nama'] = namaError;

    final usernameError = validateUsername(username);
    if (usernameError != null) errors['username'] = usernameError;

    final passwordError = validatePassword(password);
    if (passwordError != null) errors['password'] = passwordError;

    final confirmError = validateConfirmPassword(password, confirmPassword);
    if (confirmError != null) errors['confirm'] = confirmError;

    final roleError = validateRole(role);
    if (roleError != null) errors['role'] = roleError;

    return {
      'isValid': errors.isEmpty,
      'errors': errors,
      'firstError': errors.isNotEmpty ? errors.values.first : null,
    };
  }

  /// Check apakah form valid (untuk form edit user)
  /// Return: Map dengan status dan pesan error
  static Map<String, dynamic> validateEditUserForm({
    required String namaLengkap,
    required String username,
    required String password,
    required String role,
  }) {
    final errors = <String, String>{};

    final namaError = validateNamaLengkap(namaLengkap);
    if (namaError != null) errors['nama'] = namaError;

    final usernameError = validateUsername(username);
    if (usernameError != null) errors['username'] = usernameError;

    // Password tidak required untuk edit, tapi jika diisi harus valid
    final passwordError = validatePassword(password, isRequired: false);
    if (passwordError != null) errors['password'] = passwordError;

    final roleError = validateRole(role);
    if (roleError != null) errors['role'] = roleError;

    return {
      'isValid': errors.isEmpty,
      'errors': errors,
      'firstError': errors.isNotEmpty ? errors.values.first : null,
    };
  }
}