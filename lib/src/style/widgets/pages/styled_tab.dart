import 'package:flutter/cupertino.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class StyledTab {
  final String? title;
  final Widget body;

  final Widget? icon;
  final Color? backgroundColor;

  final List<ActionItem> actions;

  const StyledTab({
    this.title,
    required this.body,
    this.icon,
    this.backgroundColor,
    this.actions: const [],
  });
}
