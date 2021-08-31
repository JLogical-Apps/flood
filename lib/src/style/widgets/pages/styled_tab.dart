import 'package:flutter/cupertino.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

/// Not a widget. Used to store information for [StyledTabbedPage].
class StyledTab {
  final String title;
  final Widget body;

  final Widget? icon;
  final Color? backgroundColor;

  final List<ActionItem>? actions;

  const StyledTab({
    required this.title,
    required this.body,
    this.icon,
    this.backgroundColor,
    this.actions,
  });
}
