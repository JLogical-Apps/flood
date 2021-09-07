import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_text.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_text_overrides.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_text_style.dart';

import '../../style.dart';
import '../../style_context.dart';

class StyledBodyText extends StyledText {
  const StyledBodyText(String text, {Key? key, StyledTextOverrides? textOverrides})
      : super(
          key: key,
          text: text,
          overrides: textOverrides,
        );

  @override
  StyledTextStyle getStyle(Style style, StyleContext styleContext) {
    return style.bodyTextStyle(styleContext);
  }
}
