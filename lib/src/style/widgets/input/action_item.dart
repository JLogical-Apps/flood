import 'package:flutter/material.dart';

import '../../emphasis.dart';

/// An action that can be performed.
class ActionItem {
  final String name;
  final String? description;

  final IconData? icon;

  final Color? color;
  final Emphasis emphasis;

  final VoidCallback? onPerform;
  final void Function(BuildContext context)? onPerformWithContext;

  const ActionItem({
    required this.name,
    this.description,
    this.icon,
    this.color,
    this.emphasis: Emphasis.medium,
    this.onPerform,
    this.onPerformWithContext,
  });

  const ActionItem.high({
    required this.name,
    this.description,
    this.icon,
    this.color,
    this.onPerform,
    this.onPerformWithContext,
  }) : emphasis = Emphasis.high;

  const ActionItem.medium({
    required this.name,
    this.description,
    this.icon,
    this.color,
    this.onPerform,
    this.onPerformWithContext,
  }) : emphasis = Emphasis.medium;

  const ActionItem.low({
    required this.name,
    this.description,
    this.icon,
    this.color,
    this.onPerform,
    this.onPerformWithContext,
  }) : emphasis = Emphasis.low;

  void perform(BuildContext context) {
    if (onPerformWithContext != null) {
      onPerformWithContext!(context);
    }

    if (onPerform != null) {
      onPerform!();
    }
  }
}
