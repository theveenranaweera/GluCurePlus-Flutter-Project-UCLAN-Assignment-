import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:typeset/typeset.dart';
import 'package:glucure_plus/widgets/sugar_item_row_widget.dart';
import 'package:glucure_plus/screens/main_screens/constants_for_main_screens.dart';
import 'package:glucure_plus/services/firestore_service.dart';

/// Add an enum to represent different sorts:
enum SortOption {
  chronological,
  alphabetical,
  highestSugar,
}

class DashboardBody extends StatefulWidget {
  const DashboardBody({super.key});

  @override
  State<DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<DashboardBody> {

  // Keep track of which sorting strategy the user chose.
  SortOption _selectedSortOption = SortOption.chronological;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: SingleChildScrollView(
          child: StreamBuilder<double>(
            stream: FirestoreService().streamDailySugarGoal(),
            builder: (context, snapshotGoal) {
              if (!snapshotGoal.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final double dailyGoal = snapshotGoal.data!;
              return StreamBuilder<List<Map<String, dynamic>>>(
                stream: FirestoreService().streamAllLogs(),
                builder: (context, snapshotLogs) {
                  double totalSugar = 0.0;
                  List<Map<String, dynamic>> logs = [];

                  if (snapshotLogs.hasData) {
                    logs = snapshotLogs.data!;
                    // Sum up the sugar to compute the progress ring.
                    for (var log in logs) {
                      totalSugar += (log['sugarAmount'] as num).toDouble();
                    }
                  }

                  // Apply the chosen sort option to logs:
                  logs = _sortLogs(logs, _selectedSortOption);

                  // Calculate progress for the circle indicator.
                  double progress = totalSugar / dailyGoal;
                  if (progress > 1.0) progress = 1.0;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row: Title + "Today" button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TypeSet(
                            "Your *Sugar* Data",
                            style: kMainScreenHeadingText,
                          ),
                          TextButton.icon(
                            onPressed: () {
                              // (Optional) allow user to pick a day
                            },
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Colors.white,
                            ),
                            icon: const Icon(Iconsax.arrow_down_1,
                                color: Color(0xFF202020), size: 15),
                            label: const Text(
                              "Today",
                              style: TextStyle(
                                color: Color(0xFF202020),
                                fontFamily: 'Sans',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 13),

                      // Circular Progress Indicator
                      Container(
                        width: double.infinity,
                        height: 360,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: kDarkPurpleBgColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.center,
                        child: CircularPercentIndicator(
                          radius: 140.0,
                          lineWidth: 25.0,
                          animation: true,
                          percent: progress,
                          center: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(color: Colors.white),
                              children: [
                                TextSpan(
                                  text: "${totalSugar.toStringAsFixed(1)}g\n",
                                  style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Sans',
                                  ),
                                ),
                                TextSpan(
                                  text:
                                  "of ${dailyGoal.toStringAsFixed(1)}g",
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontFamily: 'Sans',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          progressColor: totalSugar > dailyGoal
                              ? kProgressBarExeedLimitColor
                              : kProgressBarCompleteColor,
                          backgroundColor: kProgressBarIncompleteColor,
                          circularStrokeCap: CircularStrokeCap.round,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Section header for sugar logs
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "SUGAR INTAKE",
                              style: kMainScreenSubHeadingText,
                            ),

                            /// Replace the IconButton with a PopupMenuButton
                            PopupMenuButton<String>(
                              icon: const Icon(Iconsax.more, color: Colors.black),
                              onSelected: (String value) {
                                switch (value) {
                                  case 'chronological':
                                    setState(() => _selectedSortOption = SortOption.chronological);
                                    break;
                                  case 'alphabetical':
                                    setState(() => _selectedSortOption = SortOption.alphabetical);
                                    break;
                                  case 'highestSugar':
                                    setState(() => _selectedSortOption = SortOption.highestSugar);
                                    break;
                                  case 'deleteAll':
                                    _showDeleteAllDialog(context);
                                    break;
                                  default:
                                    break;
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'chronological',
                                  child: Text('Sort Chronologically'),
                                ),
                                const PopupMenuItem(
                                  value: 'alphabetical',
                                  child: Text('Sort Alphabetically'),
                                ),
                                const PopupMenuItem(
                                  value: 'highestSugar',
                                  child: Text('Sort by Highest Sugar'),
                                ),
                                const PopupMenuDivider(),
                                const PopupMenuItem(
                                  value: 'deleteAll',
                                  child: Text('Delete All Logs'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // List of sugar logs
                      Container(
                        width: double.infinity,
                        padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: kLightPurpleBgColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: logs.isEmpty
                            ? const Center(child: Text("No sugar logs found."))
                            : ListView.builder(
                          reverse: true,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: logs.length,
                          itemBuilder: (context, index) {
                            final log = logs[index];
                            final productName = log['productName'];
                            final sugarAmount = log['sugarAmount'];
                            final docId = log['docId'];
                            return SugarItemRow(
                              docId: docId,
                              itemName: productName,
                              sugarGrams: sugarAmount,
                              onEdit: () {
                                _showEditDialog(
                                  context,
                                  docId,
                                  productName,
                                  sugarAmount,
                                );
                              },
                              onDelete: () async {
                                final bool? confirmed =
                                await showDialog<bool>(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Confirm Delete"),
                                      content: const Text(
                                          "Are you sure you want to delete this sugar log?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: const Text(
                                            "Delete",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                if (confirmed == true) {
                                  await FirestoreService().deleteSugarLog(
                                    docId: docId,
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text("Sugar log deleted."),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  // A helper method to apply the chosen sort option:
  List<Map<String, dynamic>> _sortLogs(
      List<Map<String, dynamic>> logs,
      SortOption sortOption,
      ) {
    switch (sortOption) {
      case SortOption.alphabetical:
        logs.sort((a, b) {
          final nameA = (a['productName'] ?? '').toString();
          final nameB = (b['productName'] ?? '').toString();
          return nameA.compareTo(nameB);
        });
        break;
      case SortOption.highestSugar:
        logs.sort((a, b) {
          final sugarA = (a['sugarAmount'] as num).toDouble();
          final sugarB = (b['sugarAmount'] as num).toDouble();
          // Descending order
          return sugarB.compareTo(sugarA);
        });
        break;
      case SortOption.chronological:
      default:
      // Firestore doesn't store a "date" in each document by default;
      // we do nothing, meaning logs appear in the order they come from Firestore.
        break;
    }
    return logs;
  }

  // Show a "Delete All" confirmation dialog
  void _showDeleteAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete All Logs"),
          content: const Text("Are you sure you want to delete all sugar logs?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await FirestoreService().deleteAllLogs();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("All logs deleted.")),
                  );
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error deleting logs: $e")),
                  );
                }
              },
              child: const Text(
                "Delete All",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, String docId, String currentName, double currentSugar) {
    final TextEditingController nameController = TextEditingController(text: currentName);
    final TextEditingController sugarController = TextEditingController(text: currentSugar.toString());
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Sugar Log"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Product Name"),
              ),
              TextField(
                controller: sugarController,
                decoration: const InputDecoration(labelText: "Sugar Amount (g)"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                String updatedName = nameController.text.trim();
                if (updatedName.isEmpty) {
                  updatedName = currentName;
                }
                final sugarText = sugarController.text.trim();
                final newSugar = double.tryParse(sugarText) ?? currentSugar;

                if (sugarText.contains('.')) {
                  final parts = sugarText.split('.');
                  if (parts.length > 1 && parts[1].length > 2) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter a sugar value with at most 2 decimal places.")),
                    );
                    return;
                  }
                }
                if (updatedName == currentName && newSugar == currentSugar) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("No changes made.")),
                  );
                  return;
                }
                try {
                  await FirestoreService().editSugarLog(
                    docId: docId,
                    productName: updatedName,
                    sugarAmount: newSugar,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Sugar log updated for $updatedName!")),
                  );
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error updating sugar log: $e")),
                  );
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
