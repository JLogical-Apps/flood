import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_text.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_text_style.dart';

class StyledInputText extends StyledText {
  const StyledInputText(String text, {Key? key, StyledTextOverrides? textOverrides})
      : super(
          key: key,
          text: text,
          overrides: textOverrides,
        );

  @override
  StyledTextStyle getStyle(Style style, StyleContext styleContext) {
    return style.bodyTextStyle(styleContext).copyWith(
          fontColor: styleContext.emphasisColor,
          fontWeight: FontWeight.bold,
        );
  }
}
