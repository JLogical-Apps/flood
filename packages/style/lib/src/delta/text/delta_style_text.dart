import 'package:flutter/material.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';

class DeltaStyleTextRenderer with IsTypedStyleRenderer<StyledText> {
  @override
  Widget renderTyped(BuildContext context, StyledText component) {
    return Padding(
      padding: component.padding ?? EdgeInsets.zero,
      child: Text(
        component.text,
        textAlign: component.textAlign,
        style: context.style().getTextStyle(context, component),
        overflow: TextOverflow.fade,
      ),
    );
  }
}
