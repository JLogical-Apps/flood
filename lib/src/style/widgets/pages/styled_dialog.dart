import 'package:flutter/cupertino.dart';

class StyledDialog {
  final String? title;
  final Widget? titleWidget;

  final Widget body;

  const StyledDialog({
    this.title,
    this.titleWidget,
    required this.body,
  });
}
