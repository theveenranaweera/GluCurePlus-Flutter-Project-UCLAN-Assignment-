import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:typeset/typeset.dart';
import '../../widgets/sugar_item_row_widget.dart';
import 'constants_for_main_screens.dart';

class DashboardBody extends StatefulWidget {
  const DashboardBody({super.key});

  @override
  State<DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<DashboardBody> {
  @override
  Widget build(BuildContext context) {
    final double dailyGoal = 35.0;
    final double currentIntake = 27.0;
    final double progress = currentIntake / dailyGoal; // 0.7714...

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Profile avatar
                      GestureDetector(
                        onTap: () {
                          // functionality to go to profile page
                        },
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: const AssetImage(
                            'assets/images/default_profile_image.png',
                          ),
                        ),
                      ),

                      // Dark/Light Mode Icon or a "moon" icon?
                      IconButton(
                        onPressed: () {
                          // Possibly toggle dark/light theme in future
                        },
                        icon: const Icon(
                          Iconsax.moon,
                          size: 27,
                        ),
                        color: Colors.black54,
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // "Your Sugar Data"
                      TypeSet(
                        "Your *Sugar* Data",
                        style: kMainScreenHeadingText,
                      ),

                      // This could be a DropDownMenuButton
                      TextButton.icon(
                        onPressed: () {
                          // Show date range or day selection
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.white,
                        ),
                        icon: const Icon(
                          Iconsax.arrow_down_1,
                          color: Color(0xFF202020),
                          size: 15,
                        ),
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
                ],
              ),

              const SizedBox(height: 13),

              // Circular progress card
              Container(
                width: double.infinity,
                height: 360,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kDarkPurpleBgColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularPercentIndicator(
                      radius: 140.0,
                      lineWidth: 25.0,
                      animation: true,
                      percent: (progress > 1.0) ? 1.0 : progress,
                      center: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(color: Colors.white),
                          children: [
                            TextSpan(
                              text: "${currentIntake.toInt()}g\n",
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Sans',
                              ),
                            ),
                            TextSpan(
                              text: "of ${dailyGoal.toInt()}g",
                              style: const TextStyle(
                                fontSize: 22,
                                fontFamily: 'Sans',
                              ),
                            ),
                          ],
                        ),
                      ),
                      progressColor: kProgressBarCompleteColor,
                      backgroundColor: kProgressBarIncompleteColor,
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Daily sugar intake list
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "SUGAR INTAKE",
                      style: kMainScreenSubHeadingText,
                    ),
                    IconButton(
                      onPressed: () {
                        // maybe open advanced sugar log screen
                      },
                      icon: const Icon(Iconsax.more),
                      color: Colors.black,
                    ),
                  ],
                ),
              ),

              Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxHeight: 160),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: kLightPurpleBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: const [
                      SugarItemRow(
                        itemName: "KitKat Bar",
                        sugarGrams: 8,
                        timeString: "09:41",
                      ),
                      SugarItemRow(
                        itemName: "Banana",
                        sugarGrams: 12,
                        timeString: "11:33",
                      ),
                      SugarItemRow(
                        itemName: "Protein Bar",
                        sugarGrams: 7,
                        timeString: "15:00",
                      ),
                      SugarItemRow(
                        itemName: "Protein Bar",
                        sugarGrams: 7,
                        timeString: "15:00",
                      ),
                      SugarItemRow(
                        itemName: "Protein Bar",
                        sugarGrams: 7,
                        timeString: "15:00",
                      ),
                      SugarItemRow(
                        itemName: "Protein Bar",
                        sugarGrams: 7,
                        timeString: "15:00",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
