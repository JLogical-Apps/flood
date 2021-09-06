import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_text.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_text_overrides.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_text_style.dart';

class StyledTitleText extends StyledText {
  const StyledTitleText(String text, {Key? key, StyledTextOverrides? textOverrides})
      : super(
          key: key,
          text: text,
          overrides: textOverrides,
        );

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.text(context, styleContext, this);
  }

  @override
  StyledTextStyle getStyle(Style style, StyleContext styleContext) {
    return style.titleTextStyle(styleContext);
  }
}
