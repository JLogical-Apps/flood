import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_text.dart';

import '../../style.dart';
import '../../style_context.dart';

class StyledSubtitleText extends StyledText {
  const StyledSubtitleText(String text, {Key? key}) : super(key: key, text: text);

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.subtitleText(styleContext, this);
  }
}
