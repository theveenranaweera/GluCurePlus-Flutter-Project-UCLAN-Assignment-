import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:glucure_plus/widgets/custom_notch_nav_bar_widget.dart';
import 'package:glucure_plus/screens/main_screens/dashboard_body.dart';
import 'package:glucure_plus/screens/main_screens/add_sugar/add_sugar_screen.dart';
import 'package:glucure_plus/screens/main_screens/constants_for_main_screens.dart';

class DashboardScreen extends StatefulWidget {
  static const String navID = 'dashboard_screen';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Controllers for your notch bottom bar + page view
  final NotchBottomBarController _controller = NotchBottomBarController(index: 0);
  final PageController _pageController = PageController(initialPage: 0);

  // Track which tab is active
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Our three tab views: Dashboard, AddSugar, Settings
  late final List<Widget> _navPages = [
    DashboardBody(), // The "Home" tab
    AddSugarScreen(), // The "Add" tab
    const Center(
      child: Text(
        "Settings Page",
        style: TextStyle(fontSize: 24),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kOffWhiteBgColor,

      // A PageView for swiping or direct jumps via bottom nav
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // No swipe, only nav
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _navPages,
      ),

      // A custom bottom nav bar using your existing AnimatedNotchBottomBar setup
      bottomNavigationBar: CustomNotchNavBar(
        controller: _controller,
        pageController: _pageController,
        bottomBarItems: [
          BottomBarItem(
            inActiveItem: const Icon(Iconsax.home, color: Colors.grey),
            activeItem: const Icon(Iconsax.home_15, color: Colors.white),
            itemLabel: 'Home',
          ),
          BottomBarItem(
            inActiveItem: const Icon(Iconsax.add, color: Colors.grey),
            activeItem: const Icon(Iconsax.add5, color: Colors.white),
            itemLabel: 'Add',
          ),
          BottomBarItem(
            inActiveItem: const Icon(Iconsax.setting_2, color: Colors.grey),
            activeItem: const Icon(Iconsax.setting_21, color: Colors.white),
            itemLabel: 'Settings',
          ),
        ],
        barColor: kNavBarBgColor,
        notchColor: kNavBarBgColor,
        showLabel: true,
        kBottomRadius: 28.0,
        kIconSize: 24.0,
        bottomBarWidth: MediaQuery.of(context).size.width,
      ),
    );
  }
}
