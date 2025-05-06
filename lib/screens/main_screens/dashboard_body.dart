/// A widget representing the main content of the dashboard screen:
/// - A progress ring showing total sugar vs. daily goal
/// - A list of sugar logs for a chosen date, with sorting options
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:typeset/typeset.dart';
import 'package:glucure_plus/widgets/sugar_item_row_widget.dart';
import 'package:glucure_plus/screens/main_screens/constants_for_main_screens.dart';
import 'package:glucure_plus/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glucure_plus/services/local_storage_service.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// Enum to represent different sorting strategies for sugar logs.
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
  // Tracks which sorting strategy is selected.
  SortOption _selectedSortOption = SortOption.chronological;

  // Which date's logs are being displayed.
  String? _selectedDate;

  // List of all available date strings from Firestore.
  List<String> _availableDates = [];

  // Local storage service to persist the user's sorting preference.
  late LocalStorageService _localStorageService;

  // Controls whether the loading spinner (ModalProgressHUD) is displayed.
  bool _isLoading = false;

  // Timer that fires periodically to detect when the system date has rolled over
  Timer? _midnightWatcher;

  // Stores the last “today” date string (formatted yyyy-MM-dd);
  // used to compare each minute
  String _lastDateString = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _localStorageService = LocalStorageService(); // Initialize our local storage helper

    // Load any saved sort preference and available dates
    _loadSortPreference();
    _loadAvailableDates();

    _startMidnightWatcher(); // Start a timer that checks every minute if the date has rolled over
  }

  @override
  void dispose() {
    _midnightWatcher?.cancel(); // Stop the timer when this widget goes away to avoid leaks
    super.dispose();
  }

  // Loads the saved sort preference (chronological, alphabetical, etc.) from local storage.
  Future<void> _loadSortPreference() async {
    final savedSortOption = await _localStorageService.getSortPreference();
    setState(() {
      _selectedSortOption = savedSortOption;
    });
  }

  // Retrieves all date documents from Firestore, then sets _selectedDate.
  Future<void> _loadAvailableDates() async {
    setState(() {
      _isLoading = true;
    });

    final dates = await FirestoreService().getAvailableDates();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Ensure today is always present so the dropdown can select it.
    if (!dates.contains(today)) {
      dates.insert(0, today);
    }

    setState(() {
      _availableDates = dates;
      // Default to today if it exists, otherwise first in the list or today.
      if (_availableDates.contains(today)) {
        _selectedDate = today;
      } else if (_availableDates.isNotEmpty) {
        _selectedDate = _availableDates.first;
      } else {
        _selectedDate = today; // fallback if empty
      }
      _isLoading = false;
    });
  }

  /// Starts a periodic timer that checks once a minute whether
  /// the calendar date (yyyy-MM-dd) has changed. If it has,
  /// then we reload our list of available dates.
  void _startMidnightWatcher() {
    // Duration of one minute
    final oneMinute = const Duration(minutes: 1);

    // Schedule a callback every minute
    _midnightWatcher = Timer.periodic(oneMinute, (Timer timer) {
      // Get the current date as a string, e.g. "2025-05-06"
      final todayString = DateFormat('yyyy-MM-dd').format(DateTime.now());

      // If the date has changed since last check...
      if (todayString != _lastDateString) {
        // Update our stored date
        _lastDateString = todayString;

        // Refresh any UI or data that depends on “today”
        _loadAvailableDates();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // If _selectedDate is null, likely still loading the available dates.
    // We'll show a spinner in that case.
    final bool noSelectedDate = (_selectedDate == null);

    return ModalProgressHUD(
      color: Colors.black,
      inAsyncCall: _isLoading || noSelectedDate,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: _selectedDate == null
              ? const SizedBox.shrink() : _buildMainContent(),
        ),
      ),
    );
  }

  // Builds the main content widgets (progress ring + sugar logs) once _selectedDate is available.
  Widget _buildMainContent() {
    return StreamBuilder<double>(
      stream: FirestoreService().streamDailySugarGoalForDay(_selectedDate!),
      builder: (context, snapshotGoal) {
        if (!snapshotGoal.hasData) {
          // We rely on the ModalProgressHUD to show loading; empty container here
          return const SizedBox.shrink();
        }

        final dailyGoal = snapshotGoal.data!;
        return StreamBuilder<List<Map<String, dynamic>>>(
          stream: FirestoreService().streamLogsForDay(_selectedDate!),
          builder: (context, snapshotLogs) {
            if (!snapshotLogs.hasData) {
              // this also rely on ModalProgressHUD
              return const SizedBox.shrink();
            }

            final logs = snapshotLogs.data ?? [];
            double totalSugar = 0.0;
            for (var log in logs) {
              totalSugar += (log['sugarAmount'] as num).toDouble();
            }

            // Apply the chosen sort option
            final sortedLogs = _sortLogs(logs, _selectedSortOption);

            // Calculate progress for the circle indicator
            final progress = (totalSugar / dailyGoal).clamp(0.0, 1.0); // Ensures value stays between 0.0 and 1.0

            final String todayString = DateFormat('yyyy-MM-dd').format(DateTime.now());
            final bool canEdit = (_selectedDate == todayString);

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TypeSet(
                        "Your *Sugar* Data",
                        style: kMainScreenHeadingText,
                      ),
                      _buildDateDropdown(),
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
                              text: "of ${dailyGoal.toStringAsFixed(1)}g",
                              style: const TextStyle(
                                fontSize: 22,
                                fontFamily: 'Sans',
                              ),
                            ),
                          ],
                        ),
                      ),
                      progressColor: totalSugar > dailyGoal
                          ? kProgressBarExeedLimitColor : kProgressBarCompleteColor,
                      backgroundColor: kProgressBarIncompleteColor,
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "SUGAR INTAKE",
                          style: kMainScreenSubHeadingText,
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(Iconsax.more, color: Colors.black),
                          color: Colors.white,
                          onSelected: (value) {
                            switch (value) {
                              case 'chronological':
                                setState(() {
                                  _selectedSortOption = SortOption.chronological;
                                });
                                break;
                              case 'alphabetical':
                                setState(() {
                                  _selectedSortOption = SortOption.alphabetical;
                                });
                                break;
                              case 'highestSugar':
                                setState(() {
                                  _selectedSortOption = SortOption.highestSugar;
                                });
                                break;
                              case 'deleteAll':
                                _showDeleteAllDialog();
                                break;
                              default:
                                break;
                            }
                            // Persist the chosen sort option
                            _localStorageService.setSortPreference(_selectedSortOption);
                          },
                          itemBuilder: (context) {
                            final List<PopupMenuEntry<String>> items = [
                              const PopupMenuItem<String>(
                                value: 'chronological',
                                child: Text(
                                  'Sort Chronologically',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'alphabetical',
                                child: Text(
                                  'Sort Alphabetically',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'highestSugar',
                                child: Text(
                                  'Sort by Highest Sugar',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              const PopupMenuDivider(),
                            ];

                            if (canEdit) {
                              items.add(
                                const PopupMenuItem<String>(
                                  value: 'deleteAll',
                                  child: Text(
                                    'Delete All Logs',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              );
                            }

                            return items;
                          },
                        ),
                      ],
                    ),
                  ),

                  // Logs List
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: kLightPurpleBgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: sortedLogs.isEmpty
                        ? const Center(child: Text("No sugar logs found.")) : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: sortedLogs.length,
                      itemBuilder: (context, index) {
                        final log = sortedLogs[index];
                        final productName = log['productName'];
                        final sugarAmount = (log['sugarAmount'] as num).toDouble();
                        final docId = log['docId'];

                        return SugarItemRow(
                          docId: docId,
                          itemName: productName,
                          sugarGrams: sugarAmount,
                          canEdit: canEdit,
                          onEdit: () {
                            _showEditDialog(docId, productName, sugarAmount);
                          },
                          onDelete: () {
                            _handleDeleteLog(docId);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Builds the dropdown for selecting a date to view logs.
  Widget _buildDateDropdown() {
    return DropdownButton<String>(
      value: _selectedDate,
      onChanged: (newVal) {
        setState(() {
          _selectedDate = newVal;
        });
      },
      style: const TextStyle(color: Colors.black),
      dropdownColor: Colors.white,
      iconEnabledColor: Colors.black,
      items: _availableDates.map((dateStr) {
        return DropdownMenuItem(
          value: dateStr,
          child: Text(
            dateStr,
            style: const TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
    );
  }

  // Sorts the logs based on the selected [SortOption].
  List<Map<String, dynamic>> _sortLogs(List<Map<String, dynamic>> logs, SortOption sortOption) {
    final sorted = List<Map<String, dynamic>>.from(logs);

    switch (sortOption) {
      case SortOption.alphabetical:
        sorted.sort((a, b) {
          final nameA = (a['productName'] ?? '').toString().toLowerCase();
          final nameB = (b['productName'] ?? '').toString().toLowerCase();
          return nameA.compareTo(nameB);
        });
        break;

      case SortOption.highestSugar:
        sorted.sort((a, b) {
          final sugarA = (a['sugarAmount'] as num).toDouble();
          final sugarB = (b['sugarAmount'] as num).toDouble();
          return sugarB.compareTo(sugarA); // Descending
        });
        break;

      case SortOption.chronological:
      default:
      // Sort logs by timestamp ascending.
        sorted.sort((a, b) {
          final aTime = _parseTimestamp(a['timestamp']);
          final bTime = _parseTimestamp(b['timestamp']);
          return aTime.compareTo(bTime);
        });
        break;
    }
    return sorted;
  }

  // Helper function to parse a Firestore timestamp-like object into a [DateTime].
  DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp == null) {
      return DateTime(1970);
    }
    if (timestamp is DateTime) {
      return timestamp;
    }
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    }
    throw Exception('Unsupported timestamp type: $timestamp');
  }

  // Shows a dialog to confirm deleting all logs for the current date.
  void _showDeleteAllDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete All Logs"),
          content: const Text("Are you sure you want to delete all sugar logs?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await FirestoreService().deleteAllLogsForDay(_selectedDate!);
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

  // Opens a confirmation dialog to delete a single sugar log.
  Future<void> _handleDeleteLog(String docId) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this sugar log?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
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
      await FirestoreService().deleteSugarLogForDay(
        dateString: _selectedDate!,
        docId: docId,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sugar log deleted.")),
      );
    }
  }

  // Displays an edit dialog to update a single sugar log (product name/sugar).
  void _showEditDialog(String docId, String currentName, double currentSugar) {
    final nameController = TextEditingController(text: currentName);
    final sugarController = TextEditingController(text: currentSugar.toString());

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
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final updatedName = nameController.text.trim().isEmpty
                    ? currentName : nameController.text.trim();

                final sugarText = sugarController.text.trim();
                final newSugar = double.tryParse(sugarText) ?? currentSugar;

                // Basic validation for decimal places
                if (sugarText.contains('.')) {
                  final parts = sugarText.split('.');
                  if (parts.length > 1 && parts[1].length > 2) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter sugar value with at most 2 decimal places."),
                      ),
                    );
                    return;
                  }
                }

                if (newSugar <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Sugar amount must be greater than 0.")),
                  );
                  return;
                }
                if (updatedName == currentName && newSugar == currentSugar) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("No changes made.")),
                  );
                  return;
                }

                try {
                  await FirestoreService().editSugarLogForDay(
                    dateString: _selectedDate!,
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
