import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

/// An action that can be performed.
class ActionItem {
  final String name;
  final String? description;

  /// The widget to display alongside this action.
  final Widget? leading;
  final Color? color;
  final ActionItemType type;

  final VoidCallback? onPerform;

  const ActionItem({
    required this.name,
    this.description,
    this.leading,
    this.color,
    this.type: ActionItemType.primary,
    this.onPerform,
  });

  /// The icon associated with the action.
  /// This is extracted from [leading].
  IconData? get icon => leading?.as<Icon>()?.icon ?? leading?.as<StyledIcon>()?.iconData;
}

enum ActionItemType {
  /// Action that is easily viewable/accessible.
  primary,

  /// Action that is more subtle.
  secondary
}
