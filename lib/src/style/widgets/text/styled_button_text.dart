import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class StyledButtonText extends StyledWidget {
  final String text;

  final Color? textColor;

  const StyledButtonText(this.text, {Key? key, this.textColor}) : super(key: key);

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.buttonText(styleContext, this);
  }
}
