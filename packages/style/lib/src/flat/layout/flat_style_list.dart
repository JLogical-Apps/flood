import 'package:flutter/material.dart';
import 'package:intersperse/intersperse.dart';
import 'package:style/src/components/layout/styled_list.dart';
import 'package:style/src/components/misc/styled_scrollbar.dart';
import 'package:style/src/style_renderer.dart';

class FlatStyleListRenderer with IsTypedStyleRenderer<StyledList> {
  @override
  Widget renderTyped(BuildContext context, StyledList component) {
    final children =
        component.children.intersperse(SizedBox(width: component.padding, height: component.padding)).toList();
    Widget widget = component.axis == Axis.vertical ? Column(children: children) : Row(children: children);

    if (component.isScrollable) {
      final scrollController = ScrollController();

      widget = SingleChildScrollView(
        child: widget,
        controller: scrollController,
        scrollDirection: component.axis,
        physics: BouncingScrollPhysics(),
      );

      if (component.hasScrollbar) {
        widget = StyledScrollbar(
          child: widget,
          controller: scrollController,
        );
      }
    }

    return widget;
  }
}
