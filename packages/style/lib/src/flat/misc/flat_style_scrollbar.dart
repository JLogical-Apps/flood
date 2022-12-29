import 'package:flutter/material.dart';
import 'package:style/src/components/misc/styled_scrollbar.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';

class FlatStyleScrollbarRenderer with IsTypedStyleRenderer<StyledScrollbar> {
  @override
  Widget renderTyped(BuildContext context, StyledScrollbar component) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      child: RawScrollbar(
        child: component.child,
        controller: component.controller,
        thumbColor: context.colorPalette().foreground.regular.withOpacity(0.6),
        trackColor: context.colorPalette().background.subtle,
        radius: Radius.circular(12),
        trackRadius: Radius.circular(12),
      ),
    );
  }
}
