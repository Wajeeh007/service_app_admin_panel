import 'package:flutter/material.dart';
import '../constants.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({
    super.key,
    required this.controller,
    required this.tabsNames,
    this.maxWidth = 670,
  });

  final TabController controller;
  final double maxWidth;
  final List<String> tabsNames;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      constraints: BoxConstraints(
          maxWidth: maxWidth,
      ),
      decoration: BoxDecoration(
          color: primaryWhite,
          borderRadius: kContainerBorderRadius,
          border: kContainerBorderSide
      ),
      child: TabBar(
          overlayColor: WidgetStatePropertyAll(Colors.transparent),
          physics: NeverScrollableScrollPhysics(),
          tabAlignment: TabAlignment.start,
          padding: EdgeInsets.zero,
          isScrollable: true,
          labelPadding: EdgeInsets.symmetric(horizontal: 3),
          labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(color: primaryWhite),
          unselectedLabelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: primaryGrey
          ),
          dividerColor: Colors.transparent,
          indicator: BoxDecoration(
            color: primaryBlue,
            borderRadius: kContainerBorderRadius,
          ),
          controller: controller,
          tabs: List.generate(tabsNames.length, (index) {
            return _TabWidget(text: tabsNames[index]);
          })
      ),
    );
  }
}

/// Tab widget
class _TabWidget extends StatelessWidget {
  const _TabWidget({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
      child: Text(
        text,
      ),
    );
  }
}
