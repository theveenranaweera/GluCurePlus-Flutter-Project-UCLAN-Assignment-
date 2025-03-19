import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:typeset/typeset.dart';
import 'package:glucure_plus/widgets/sugar_item_row_widget.dart';
import 'package:glucure_plus/screens/main_screens/constants_for_main_screens.dart';
import 'package:glucure_plus/services/firestore_service.dart';

class DashboardBody extends StatefulWidget {
  const DashboardBody({super.key});

  @override
  State<DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<DashboardBody> {
  final double dailyGoal = 35.0; // Your daily sugar target

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: SingleChildScrollView(
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: FirestoreService().streamAllLogs(), // Real-time stream of sugar logs
            builder: (context, snapshot) {
              double totalSugar = 0.0;
              List<Map<String, dynamic>> logs = [];
              if (snapshot.hasData) {
                logs = snapshot.data!;
                // Sum up the sugar amounts
                for (var log in logs) {
                  totalSugar += (log['sugarAmount'] as num).toDouble();
                }
              }
              // Calculate progress percentage
              double progress = totalSugar / dailyGoal;
              if (progress > 1.0) {
                progress = 1.0;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row: Title and a "Today" button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TypeSet("Your *Sugar* Data", style: kMainScreenHeadingText),
                      TextButton.icon(
                        onPressed: () {
                          // Optional: allow user to change day
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.white,
                        ),
                        icon: const Icon(Iconsax.arrow_down_1, color: Color(0xFF202020), size: 15),
                        label: const Text("Today", style: TextStyle(color: Color(0xFF202020), fontFamily: 'Sans')),
                      ),
                    ],
                  ),
                  const SizedBox(height: 13),
                  // Circular Progress Indicator showing total sugar intake vs daily goal
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
                              text: "${totalSugar}g\n",
                              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, fontFamily: 'Sans'),
                            ),
                            TextSpan(
                              text: "of ${dailyGoal}g",
                              style: const TextStyle(fontSize: 22, fontFamily: 'Sans'),
                            ),
                          ],
                        ),
                      ),
                      progressColor: totalSugar > dailyGoal ? kProgressBarExeedLimitColor : kProgressBarCompleteColor,
                      backgroundColor: kProgressBarIncompleteColor,
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Section header for Sugar Intake logs list
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("SUGAR INTAKE", style: kMainScreenSubHeadingText),
                        IconButton(
                          onPressed: () {
                            // Delete ALL logs at once
                          },
                          icon: const Icon(Iconsax.more),
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  // Container displaying a list of sugar logs
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: kLightPurpleBgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: logs.isEmpty
                        ? const Center(child: Text("No sugar logs found."))
                        : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: logs.length,
                      itemBuilder: (context, index) {
                        final log = logs[index];
                        final productName = log['productName'];
                        final sugarAmount = log['sugarAmount'];
                        return SugarItemRow(
                          itemName: productName,
                          sugarGrams: sugarAmount,
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
