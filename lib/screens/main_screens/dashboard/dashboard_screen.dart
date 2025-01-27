import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import '../../../widgets/custom_notch_nav_bar_widget.dart';
import 'dashboard_body.dart';

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
    const Center(
      child: Text(
        "Add Sugar Page",
        style: TextStyle(fontSize: 24),
      ),
    ),

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
      backgroundColor: const Color(0xFFE4E5E0),

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

        // Optional styling
        barColor: const Color(0xFF262135),
        notchColor: const Color(0xFF262135),
        showLabel: true,
        kBottomRadius: 28.0,
        kIconSize: 24.0,
        bottomBarWidth: 500,
        // etc. if needed
      ),
    );
  }
}
