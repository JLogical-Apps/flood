import 'package:flutter/material.dart';
import 'package:style/src/style_component.dart';

class StyledTabs extends StyleComponent {
  final List<StyledTab> tabs;

  StyledTabs({required this.tabs});
}

class StyledTab {
  final String? titleText;
  final IconData icon;

  final Widget child;

  StyledTab({required this.titleText, required this.icon, required this.child});
}
