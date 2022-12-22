import 'package:flutter/material.dart';
import 'package:style/src/style_component.dart';

class StyledList extends StyleComponent {
  final List<Widget> children;
  final bool isScrollable;
  final bool hasScrollbar;
  final double padding;

  StyledList({
    required this.children,
    this.isScrollable = true,
    this.hasScrollbar = true,
    this.padding = 8,
  });
}
