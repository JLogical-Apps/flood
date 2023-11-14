import 'package:flutter/material.dart';
import 'package:style/src/emphasis.dart';
import 'package:style/src/style_component.dart';

class StyledIcon extends StyleComponent {
  final IconData iconData;
  final Emphasis emphasis;
  final Color? color;
  final Color? backgroundColor;
  final double? size;

  StyledIcon(
    this.iconData, {
    this.emphasis = Emphasis.regular,
    this.color,
    this.backgroundColor,
    this.size,
  });

  StyledIcon.subtle(
    this.iconData, {
    this.color,
    this.backgroundColor,
    this.size,
  }) : emphasis = Emphasis.subtle;

  StyledIcon.strong(
    this.iconData, {
    this.color,
    this.backgroundColor,
    this.size,
  }) : emphasis = Emphasis.strong;
}
