import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/style/style_context.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_text.dart';

import '../../style.dart';
import 'styled_text_overrides.dart';
import 'styled_text_style.dart';

class StyledErrorText extends StyledText {
  const StyledErrorText(String text, {Key? key, StyledTextOverrides? textOverrides})
      : super(
          key: key,
          text: text,
          overrides: textOverrides,
        );

  @override
  StyledTextStyle getStyle(Style style, StyleContext styleContext) {
    return style.bodyTextStyle(styleContext).copyWith(
          fontColor: Colors.red,
        );
  }
}
