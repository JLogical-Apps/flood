import 'package:flutter/material.dart';

import '../../../../jlogical_utils.dart';

class StyledDivider extends StyledWidget {
  const StyledDivider({Key? key}) : super(key: key);

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.divider(context, styleContext, this);
  }
}
