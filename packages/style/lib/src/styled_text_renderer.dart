import 'package:flutter/material.dart';
import 'package:style/src/components/text/styled_text.dart';

abstract class StyledTextRenderer {
  bool shouldWrap(StyledText text);

  TextStyle getTextStyle(BuildContext context, StyledText text);
}

mixin IsTypedStyleTextRenderer<T extends StyledText> implements StyledTextRenderer {
  @override
  bool shouldWrap(StyledText text) {
    return text is T;
  }
}
