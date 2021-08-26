import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_text.dart';

class StyledButtonText extends StyledText {
  const StyledButtonText(String text, {Key? key, Color? fontColorOverride})
      : super(
          key: key,
          text: text,
          fontColorOverride: fontColorOverride,
        );

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.buttonText(styleContext, this);
  }
}
