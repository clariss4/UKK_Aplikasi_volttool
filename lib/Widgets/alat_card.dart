// ==================== FILE: lib/widgets/alat_card.dart ====================

import 'package:flutter/material.dart';
import '../models/alat.dart';
import '../services/database_service.dart';

class AlatCard extends StatelessWidget {
  final Alat alat;
  final VoidCallback onEdit;

  const AlatCard({
    Key? key,
    required this.alat,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: alat.fotoUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  alat.fotoUrl!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                ),
              )
            : const Icon(Icons.build, size: 40),
        title: Text(
          alat.nama,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Stok: ${alat.stokTersedia}/${alat.stokTotal}'),
            Text('Kondisi: ${alat.kondisi[0].toUpperCase()}${alat.kondisi.substring(1)}'),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: const Text('Edit'),
              onTap: onEdit,
            ),
            PopupMenuItem(
              value: 'delete',
              child: const Text('Hapus'),
              onTap: () => _confirmDelete(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: Text('Hapus alat "${alat.nama}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      try {
        await DatabaseService().deleteAlat(alat.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Alat berhasil dihapus'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}