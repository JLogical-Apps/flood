import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

import '../../styled_widget.dart';

class StyledTitleText extends StyledWidget {
  final String text;

  const StyledTitleText(this.text, {Key? key}) : super(key: key);

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.titleText(styleContext, this);
  }
}
