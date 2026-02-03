import 'package:flutter/material.dart';

class ConditionRadio extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const ConditionRadio({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pilih kondisi barang',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _radio('Baik', 0),
            _radio('Rusak', 1),
            _radio('Hilang', 2),
          ],
        ),
      ],
    );
  }

  Widget _radio(String label, int v) {
    return Row(
      children: [
        Radio<int>(
          value: v,
          groupValue: value,
          onChanged: (int? newValue) {
            if (newValue != null) onChanged(newValue);
          },
        ),
        Text(label),
      ],
    );
  }
}
