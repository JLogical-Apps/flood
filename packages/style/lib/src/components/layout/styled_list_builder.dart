import 'package:flutter/material.dart';
import 'package:style/src/components/layout/styled_list.dart';

class StyledListBuilder {
  bool isScrollable = false;
  bool hasScrollbar = false;
  Axis axis;
  bool isCentered = false;
  double? childMinSize;
  MainAxisSize mainAxisSize = MainAxisSize.max;

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

  StyledListBuilder get shrink {
    mainAxisSize = MainAxisSize.min;
    return this;
  }

  StyledListBuilder withMinChildSize(double? childMinSize) {
    this.childMinSize = childMinSize;
    return this;
  }

  StyledList call({
    Key? key,
    List<Widget> children = const [],
    EdgeInsets? itemPadding,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    Widget? ifEmpty,
    String? ifEmptyText,
  }) {
    return StyledList(
      key: key,
      children: children,
      axis: axis,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      hasScrollbar: hasScrollbar,
      isScrollable: isScrollable,
      isCentered: isCentered,
      itemPadding: itemPadding ?? EdgeInsets.all(4),
      childMinSize: childMinSize,
      ifEmpty: ifEmpty,
      ifEmptyText: ifEmptyText,
    );
  }
}
