import 'package:flutter/material.dart';
import 'package:intersperse/intersperse.dart';
import 'package:style/src/components/layout/styled_list.dart';
import 'package:style/src/style_renderer.dart';

class FlatStyleListRenderer with IsTypedStyleRenderer<StyledList> {
  @override
  Widget renderTyped(BuildContext context, StyledList component) {
    Widget widget = Column(
      children: component.children.intersperse(SizedBox(height: component.padding)).toList(),
    );

    if (component.isScrollable) {
      widget = SingleChildScrollView(child: widget);

      if (component.hasScrollbar) {
        widget = Scrollbar(child: widget);
      }
    }

    return widget;
  }
}
