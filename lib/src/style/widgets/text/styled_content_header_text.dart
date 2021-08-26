import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_text.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_text_overrides.dart';

import '../../style.dart';
import '../../style_context.dart';

class StyledContentHeaderText extends StyledText {
  const StyledContentHeaderText(String text, {Key? key, StyledTextOverrides? textOverrides})
      : super(
          key: key,
          text: text,
          overrides: textOverrides,
        );

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.contentHeaderText(styleContext, this);
  }
}
