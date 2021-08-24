import 'package:flutter/material.dart';

import '../../style.dart';
import '../../style_context.dart';
import '../../styled_widget.dart';

class StyledContentHeaderText extends StyledWidget {
  final String text;

  const StyledContentHeaderText(this.text, {Key? key}) : super(key: key);

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.contentHeaderText(styleContext, this);
  }
}
