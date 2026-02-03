import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityList extends StatelessWidget {
  final List<Map<String, String>> logs;

  const ActivityList({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(logs.length, (index) {
        final log = logs[index];
        return ActivityCard(log: log);
      }),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final Map<String, String> log;

  const ActivityCard({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(log["nama"] ?? "", style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(log["time"] ?? "", style: const TextStyle(color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 6),
        Text(log["desc"] ?? "", style: const TextStyle(color: Colors.black54)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            _badge(log["role"] ?? "", Colors.orange.shade100),
            if ((log["status"] ?? "").isNotEmpty)
              _badge(log["status"]!, _statusColor(log["status"]!)),
          ],
        ),
      ]),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case "Menunggu":
        return Colors.yellow.shade200;
      case "Dikembalikan":
        return Colors.green.shade200;
      case "Terlambat":
        return Colors.red.shade200;
      case "Dipinjam":
        return Colors.blue.shade200;
      default:
        return Colors.grey.shade200;
    }
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }
}
