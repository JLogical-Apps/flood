import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/style/style_context.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_text.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_text_overrides.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_text_style.dart';

import '../../style.dart';

class StyledContentSubtitleText extends StyledText {
  const StyledContentSubtitleText(String text, {Key? key, StyledTextOverrides? textOverrides})
      : super(
          key: key,
          text: text,
          overrides: textOverrides,
        );

  @override
  StyledTextStyle getStyle(Style style, StyleContext styleContext) {
    return style.contentSubtitleTextStyle(styleContext);
  }
}