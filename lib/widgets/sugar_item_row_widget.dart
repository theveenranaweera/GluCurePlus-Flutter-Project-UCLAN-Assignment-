import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

/// A row widget displaying a product name, sugar amount, and edit/delete actions.
class SugarItemRow extends StatelessWidget {
  final String docId;
  final String itemName;
  final double sugarGrams;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SugarItemRow({
    Key? key,
    required this.docId,
    required this.itemName,
    required this.sugarGrams,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format sugar value: if whole, show without decimals; otherwise, show decimals.
    final String sugarText = (sugarGrams % 1 == 0)
        ? sugarGrams.toInt().toString()
        : sugarGrams.toString();

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 2, 0, 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            itemName,
            style: const TextStyle(color: Colors.black, fontSize: 19),
          ),
          Row(
            children: [
              Text(
                "$sugarText g",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 15),
              IconButton(
                icon: const Icon(Iconsax.edit, size: 20, color: Colors.black87),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Iconsax.trash, size: 20, color: Colors.red),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
