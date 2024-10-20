import 'package:flutter/material.dart';
import 'package:style/src/action/action_item.dart';
import 'package:style/src/style_component.dart';

class StyledSection extends StyleComponent {
  final Widget? title;
  final String? titleText;
  final List<Widget> children;
  final CrossAxisAlignment alignment;
  final Widget? leading;
  final IconData? leadingIcon;
  final Widget? trailing;
  final IconData? trailingIcon;
  final List<ActionItem> actions;
  final double? width;
  final double? height;
  final EdgeInsets padding;

  StyledSection({
    super.key,
    this.title,
    this.titleText,
    this.children = const [],
    this.alignment = CrossAxisAlignment.center,
    this.leading,
    this.leadingIcon,
    this.trailing,
    this.trailingIcon,
    this.actions = const [],
    this.width,
    this.height,
    this.padding = EdgeInsets.zero,
  });
}
