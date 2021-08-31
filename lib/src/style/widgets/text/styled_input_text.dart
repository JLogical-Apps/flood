import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class StyledInputText extends StyledWidget {
  final String text;

  final Color? color;

  const StyledInputText(this.text, {Key? key, this.color}) : super(key: key);

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return StyledBodyText(
      text,
      textOverrides: StyledTextOverrides(
        fontWeight: FontWeight.bold,
        fontColor: color ?? styleContext.emphasisColor,
      ),
    );
  }
}
