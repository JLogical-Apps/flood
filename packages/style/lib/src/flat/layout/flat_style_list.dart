import 'package:flutter/material.dart';
import 'package:intersperse/intersperse.dart';
import 'package:style/src/components/layout/styled_list.dart';
import 'package:style/src/style_build_context_extensions.dart';
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
        widget = MediaQuery.removePadding(
          context: context,
          removeTop: true,
          removeBottom: true,
          child: RawScrollbar(
            child: widget,
            controller: scrollController,
            thumbColor: context.colorPalette().foreground.regular.withOpacity(0.6),
            trackColor: context.colorPalette().background.subtle,
            // trackBorderColor: Colors.red,
            radius: Radius.circular(12),
            trackRadius: Radius.circular(12),
          ),
        );
      }
    }

    return widget;
  }
}
