import 'package:flutter/material.dart';
import 'package:style/src/components/layout/styled_list_builder.dart';
import 'package:style/src/style_component.dart';

class StyledList extends StyleComponent {
  final List<Widget> children;
  final Axis axis;

  final bool isScrollable;
  final bool hasScrollbar;
  final EdgeInsets itemPadding;
  final bool isCentered;

  StyledList({
    super.key,
    required this.children,
    this.axis = Axis.vertical,
    this.isScrollable = false,
    this.hasScrollbar = false,
    this.itemPadding = const EdgeInsets.all(4),
    this.isCentered = false,
  });

  static StyledListBuilder get column => StyledListBuilder(axis: Axis.vertical);

  static StyledListBuilder get row => StyledListBuilder(axis: Axis.horizontal);
}
