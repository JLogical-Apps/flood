import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class StyledContentSubtitleText extends StyledWidget {
  final String text;

  const StyledContentSubtitleText(this.text, {Key? key}) : super(key: key);

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.contentSubtitleText(styleContext, this);
  }
}
