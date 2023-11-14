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
  final Border? border;

  StyledContainer({
    this.emphasis = Emphasis.regular,
    this.child,
    this.onPressed,
    this.color,
    this.width,
    this.height,
    this.padding = EdgeInsets.zero,
    this.shape,
    this.border,
  });

  StyledContainer.subtle({
    this.child,
    this.onPressed,
    this.color,
    this.width,
    this.height,
    this.padding = EdgeInsets.zero,
    this.shape,
    this.border,
  }) : emphasis = Emphasis.subtle;

  StyledContainer.strong({
    this.child,
    this.onPressed,
    this.color,
    this.width,
    this.height,
    this.padding = EdgeInsets.zero,
    this.shape,
    this.border,
  }) : emphasis = Emphasis.strong;
}
