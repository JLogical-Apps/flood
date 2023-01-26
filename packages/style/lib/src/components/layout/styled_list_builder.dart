import 'package:flutter/material.dart';
import 'package:style/src/components/layout/styled_list.dart';

class StyledListBuilder {
  bool isScrollable = false;
  bool hasScrollbar = false;
  Axis axis;
  bool isCentered = false;

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

  StyledList call({Key? key, List<Widget> children = const []}) {
    return StyledList(
      key: key,
      children: children,
      axis: axis,
      hasScrollbar: hasScrollbar,
      isScrollable: isScrollable,
      isCentered: isCentered,
    );
  }
}
