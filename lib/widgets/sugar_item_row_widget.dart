import 'package:flutter/material.dart';

class SugarItemRow extends StatelessWidget {
  final String itemName;
  final int sugarGrams;
  final String timeString;

  const SugarItemRow({
    Key? key,
    required this.itemName,
    required this.sugarGrams,
    required this.timeString,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Slight spacing between items
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            itemName,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
          Text(
            "$sugarGrams g [$timeString]",
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
