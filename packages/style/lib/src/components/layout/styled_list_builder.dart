import 'package:flutter/material.dart';
import 'package:style/src/components/layout/styled_list.dart';

class StyledListBuilder {
  bool isScrollable = false;
  bool hasScrollbar = false;
  Axis axis;
  bool isCentered = false;
  EdgeInsets? itemPadding;
  double? childMinSize;

  StyledListBuilder({this.axis = Axis.vertical});

  StyledListBuilder get scrollable {
    isScrollable = true;
    return this;
  }

  StyledListBuilder get withScrollbar {
    isScrollable = true;
    hasScrollbar = true;
    return this;
  }

  StyledListBuilder get centered {
    isCentered = true;
    return this;
  }

  StyledListBuilder withPadding(EdgeInsets? padding) {
    this.itemPadding = padding;
    return this;
  }

  StyledListBuilder withMinChildSize(double? childMinSize) {
    this.childMinSize = childMinSize;
    return this;
  }

  StyledList call({
    Key? key,
    List<Widget> children = const [],
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return StyledList(
      key: key,
      children: children,
      axis: axis,
      crossAxisAlignment: crossAxisAlignment,
      hasScrollbar: hasScrollbar,
      isScrollable: isScrollable,
      isCentered: isCentered,
      itemPadding: itemPadding ?? EdgeInsets.all(4),
      childMinSize: childMinSize,
    );
  }
}
