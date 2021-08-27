import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class ActionItem {
  final String name;
  final String? description;
  final Widget? lead;
  final Color? color;

  final VoidCallback? onPerform;

  const ActionItem({
    required this.name,
    this.description,
    this.lead,
    this.color,
    this.onPerform,
  });

  IconData? get icon => lead?.as<Icon>()?.icon ?? lead?.as<StyledIcon>()?.iconData;
}
