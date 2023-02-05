import 'dart:async';

import 'package:flutter/material.dart';
import 'package:style/src/emphasis.dart';
import 'package:style/src/style_component.dart';

class StyledContainer extends StyleComponent {
  final Emphasis emphasis;
  final Widget? child;
  final FutureOr Function()? onPressed;
  final Color? color;
  final double? width;
  final double? height;
  final EdgeInsets padding;
  final ShapeBorder? shape;

  StyledContainer({
    this.emphasis = Emphasis.regular,
    this.child,
    this.onPressed,
    this.color,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(8),
    this.shape,
  });

  StyledContainer.subtle({
    this.child,
    this.onPressed,
    this.color,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(8),
    this.shape,
  }) : emphasis = Emphasis.subtle;

  StyledContainer.strong({
    this.child,
    this.onPressed,
    this.color,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(8),
    this.shape,
  }) : emphasis = Emphasis.strong;
}
