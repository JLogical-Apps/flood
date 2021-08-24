import 'package:flutter/material.dart';

import '../../style.dart';
import '../../style_context.dart';
import '../../styled_widget.dart';

class StyledBodyText extends StyledWidget {
  final String text;

  const StyledBodyText(this.text, {Key? key}) : super(key: key);

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.bodyText(styleContext, this);
  }
}
