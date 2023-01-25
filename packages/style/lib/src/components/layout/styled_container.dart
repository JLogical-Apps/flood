import 'package:flutter/material.dart';
import 'package:style/src/emphasis.dart';
import 'package:style/src/style_component.dart';

class StyledContainer extends StyleComponent {
  final Emphasis emphasis;
  final Widget? child;
  final Color? color;
  final double? width;
  final double? height;
  final EdgeInsets padding;

  StyledContainer({
    this.emphasis = Emphasis.regular,
    this.child,
    this.color,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(8),
  });

  StyledContainer.subtle({
    this.child,
    this.color,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(8),
  }) : emphasis = Emphasis.subtle;

  StyledContainer.strong({
    this.child,
    this.color,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(8),
  }) : emphasis = Emphasis.strong;
}
