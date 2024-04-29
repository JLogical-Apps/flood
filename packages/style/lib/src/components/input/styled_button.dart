import 'package:flutter/material.dart';
import 'package:style/src/emphasis.dart';
import 'package:style/src/style_component.dart';

class StyledButton extends StyleComponent {
  final Widget? label;
  final String? labelText;

  final Widget? icon;
  final IconData? iconData;

  final Function()? onPressed;

  final Emphasis emphasis;
  final Color? backgroundColor;
  final bool isTextButton;

  StyledButton({
    super.key,
    this.label,
    this.labelText,
    this.icon,
    this.iconData,
    required this.onPressed,
    this.emphasis = Emphasis.regular,
    this.backgroundColor,
    this.isTextButton = false,
  });

  StyledButton.subtle({
    super.key,
    this.label,
    this.labelText,
    this.icon,
    this.iconData,
    required this.onPressed,
    this.backgroundColor,
    this.isTextButton = false,
  }) : emphasis = Emphasis.subtle;

  StyledButton.strong({
    super.key,
    this.label,
    this.labelText,
    this.icon,
    this.iconData,
    required this.onPressed,
    this.backgroundColor,
    this.isTextButton = false,
  }) : emphasis = Emphasis.strong;
}
