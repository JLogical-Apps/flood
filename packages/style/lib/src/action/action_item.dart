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

class ActionItemStatic {
  ActionItem edit({
    required String contentTypeName,
    String? title,
    String? description,
    FutureOr Function(BuildContext context)? onPerform,
  }) {
    return ActionItem(
      titleText: title ?? 'Edit $contentTypeName',
      descriptionText: description ?? 'Edit this $contentTypeName.',
      iconData: Icons.edit,
      color: Colors.orange,
      onPerform: onPerform,
    );
  }

  ActionItem duplicate({
    required String contentTypeName,
    String? title,
    String? description,
    FutureOr Function(BuildContext context)? onPerform,
  }) {
    return ActionItem(
      titleText: title ?? 'Duplicate $contentTypeName',
      descriptionText: description ?? 'Duplicate this $contentTypeName.',
      iconData: Icons.copy,
      color: Colors.blue,
      onPerform: onPerform,
    );
  }

  ActionItem delete({
    required String contentTypeName,
    String? title,
    String? description,
    FutureOr Function(BuildContext context)? onPerform,
  }) {
    return ActionItem(
      titleText: title ?? 'Delete $contentTypeName',
      descriptionText: description ?? 'Delete this $contentTypeName.',
      iconData: Icons.delete,
      color: Colors.red,
      onPerform: onPerform,
    );
  }
}
