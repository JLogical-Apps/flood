import 'package:flutter/material.dart';
import 'package:intersperse/intersperse.dart';
import 'package:style/src/components/layout/styled_list.dart';
import 'package:style/src/style_renderer.dart';

class FlatStyleListRenderer with IsTypedStyleRenderer<StyledList> {
  @override
  Widget renderTyped(BuildContext context, StyledList component) {
    final children =
        component.children.intersperse(SizedBox(width: component.padding, height: component.padding)).toList();
    Widget widget = component.axis == Axis.vertical ? Column(children: children) : Row(children: children);

    if (component.isScrollable) {
      widget = SingleChildScrollView(child: widget, scrollDirection: component.axis);

      if (component.hasScrollbar) {
        widget = MediaQuery.removePadding(
          context: context,
          removeTop: true,
          removeBottom: true,
          child: Scrollbar(child: widget),
        );
      }
    }

    return widget;
  }
}
