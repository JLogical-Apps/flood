import 'dart:async';

import 'package:flutter/material.dart';
import 'package:style/style.dart';
import 'package:utils/utils.dart';

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

  ActionItem.edit({String? contentType, String? titleText, String? descriptionText, this.onPerform})
      : title = null,
        titleText = titleText ?? contentType?.mapIfNonNull((contentType) => 'Edit ${contentType.titleCase}'),
        description = null,
        descriptionText = descriptionText ??
            contentType?.mapIfNonNull((contentType) => 'Edit this ${contentType.titleCase.toLowerCase()}.'),
        icon = null,
        iconData = Icons.edit,
        color = Colors.orange;

  ActionItem.delete(
    BuildContext context, {
    required Future Function() onDelete,
    String? contentType,
    String? titleText,
    String? descriptionText,
    String? confirmationTitleText,
    String? confirmationBodyText,
  })  : title = null,
        titleText = titleText ?? contentType?.mapIfNonNull((contentType) => 'Delete ${contentType.titleCase}'),
        description = null,
        descriptionText = descriptionText ??
            contentType?.mapIfNonNull((contentType) => 'Delete this ${contentType.titleCase.toLowerCase()}.'),
        icon = null,
        iconData = Icons.delete,
        color = Colors.red,
        onPerform = _defaultDelete(
          context,
          onDelete: onDelete,
          contentType: contentType,
          titleText: confirmationTitleText,
          bodyText: confirmationBodyText,
        );
}

Future<void> Function(BuildContext context) _defaultDelete(
  BuildContext context, {
  required Future Function() onDelete,
  String? contentType,
  String? titleText,
  String? bodyText,
}) {
  return (_) async {
    await context.showStyledDialog(StyledDialog.yesNo(
      titleText: titleText ?? 'Confirm Delete',
      bodyText: bodyText ??
          'Are you sure you want to delete this${contentType == null ? '' : ' ${contentType.titleCase.toLowerCase()}'}? You cannot undo this.',
      onAccept: onDelete,
    ));
  };
}
