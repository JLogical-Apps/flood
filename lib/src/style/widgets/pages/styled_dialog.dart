import 'package:flutter/cupertino.dart';

/// Not a widget. Used to provide information for [Style.showDialog].
class StyledDialog {
  /// The title of the dialog.
  final String? titleText;

  /// If [titleText] is null, uses this as the title of the dialog.
  final Widget? title;

  /// The body of the dialog.
  final Widget body;

  const StyledDialog({
    this.titleText,
    this.title,
    required this.body,
  });
}
