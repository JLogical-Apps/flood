import 'package:flutter/material.dart';

import '../../style.dart';
import '../../style_context.dart';
import '../../styled_widget.dart';

class StyledDivider extends StyledWidget {
  const StyledDivider({Key? key}) : super(key: key);

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.divider(context, styleContext, this);
  }
}
