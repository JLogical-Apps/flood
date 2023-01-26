import 'package:flutter/material.dart';
import 'package:style/src/style_component.dart';

class StyledDialog<T> extends StyleComponent {
  final Widget? title;
  final String? titleText;

  final Widget? body;
  final String? bodyText;

  StyledDialog({
    this.title,
    this.titleText,
    this.body,
    this.bodyText,
  });
}
