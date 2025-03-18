import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:glucure_plus/widgets/custom_notch_nav_bar_widget.dart';
import 'package:glucure_plus/screens/main_screens/dashboard_body.dart';
import 'package:glucure_plus/screens/main_screens/add_sugar/add_sugar_screen.dart';
import 'package:glucure_plus/screens/main_screens/constants_for_main_screens.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardPage extends StatefulWidget {
  static const String navID = 'dashboard_screen';

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  late User loggedInUser;

  void getCurrentUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  /// The controller for the NotchBottomBar
  final NotchBottomBarController _controller = NotchBottomBarController(index: 0);

  /// The controller for the PageView
  final PageController _pageController = PageController(initialPage: 0);

  /// The current index for the bottom bar (which page is selected)
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// We store the screens for each tab in this list.
  late final List<Widget> _navPages = [
    // -- Tab 0: The main Dashboard content
    DashboardBody(),

    // -- Tab 1: Add Sugar Page
    AddSugarScreen(),

    // -- Tab 2: Settings page
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

      /// Wrap multiple pages in a PageView to jump via the bottom bar
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        // so it only changes via the nav bar, not by swiping
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _navPages,
      ),

      /// Use your CustomNotchNavBar at the bottom
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

        // Handle taps using animateToPage
        // onTap: (index) {
        //   _pageController.animateToPage(
        //     index,
        //     duration: const Duration(milliseconds: 300), // Smooth animation
        //     curve: Curves.easeInOut, // Ease-in-out effect
        //   );
        // },

        // Optional styling
        barColor: kNavBarBgColor,
        notchColor: kNavBarBgColor,
        showLabel: true,
        kBottomRadius: 28.0,
        kIconSize: 24.0,
        bottomBarWidth: 500,
      ),
    );
  }
}
