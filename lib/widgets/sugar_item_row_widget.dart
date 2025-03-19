import 'package:flutter/material.dart';

class SugarItemRow extends StatelessWidget {
  final String itemName;
  final int sugarGrams;

  const SugarItemRow({
    Key? key,
    required this.itemName,
    required this.sugarGrams,
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
            style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Sans'),
          ),
          Text(
            "$sugarGrams g",
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Sans'),

          ),
        ],
      ),
    );
  }
}
