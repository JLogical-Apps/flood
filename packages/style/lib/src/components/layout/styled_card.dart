import 'package:flutter/material.dart';
import 'package:style/src/emphasis.dart';
import 'package:style/src/style_component.dart';

class StyledCard extends StyleComponent {
  final Emphasis emphasis;
  final Widget? title;
  final String? titleText;
  final Widget? body;
  final String? bodyText;
  final List<Widget> children;
  final Widget? leading;
  final IconData? leadingIcon;
  final Widget? trailing;
  final IconData? trailingIcon;
  final Color? color;
  final double? width;
  final double? height;
  final EdgeInsets padding;

  StyledCard({
    this.emphasis = Emphasis.regular,
    this.title,
    this.titleText,
    this.body,
    this.bodyText,
    this.children = const [],
    this.leading,
    this.leadingIcon,
    this.trailing,
    this.trailingIcon,
    this.color,
    this.width,
    this.height,
    this.padding = EdgeInsets.zero,
  });

  StyledCard.subtle({
    this.title,
    this.titleText,
    this.body,
    this.bodyText,
    this.children = const [],
    this.leading,
    this.leadingIcon,
    this.trailing,
    this.trailingIcon,
    this.color,
    this.width,
    this.height,
    this.padding = EdgeInsets.zero,
  }) : emphasis = Emphasis.subtle;

  StyledCard.strong({
    this.title,
    this.titleText,
    this.body,
    this.bodyText,
    this.children = const [],
    this.leading,
    this.leadingIcon,
    this.trailing,
    this.trailingIcon,
    this.color,
    this.width,
    this.height,
    this.padding = EdgeInsets.zero,
  }) : emphasis = Emphasis.strong;
}
