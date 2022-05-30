import 'package:flutter/material.dart';

/// An action that can be performed.
class ActionItem {
  final String name;
  final String? description;

  final IconData? icon;

  final Color? color;
  final ActionItemType type;

  final VoidCallback? onPerform;
  final void Function(BuildContext context)? onPerformWithContext;

  const ActionItem({
    required this.name,
    this.description,
    this.icon,
    this.color,
    this.type: ActionItemType.primary,
    this.onPerform,
    this.onPerformWithContext,
  });

  void perform(BuildContext context) {
    if (onPerformWithContext != null) {
      onPerformWithContext!(context);
    }

    if (onPerform != null) {
      onPerform!();
    }
  }
}

enum ActionItemType {
  /// Action that is easily viewable/accessible.
  primary,

  /// Action that is more subtle.
  secondary
}
