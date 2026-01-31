import 'package:flutter/material.dart';
import '../../models/user.dart';

class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  const UserCard({
    Key? key,
    required this.user,
    required this.onEdit,
    required this.onDelete,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey(user.id), // ✅ Penting untuk performa realtime
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      // ✅ Opacity berbeda untuk user non-aktif
      child: Opacity(
        opacity: user.isActive ? 1.0 : 0.65,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 28,
                  backgroundColor: _getRoleColor().withOpacity(0.1),
                  child: Icon(
                    _getRoleIcon(),
                    color: _getRoleColor(),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Info User
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama Lengkap
                      Text(
                        user.namaLengkap,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      
                      // Username
                      Row(
                        children: [
                          Icon(
                            Icons.alternate_email,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              user.username,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      
                      // ✅ Badges: Role + Status
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          _buildRoleBadge(),
                          _buildStatusBadge(), // ✅ Status badge
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Action Menu
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20, color: Color(0xFFFB923C)),
                          SizedBox(width: 12),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            user.isActive ? Icons.block : Icons.check_circle,
                            size: 20,
                            color: user.isActive ? Colors.red : Colors.green,
                          ),
                          const SizedBox(width: 12),
                          Text(user.isActive ? 'Nonaktifkan' : 'Aktifkan'),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit();
                    } else if (value == 'delete') {
                      onDelete();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Badge untuk Role
  Widget _buildRoleBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _getRoleColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getRoleColor().withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getRoleIcon(),
            size: 12,
            color: _getRoleColor(),
          ),
          const SizedBox(width: 4),
          Text(
            _getRoleLabel(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _getRoleColor(),
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ Badge untuk Status (AKTIF / NON-AKTIF) - REALTIME
  Widget _buildStatusBadge() {
    final isActive = user.isActive;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive 
            ? Colors.green.withOpacity(0.1) 
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive 
              ? Colors.green.withOpacity(0.3) 
              : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? Icons.check_circle : Icons.cancel,
            size: 12,
            color: isActive ? Colors.green : Colors.grey[600],
          ),
          const SizedBox(width: 4),
          Text(
            isActive ? 'AKTIF' : 'NON-AKTIF',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.green : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor() {
    switch (user.role) {
      case 'admin':
        return Colors.purple;
      case 'petugas':
        return const Color(0xFFFB923C);
      case 'peminjam':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getRoleIcon() {
    switch (user.role) {
      case 'admin':
        return Icons.admin_panel_settings;
      case 'petugas':
        return Icons.work;
      case 'peminjam':
        return Icons.person;
      default:
        return Icons.person_outline;
    }
  }

  String _getRoleLabel() {
    switch (user.role) {
      case 'admin':
        return 'ADMIN';
      case 'petugas':
        return 'PETUGAS';
      case 'peminjam':
        return 'PEMINJAM';
      default:
        return user.role.toUpperCase();
    }
  }
}