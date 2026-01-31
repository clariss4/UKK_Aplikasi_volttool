import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../controllers/user_controller.dart';
import 'user_card.dart';

class UserListView extends StatefulWidget {
  final UserController controller;
  final String searchQuery;
  final String selectedRole;
  final Function(User) onEdit;
  final Function(User) onDelete;

  const UserListView({
    Key? key,
    required this.controller,
    required this.searchQuery,
    required this.selectedRole,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<UserListView> createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  // Track loading state untuk operasi CRUD
  final Set<String> _loadingUsers = {};

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<User>>(
      stream: widget.controller.streamUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFB923C)),
            ),
          );
        }

        if (snapshot.hasError) {
          return _buildErrorState(snapshot.error.toString());
        }

        final users = snapshot.data ?? [];
        final filtered = _filterUsers(users);

        if (filtered.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final user = filtered[index];
            final isLoading = _loadingUsers.contains(user.id);
            
            return Stack(
              children: [
                UserCard(
                  key: ValueKey(user.id),
                  user: user,
                  onEdit: () => _handleEdit(user),
                  onDelete: () => _handleDelete(user),
                ),
                // Overlay loading untuk user yang sedang diproses
                if (isLoading)
                  Positioned.fill(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFB923C)),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  void _handleEdit(User user) async {
    setState(() => _loadingUsers.add(user.id));
    try {
      await widget.onEdit(user);
    } finally {
      if (mounted) {
        setState(() => _loadingUsers.remove(user.id));
      }
    }
  }

  void _handleDelete(User user) async {
    setState(() => _loadingUsers.add(user.id));
    try {
      await widget.onDelete(user);
    } finally {
      if (mounted) {
        setState(() => _loadingUsers.remove(user.id));
      }
    }
  }

  List<User> _filterUsers(List<User> users) {
    return users.where((u) {
      if (u.role != widget.selectedRole) return false;

      if (widget.searchQuery.isNotEmpty) {
        final q = widget.searchQuery.toLowerCase();
        return u.namaLengkap.toLowerCase().contains(q) ||
            u.username.toLowerCase().contains(q);
      }
      return true;
    }).toList();
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            'Terjadi kesalahan',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            widget.searchQuery.isEmpty
                ? 'Tidak ada pengguna'
                : 'Pengguna tidak ditemukan',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          if (widget.searchQuery.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Coba kata kunci lain',
              style: TextStyle(fontSize: 13, color: Colors.grey[500]),
            ),
          ],
        ],
      ),
    );
  }
}