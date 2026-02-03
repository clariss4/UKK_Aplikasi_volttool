import 'package:flutter/material.dart';

class RequestFilter extends StatelessWidget {
  final String selectedValue;
  final ValueChanged<String> onChanged;

  const RequestFilter({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: DropdownButton<String>(
        value: selectedValue,
        isExpanded: true,
        underline: const SizedBox(),
        icon: const Icon(Icons.keyboard_arrow_down),
        items: const [
          DropdownMenuItem(value: 'Dipinjam', child: Text('Dipinjam')),
          DropdownMenuItem(value: 'Disetujui', child: Text('Disetujui')),
        ],
        onChanged: (val) {
          if (val != null) onChanged(val);
        },
      ),
    );
  }
}
