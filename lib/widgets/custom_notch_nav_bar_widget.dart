/// A reusable widget that wraps the AnimatedNotchBottomBar
/// and handles the onTap callback to jump the PageController.
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';

/// A reusable widget that wraps the [AnimatedNotchBottomBar]
/// and handles the onTap callback to jump the [PageController].
class CustomNotchNavBar extends StatelessWidget {
  /// The [NotchBottomBarController] required by the package.
  final NotchBottomBarController controller;

  /// The [PageController] used by the PageView in your main screen.
  final PageController pageController;

  /// The items displayed in the bottom bar.
  final List<BottomBarItem> bottomBarItems;

  /// (Optional) The max number of bottom bar pages.
  final int maxCount;

  /// Show or hide labels under icons.
  final bool showLabel;

  /// The bar's background color.
  final Color barColor;

  /// The notch's color.
  final Color notchColor;

  /// Radius for bottom corners.
  final double kBottomRadius;

  /// Icon size in the bar.
  final double kIconSize;

  /// Whether to remove horizontal margins.
  final bool removeMargins;

  /// The bottom bar's total width.
  final double bottomBarWidth;

  /// Elevation / shadow for the bar.
  final double elevation;

  /// Duration for the bar’s item animations.
  final Duration animationDuration;

  /// Style for item labels.
  final TextStyle? itemLabelStyle;

  const CustomNotchNavBar({
    Key? key,
    required this.controller,
    required this.pageController,
    required this.bottomBarItems,
    this.maxCount = 5,
    this.showLabel = true,
    this.barColor = Colors.white,
    this.notchColor = Colors.black87,
    this.kBottomRadius = 28.0,
    this.kIconSize = 24.0,
    this.removeMargins = false,
    this.bottomBarWidth = 500,
    this.elevation = 1,
    this.animationDuration = const Duration(milliseconds: 300),
    this.itemLabelStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final int itemLength = bottomBarItems.length;

    return AnimatedNotchBottomBar(
      notchBottomBarController: controller,
      bottomBarItems: bottomBarItems,
      color: barColor,
      notchColor: notchColor,
      showLabel: showLabel,
      removeMargins: removeMargins,
      bottomBarWidth: bottomBarWidth,
      elevation: elevation,
      kBottomRadius: kBottomRadius,
      kIconSize: kIconSize,
      durationInMilliSeconds: animationDuration.inMilliseconds,
      itemLabelStyle: itemLabelStyle ?? const TextStyle(fontSize: 10),
      onTap: (index) {
        log('Animated Notch Bar: tapped index => $index');
        pageController.jumpToPage(index);
      },
    );
  }
}
