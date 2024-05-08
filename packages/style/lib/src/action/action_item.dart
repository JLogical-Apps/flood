import 'dart:async';

import 'package:flutter/material.dart';

class ActionItem {
  final Widget? title;
  final String? titleText;

  final Widget? description;
  final String? descriptionText;

  final Widget? icon;
  final IconData? iconData;

  final Color? color;

  final FutureOr Function(BuildContext context)? onPerform;

  ActionItem({
    this.title,
    this.titleText,
    this.description,
    this.descriptionText,
    this.icon,
    this.iconData,
    this.color,
    this.onPerform,
  });

  static ActionItemStatic static = ActionItemStatic();
}

class ActionItemStatic {}
