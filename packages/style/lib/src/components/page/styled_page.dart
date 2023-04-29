import 'package:flutter/material.dart';
import 'package:style/src/action/action_item.dart';
import 'package:style/src/style_component.dart';

class StyledPage extends StyleComponent {
  final Widget? title;
  final String? titleText;

  final Widget body;

  final List<ActionItem> actions;

  final EdgeInsets innerPadding;

  StyledPage({
    this.title,
    this.titleText,
    required this.body,
    this.actions = const [],
    this.innerPadding = const EdgeInsets.all(4),
  });
}
