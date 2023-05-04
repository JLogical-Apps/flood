import 'package:flutter/material.dart';
import 'package:style/src/emphasis.dart';
import 'package:style/src/style_component.dart';

class StyledChip extends StyleComponent {
  final Widget? label;
  final String? labelText;

  final Widget? icon;
  final IconData? iconData;

  final Function()? onPressed;

  final Color? backgroundColor;

  final Emphasis emphasis;

  StyledChip({
    this.label,
    this.labelText,
    this.icon,
    this.iconData,
    this.onPressed,
    this.backgroundColor,
    this.emphasis = Emphasis.regular,
  });

  StyledChip.subtle({
    this.label,
    this.labelText,
    this.icon,
    this.iconData,
    this.backgroundColor,
    this.onPressed,
  }) : emphasis = Emphasis.subtle;

  StyledChip.strong({
    this.label,
    this.labelText,
    this.icon,
    this.iconData,
    this.backgroundColor,
    this.onPressed,
  }) : emphasis = Emphasis.strong;
}
