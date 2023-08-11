import 'dart:async';

import 'package:flutter/material.dart';
import 'package:style/src/action/action_item.dart';
import 'package:style/src/style_component.dart';

class StyledPage extends StyleComponent {
  final Widget? title;
  final String? titleText;

  final Widget body;

  final List<Widget> actionWidgets;
  final List<ActionItem> actions;

  final FutureOr<bool> Function()? shouldPop;

  final EdgeInsets innerPadding;

  StyledPage({
    this.title,
    this.titleText,
    required this.body,
    this.actionWidgets = const [],
    this.actions = const [],
    this.shouldPop,
    this.innerPadding = const EdgeInsets.all(4),
  });
}
