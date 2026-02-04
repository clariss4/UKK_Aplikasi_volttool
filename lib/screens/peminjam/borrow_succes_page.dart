import 'package:flutter/material.dart';

class BorrowSuccessPage extends StatelessWidget {
  const BorrowSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle,
                size: 80, color: Colors.green),
            const SizedBox(height: 16),
            const Text(
              'Berhasil Mengajukan\nPeminjaman',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () =>
                  Navigator.popUntil(context, (r) => r.isFirst),
              child: const Text('Kembali ke Beranda'),
            )
          ],
        ),
      ),
    );
  }
}
