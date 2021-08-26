import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_text.dart';

class StyledContentSubtitleText extends StyledText {
  const StyledContentSubtitleText(String text, {Key? key}) : super(key: key, text: text);

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.contentSubtitleText(styleContext, this);
  }
}
