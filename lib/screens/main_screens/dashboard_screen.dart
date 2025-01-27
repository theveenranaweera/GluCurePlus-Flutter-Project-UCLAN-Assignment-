import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import '../../widgets/custom_notch_nav_bar_widget.dart';
import 'dashboard_body.dart';
import 'add_sugar/add_sugar_screen.dart';
import 'constants_for_main_screens.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
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

    // -- Tab 2: Analytics page
    const Center(
      child: Text(
        "Analytics Page",
        style: TextStyle(fontSize: 24),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kOffWhiteBgColor,

      /// Wrap multiple pages in a PageView to swipe or jump via the bottom bar
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
            activeItem: const Icon(Iconsax.home, color: Colors.white),
            itemLabel: 'Home',
          ),
          BottomBarItem(
            inActiveItem: const Icon(Iconsax.add, color: Colors.grey),
            activeItem: const Icon(Iconsax.add, color: Colors.white),
            itemLabel: 'Add',
          ),
          BottomBarItem(
            inActiveItem: const Icon(Iconsax.diagram, color: Colors.grey),
            activeItem: const Icon(Iconsax.diagram, color: Colors.white),
            itemLabel: 'Analytics',
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
