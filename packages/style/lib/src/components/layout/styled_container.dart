import 'package:flutter/material.dart';
import 'package:style/src/emphasis.dart';
import 'package:style/src/style_component.dart';

class StyledContainer extends StyleComponent {
  final Emphasis emphasis;
  final Widget? child;
  final double? width;
  final double? height;

  StyledContainer({
    this.emphasis = Emphasis.regular,
    this.child,
    this.width,
    this.height,
  });
}
